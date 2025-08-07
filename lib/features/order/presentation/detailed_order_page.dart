import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:revive_flutter_project/core/configs/apis/my_enviroment.dart';
import 'package:revive_flutter_project/core/constants/strings.dart';
import 'package:revive_flutter_project/core/constants/ui_values.dart';
import 'package:revive_flutter_project/core/services/session_data.dart';
import 'package:revive_flutter_project/core/widgets/my_appbar.dart';
import 'package:revive_flutter_project/core/widgets/my_button.dart';
import 'package:revive_flutter_project/core/widgets/my_icon_button.dart';
import 'package:revive_flutter_project/core/widgets/my_timeline.dart';
import 'package:revive_flutter_project/features/order/bloc/main_order/main_order_bloc.dart';
import 'package:revive_flutter_project/features/order/models/order.dart';

class DetailedOrderPage extends StatefulWidget {
  final Order order;
  const DetailedOrderPage({
    super.key,
    required this.order,
  });

  @override
  State<DetailedOrderPage> createState() => _DetailedOrderPageState();
}

class _DetailedOrderPageState extends State<DetailedOrderPage> {
  final statusList = ["waiting", "confirmed", "delivering", "completed"];
  @override
  Widget build(BuildContext context) {
    return BlocListener<MainOrderBloc, MainOrderState>(
      listener: (context, state) {
        if (state is Success) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: MyAppbar(
          title: "",
          isLeadingImplied: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: MyIconButton(
                onTap: () {},
                icon: chatIcon,
                size: 24,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: pageHorizontalPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("CHI TIẾT ĐƠN HÀNG", style: headerStyle),
                const SizedBox(height: 16),
                Text("Mã đơn hàng: ${widget.order.id}", style: contentStyle),
                const SizedBox(height: 8),
                Text(
                  "Ngày thu gom: ${DateFormat('dd/MM/yyyy').format(widget.order.pickUpDate)}",
                  style: contentStyle,
                ),
                const SizedBox(height: 30),
                Text(
                  "TRẠNG THÁI",
                  style: titleStyle.copyWith(
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 20),
                Visibility(
                  visible: !(widget.order.status == "cancelled"),
                  child: Column(
                    children: [
                      MyTimeline(
                        currentStatus: widget.order.status,
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
                Text(
                  "THÔNG TIN KHÁCH HÀNG",
                  style: titleStyle.copyWith(
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: cardBorderRadius,
                    border: Border.all(color: primaryColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Họ và tên: ${widget.order.userName}",
                        style: contentStyle,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Địa chỉ: ${widget.order.userAddress}",
                        style: contentStyle,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Số điện thoại: ${widget.order.userPhone}",
                        style: contentStyle,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  "GHI CHÚ",
                  style: titleStyle.copyWith(
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: primaryColor),
                    borderRadius: cardBorderRadius,
                  ),
                  child: Text(
                    widget.order.userNote == ""
                        ? "Không có ghi chú."
                        : widget.order.userNote,
                    style: contentStyle,
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  "THÔNG TIN SẢN PHẨM",
                  style: titleStyle.copyWith(
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 20),
                ListView.separated(
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.order.detailedOrders.length,
                  itemBuilder: (context, index) {
                    final item = widget.order.detailedOrders[index];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        item.image == ""
                            ? ClipRRect(
                                borderRadius: cardBorderRadius,
                                child: Image.asset(
                                  logoApp,
                                  width: 70,
                                  height: 70,
                                ),
                              )
                            : ClipRRect(
                                borderRadius: cardBorderRadius,
                                child: Image.network(
                                  "${Enviroment.baseUrl}${item.image}",
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                ),
                              ),
                        const SizedBox(width: 16.0),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.product?.name ?? "",
                                style: contentStyle.copyWith(fontSize: 15.0)),
                            const SizedBox(height: 8.0),
                            Text(
                              "${item.amount} kg",
                              style: contentStyle.copyWith(
                                fontSize: smallFontSize,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomBarByRole(),
      ),
    );
  }

  Widget _buildBottomBarByRole() {
    final bloc = context.read<MainOrderBloc>();
    if (widget.order.status == "waiting") {
      if (SessionData.mine?.role == "Admin") {
        return BlocProvider.value(
          value: bloc,
          child: Container(
            padding: pageHorizontalPadding,
            height: 70,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xffD1D1D6).withOpacity(0.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: MyButton(
                    label: "Từ chối",
                    onTap: () {},
                    width: 130,
                    height: 40,
                    color: alertColor,
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: MyButton(
                    label: "Xác nhận",
                    onTap: () {},
                    width: 130,
                    height: 40,
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        return BlocProvider.value(
          value: bloc,
          child: Container(
            padding: pageHorizontalPadding,
            height: 70,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xffD1D1D6).withOpacity(0.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: MyButton(
                label: "Hủy đơn hàng",
                onTap: () {
                  _showCancelDialog(context);
                },
                width: double.infinity,
                height: 45,
              ),
            ),
          ),
        );
      }
    } else if (widget.order.status == "confirmed" ||
        widget.order.status == "delivering" ||
        widget.order.status == "finished") {
      if (SessionData.mine?.role == "Admin") {
        return Container(
          padding: pageHorizontalPadding,
          height: 70,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xffD1D1D6).withOpacity(0.2),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 2,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: MyButton(
              label: "Đổi trạng thái",
              onTap: () {},
              width: double.infinity,
              height: 45,
            ),
          ),
        );
      } else {
        Container(
          padding: pageHorizontalPadding,
          height: 70,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xffD1D1D6).withOpacity(0.2),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 2,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: MyButton(
            label: "Hủy đơn hàng",
            onTap: () {},
            width: double.infinity,
            height: 45,
            color: darkGrayColor,
          ),
        );
      }
    }
    return Container();
  }

  void _showCancelDialog(BuildContext context) {
    final bloc = context.read<MainOrderBloc>();
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider.value(
          value: bloc,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
              side: const BorderSide(
                color: primaryColor,
                width: 1.0,
              ),
            ),
            insetPadding: pageHorizontalPadding,
            child: Container(
              padding: pageHorizontalPadding,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 24.0),
                  Center(
                    child: Text(
                      "THÔNG BÁO",
                      style: titleStyle.copyWith(
                        fontSize: 20,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    "Bạn có chắc chắn muốn hủy đơn hàng không?",
                    style: contentStyle.copyWith(
                      fontSize: 16.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyButton(
                        width: 100.0,
                        label: "Hủy",
                        color: alertColor,
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      const SizedBox(width: 16.0),
                      MyButton(
                        width: 100.0,
                        label: "Xác nhận",
                        onTap: () {
                          bloc.add(MainOrderEvent.cancelOrder(widget.order.id));
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24.0),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
