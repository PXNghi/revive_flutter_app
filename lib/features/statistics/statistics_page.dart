import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:revive_flutter_project/core/constants/ui_values.dart';
import 'package:revive_flutter_project/features/product/model/category.dart';
import 'package:revive_flutter_project/features/statistics/bloc/statistics_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:revive_flutter_project/features/statistics/models/monthly_revenue.dart';
import 'package:revive_flutter_project/features/statistics/models/product_sales.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: pageHorizontalPadding,
          child: BlocBuilder<StatisticsBloc, StatisticsState>(
            builder: (context, state) {
              if (state is Loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 60.0),
                    child: Text(
                      "THỐNG KÊ",
                      style: headerStyle,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    "THỐNG KÊ DOANH THU",
                    style: titleStyle.copyWith(color: primaryColor),
                  ),
                  const SizedBox(height: 16.0),
                  _buildMonthlyRevenueChart(context, state.monthlyRevenues),
                  const SizedBox(height: 32.0),
                  Text(
                    "THỐNG KÊ LƯỢNG SẢN PHẨM TRONG KHO",
                    style: titleStyle.copyWith(color: primaryColor),
                  ),
                  const SizedBox(height: 16.0),
                  _buildAmountOfProductChart(context, state.categories),
                  const SizedBox(height: 32.0),
                  Text(
                    "THỐNG KÊ LƯỢNG SẢN PHẨM MUA TRONG NĂM",
                    style: titleStyle.copyWith(color: primaryColor),
                  ),
                  const SizedBox(height: 16.0),
                  _buildSaledProductChart(context, state.productSales),
                  const SizedBox(height: 32.0),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMonthlyRevenueChart(
    BuildContext context,
    List<MonthlyRevenue> monthlyRevenue,
  ) {
    return Column(
      children: [
        Row(
          children: [
            const Spacer(),
            SizedBox(
              width: 130,
              child: DropdownButtonFormField<int>(
                dropdownColor: Colors.white,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: cardBorderRadius,
                    borderSide: BorderSide(
                      color: grayBorderColor,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: cardBorderRadius,
                    borderSide: BorderSide(
                      color: grayBorderColor,
                      width: 1.0,
                    ),
                  ),
                ),
                value: DateTime.now().year,
                items: List.generate(
                  DateTime.now().year - 2021 + 1,
                  (index) {
                    int year = 2021 + index;
                    return DropdownMenuItem(
                      value: year,
                      child: Text(year.toString()),
                    );
                  },
                ),
                onChanged: (value) {
                  print("value: $value");
                  context.read<StatisticsBloc>().add(
                        StatisticsEvent.getMonthlyRevenueByYear(
                          value.toString(),
                        ),
                      );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 32.0),
        SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              barGroups: monthlyRevenue
                  .map(
                    (value) => BarChartGroupData(
                      x: value.month,
                      barRods: [
                        BarChartRodData(
                          toY: value.totalRevenue.toDouble(),
                          color: primaryColor,
                          width: 8,
                        ),
                      ],
                      barsSpace: 4.0,
                    ),
                  )
                  .toList(),
              titlesData: const FlTitlesData(
                leftTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAmountOfProductChart(
    BuildContext context,
    List<Category> categories,
  ) {
    String? categoryId;
    if (categories.isNotEmpty) {
      categoryId = categories.first.id;
    }
    return BlocBuilder<StatisticsBloc, StatisticsState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Spacer(),
                SizedBox(
                  width: 130,
                  child: DropdownButtonFormField(
                    dropdownColor: Colors.white,
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: cardBorderRadius,
                        borderSide: BorderSide(
                          color: grayBorderColor,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: cardBorderRadius,
                        borderSide: BorderSide(
                          color: grayBorderColor,
                          width: 1.0,
                        ),
                      ),
                    ),
                    value: categoryId,
                    items: categories
                        .map(
                          (e) => DropdownMenuItem(
                            value: e.id,
                            child: Text(e.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      print("value: $value");
                      context.read<StatisticsBloc>().add(
                            StatisticsEvent.getAmountOfProduct(
                              value.toString(),
                            ),
                          );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Text(
              "Tổng sản phẩm: ${state.productAmount?.total ?? 0} kg",
              style: titleStyle,
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: state.productAmount == null
                      ? []
                      : state.productAmount!.products
                          .map(
                            (product) => PieChartSectionData(
                              color: getRandomLightColor(),
                              value: product.amount,
                              title: "${product.name}\n${product.amount} kg",
                              radius: 100,
                            ),
                          )
                          .toList(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSaledProductChart(
    BuildContext context,
    ProductSales? productSales,
  ) {
    int month = DateTime.now().month;
    int year = DateTime.now().year;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              "Tháng: ",
              style: contentStyle,
            ),
            const SizedBox(width: 8.0),
            SizedBox(
              width: 100,
              child: DropdownButtonFormField<int>(
                dropdownColor: Colors.white,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: cardBorderRadius,
                    borderSide: BorderSide(
                      color: grayBorderColor,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: cardBorderRadius,
                    borderSide: BorderSide(
                      color: grayBorderColor,
                      width: 1.0,
                    ),
                  ),
                ),
                value: month,
                items: List.generate(
                  12,
                  (index) => DropdownMenuItem(
                    value: index + 1,
                    child: Text("${index + 1}"),
                  ),
                ),
                onChanged: (value) {
                  month = value ?? 1;
                  print("month: $month");
                  context.read<StatisticsBloc>().add(
                        StatisticsEvent.getSaledProductInYear(
                          month,
                          year,
                        ),
                      );
                },
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              "Năm: ",
              style: contentStyle,
            ),
            const SizedBox(width: 10.0),
            SizedBox(
              width: 100,
              child: DropdownButtonFormField<int>(
                dropdownColor: Colors.white,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: cardBorderRadius,
                    borderSide: BorderSide(
                      color: grayBorderColor,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: cardBorderRadius,
                    borderSide: BorderSide(
                      color: grayBorderColor,
                      width: 1.0,
                    ),
                  ),
                ),
                value: DateTime.now().year,
                items: List.generate(
                  DateTime.now().year - 2021 + 1,
                  (index) {
                    int year = 2021 + index;
                    return DropdownMenuItem(
                      value: year,
                      child: Text(year.toString()),
                    );
                  },
                ),
                onChanged: (value) {
                  year = value ?? DateTime.now().year;
                  print("value: $value");
                  context.read<StatisticsBloc>().add(
                        StatisticsEvent.getSaledProductInYear(
                          month,
                          year,
                        ),
                      );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        Text(
          "Tổng số lượng: ${NumberFormat('#,###').format(productSales?.total?.totalAmount ?? 0)} kg",
          style: titleStyle,
        ),
        const SizedBox(height: 8.0),
        Text(
          "Tổng giá trị: ${NumberFormat('#,###', 'vi').format(productSales?.total?.totalPrice ?? 0)} VND",
          style: titleStyle,
        ),
        const SizedBox(height: 16.0),
        Text(
          "Biểu đồ số lượng sản phẩm mua theo ngày",
          style: titleStyle.copyWith(color: primaryColor),
        ),
        const SizedBox(height: 16.0),
        SizedBox(
          height: 230,
          child: BarChart(
            BarChartData(
              barGroups:
                  productSales != null && productSales.daySaleAmount != null
                      ? productSales.daySaleAmount!
                          .map(
                            (value) => BarChartGroupData(
                              x: value.day,
                              barRods: [
                                BarChartRodData(
                                  toY: value.daySaleAmount.toDouble(),
                                  color: primaryColor,
                                  width: 8,
                                ),
                              ],
                              barsSpace: 4.0,
                            ),
                          )
                          .toList()
                      : [],
              titlesData: const FlTitlesData(
                leftTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(
                  axisNameWidget: Text(
                    "Ngày",
                    style: contentStyle,
                  ),
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        Text(
          "Tỷ lệ phế liệu",
          style: titleStyle.copyWith(color: primaryColor),
        ),
        const SizedBox(height: 16.0),
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sections: productSales == null &&
                      productSales?.productTotalSale == null
                  ? []
                  : productSales!.productTotalSale!
                      .map(
                        (product) => PieChartSectionData(
                          color: getRandomLightColor(),
                          value: double.parse(product.percent.toStringAsFixed(2)),
                          title: "${product.productName}\n${product.percent.toStringAsFixed(2)}%",
                          radius: 100,
                        ),
                      )
                      .toList(),
            ),
          ),
        ),
      ],
    );
  }
}

Color getRandomLightColor() {
  Random random = Random();
  int r = 128 + random.nextInt(128); // 128..255
  int g = 128 + random.nextInt(128);
  int b = 128 + random.nextInt(128);
  return Color.fromARGB(255, r, g, b);
}
