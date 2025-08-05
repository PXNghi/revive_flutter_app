import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:revive_flutter_project/core/constants/strings.dart';
import 'package:revive_flutter_project/core/constants/ui_values.dart';
import 'package:revive_flutter_project/core/services/session_data.dart';
import 'package:revive_flutter_project/core/widgets/my_appbar.dart';
import 'package:revive_flutter_project/core/widgets/my_button.dart';
import 'package:revive_flutter_project/core/widgets/my_icon_button.dart';
import 'package:revive_flutter_project/core/widgets/my_tab_item.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(
        title: "",
        isLeadingImplied: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: MyIconButton(
              icon: addIcon,
              size: 30.0,
              onTap: () {
                context.pushNamed('create-order');
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: pageHorizontalPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "ĐƠN HÀNG CỦA BẠN",
              style: headerStyle,
            ),
            const SizedBox(height: 20),
            SizedBox(height: 45, child: _buildTabs(context)),
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: primaryColor),
                  borderRadius: cardBorderRadius,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4.0,
                      spreadRadius: 3.0,
                      offset: const Offset(0.0, 5.0),
                    ),
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Spacer(),
                      Text(
                        "Đang đi lấy",
                        style: contentStyle.copyWith(color: primaryColor),
                      ),
                      const SizedBox(width: 12),
                      Image.asset(
                        chatIcon,
                        width: 24,
                        height: 24,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Mã đơn hàng: 6892415b11b2e065abe2e8d2",
                    style: contentStyle.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: imageBorderRadius,
                        child: Image.asset(
                          logoApp,
                          width: 70,
                          height: 70,
                        ),
                      ),
                      const SizedBox(width: 13),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Sắt công trình",
                            style: titleStyle.copyWith(fontSize: 18.0),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            "10 kg",
                            style: contentStyle.copyWith(
                              fontSize: 10.0,
                              color: dartGrayColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Tổng: 4 sản phẩm",
                      style: contentStyle.copyWith(fontSize: 12.0),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: imageBorderRadius,
                      border: Border.all(color: primaryColor),
                      color: primaryColor.withOpacity(0.1),
                    ),
                    child: Center(
                      child: Text(
                        "Ngày thu gom: 15/07/2025",
                        style: titleStyle.copyWith(
                          fontSize: defaultFontSize,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Visibility(
                    visible: SessionData.mine?.role == "Admin",
                    child: Row(
                      children: [
                        Expanded(
                          child: MyButton(
                            onTap: () {},
                            label: "Từ chối",
                            color: alertColor,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: MyButton(
                            onTap: () {},
                            label: "Xác nhận",
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      itemCount: 4,
      itemBuilder: (context, index) {
        return MyTabItem(
          text: [
            "Chờ xử lý",
            "Đã xác nhận",
            "Đã hoàn thành",
            "Đã hủy",
          ][index],
          isChosen: false,
          onTap: () {},
        );
      },
    );
  }
}
