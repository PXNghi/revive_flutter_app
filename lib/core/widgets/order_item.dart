import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:revive_flutter_project/core/constants/strings.dart';
import 'package:revive_flutter_project/core/constants/ui_values.dart';
import 'package:revive_flutter_project/core/services/session_data.dart';
import 'package:revive_flutter_project/core/widgets/expand_order_board.dart';
import 'package:revive_flutter_project/core/widgets/my_button.dart';
import 'package:revive_flutter_project/features/order/models/detailed_order_response.dart';

class OrderItem extends StatelessWidget {
  final String orderId;
  final String orderStatus;
  final int orderLength;
  final String orderDate;
  final List<DetailedOrderResponse>? orderDetails;
  final VoidCallback? onChatTap;
  final VoidCallback? onOrderTap;

  const OrderItem({
    super.key,
    required this.orderId,
    required this.orderStatus,
    required this.orderLength,
    required this.orderDate,
    required this.orderDetails,
    this.onChatTap,
    this.onOrderTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onOrderTap ?? () {},
      child: Container(
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
                Visibility(
                  visible: orderStatus == "delivering",
                  child: Text(
                    "Đang đến lấy",
                    style: contentStyle.copyWith(color: primaryColor),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: onChatTap ?? () {},
                  child: Image.asset(
                    chatIcon,
                    width: 24,
                    height: 24,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Mã đơn hàng: $orderId",
              style: contentStyle.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ExpandOrderBoard(products: orderDetails ?? []),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Tổng: $orderLength sản phẩm",
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
                  "Ngày thu gom: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(orderDate))}",
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
    );
  }
}
