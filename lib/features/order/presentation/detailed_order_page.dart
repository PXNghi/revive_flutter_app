import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:revive_flutter_project/core/configs/apis/my_enviroment.dart';
import 'package:revive_flutter_project/core/constants/strings.dart';
import 'package:revive_flutter_project/core/constants/ui_values.dart';
import 'package:revive_flutter_project/core/services/session_data.dart';
import 'package:revive_flutter_project/core/widgets/my_appbar.dart';
import 'package:revive_flutter_project/core/widgets/my_button.dart';
import 'package:revive_flutter_project/core/widgets/my_icon_button.dart';
import 'package:revive_flutter_project/core/widgets/my_textfield.dart';
import 'package:revive_flutter_project/core/widgets/my_timeline.dart';
import 'package:revive_flutter_project/features/order/models/order.dart';
import 'package:timelines_plus/timelines_plus.dart';

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
    return Scaffold(
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
              MyTimeline(currentStatus: widget.order.status),
              const SizedBox(height: 30),
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
                    Text("Họ và tên: ${widget.order.userName}",
                        style: contentStyle),
                    const SizedBox(height: 8),
                    Text("Địa chỉ: ${widget.order.userAddress}",
                        style: contentStyle),
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
                child: Text(widget.order.userNote == "" ? "Không có ghi chú." : widget.order.userNote, style: contentStyle,),
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
    );
  }

  Widget _buildBottomBarByRole() {
    if (widget.order.status == "waiting") {
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
        );
      } else {
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
              label: "Hủy đơn hàng",
              onTap: () {},
              width: double.infinity,
              height: 45,
            ),
          ),
        );
      }
    } else if (widget.order.status == "confirmed" || widget.order.status == "delivering" || widget.order.status == "finished") {
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
}
