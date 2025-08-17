import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:revive_flutter_project/core/constants/strings.dart';
import 'package:revive_flutter_project/core/constants/ui_values.dart';
import 'package:revive_flutter_project/core/widgets/my_appbar.dart';
import 'package:revive_flutter_project/core/widgets/my_button.dart';
import 'package:revive_flutter_project/core/widgets/my_textfield.dart';
import 'package:revive_flutter_project/core/widgets/order_item.dart';
import 'package:revive_flutter_project/features/order/bloc/main_order/main_order_bloc.dart';

class SearchOrderPage extends StatefulWidget {
  const SearchOrderPage({super.key});

  @override
  State<SearchOrderPage> createState() => _SearchOrderPageState();
}

class _SearchOrderPageState extends State<SearchOrderPage> {
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const MyAppbar(
        title: "",
        isLeadingImplied: true,
      ),
      body: Padding(
        padding: pageHorizontalPadding,
        child: BlocBuilder<MainOrderBloc, MainOrderState>(
          builder: (context, state) {
            return Column(
              children: [
                const SizedBox(height: 16),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm đơn hàng với mã đơn, tên sản phẩm',
                    suffixIcon: Image.asset(
                      searchIcon,
                      width: 16,
                      height: 16,
                    ),
                    isDense: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      borderSide:
                          const BorderSide(color: grayBorderColor, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      borderSide:
                          const BorderSide(color: primaryColor, width: 1.0),
                    ),
                  ),
                  onSubmitted: (value) {
                    context
                        .read<MainOrderBloc>()
                        .add(MainOrderEvent.searchOrder(value));
                  },
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 32.0),
                    itemCount: state.orders.length,
                    itemBuilder: (context, index) {
                      final orderItem = state.orders[index];
                      final bloc = context.read<MainOrderBloc>();
                      return OrderItem(
                        orderId: orderItem.id,
                        orderStatus: orderItem.status,
                        orderDate: orderItem.pickUpDate.toString(),
                        orderLength: orderItem.detailedOrders.length,
                        orderDetails: orderItem.detailedOrders,
                        adminNote: orderItem.adminNote,
                        totalPrice: orderItem.totalPrice,
                        onCopyTap: () {
                          Clipboard.setData(ClipboardData(text: orderItem.id));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Đã sao chép mã đơn hàng"),
                            ),
                          );
                        },
                        onOrderTap: () async {
                          final shouldRefresh = await context
                              .pushNamed('detailed-order-page', extra: {
                            'order': orderItem,
                            'bloc': bloc,
                          });
                          if (shouldRefresh == true) {
                            context.read<MainOrderBloc>().add(
                                MainOrderEvent.changeTab(state.selectedIndex));
                          }
                        },
                        onAcceptTap: () {
                          context
                              .read<MainOrderBloc>()
                              .add(MainOrderEvent.acceptOrder(orderItem.id));
                        },
                        onDeclineTap: () {
                          _showRejectReasonDialog(context, orderItem.id);
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showRejectReasonDialog(BuildContext context, String orderId) async {
    final TextEditingController _reasonController = TextEditingController();
    final bloc = context.read<MainOrderBloc>();
    await showDialog(
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
                  BlocBuilder<MainOrderBloc, MainOrderState>(
                    builder: (context, state) {
                      return MyTextField(
                        controller: _reasonController,
                        label: "Nhập lý do hủy đơn hàng:",
                        maxLines: 4,
                        errorText: state.reasonError,
                      );
                    },
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
                          bloc.add(
                            MainOrderEvent.rejectOrder(
                              orderId: orderId,
                              rejectReason: _reasonController.text,
                            ),
                          );
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
    context.read<MainOrderBloc>().add(const MainOrderEvent.clearInformations());
  }
}
