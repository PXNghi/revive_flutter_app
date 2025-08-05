import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:revive_flutter_project/core/constants/ui_values.dart';
import 'package:revive_flutter_project/core/widgets/expand_product_board.dart';
import 'package:revive_flutter_project/core/widgets/my_appbar.dart';
import 'package:revive_flutter_project/core/widgets/my_button.dart';
import 'package:revive_flutter_project/features/order/bloc/add_order/order_bloc.dart';

class ConfirmedOrderPage extends StatefulWidget {
  final String userName;
  final String userPhone;
  final String userAddress;
  final String userNote;
  const ConfirmedOrderPage({
    super.key,
    required this.userName,
    required this.userPhone,
    required this.userAddress,
    this.userNote = "",
  });

  @override
  State<ConfirmedOrderPage> createState() => _ConfirmedOrderPageState();
}

class _ConfirmedOrderPageState extends State<ConfirmedOrderPage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderBloc, OrderState>(
      listener: (context, state) {
        if (state.isLoading == true) {
          showDialog(
            context: context,
            builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state.isLoading == false) {
          Navigator.pop(context);
        }

        if (state.isCreateSuccess == true) {
          print("success create order congratulation");
          context.pushNamed('success-order-page');
        }
      },
      child: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          return Scaffold(
            appBar: const MyAppbar(
              title: "",
              isLeadingImplied: true,
            ),
            body: Padding(
              padding: pageHorizontalPadding,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "XÁC NHẬN ĐƠN HÀNG",
                      style: headerStyle,
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    _buildHeader(title: "THÔNG TIN CÁ NHÂN"),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        border: Border.all(color: primaryColor),
                        borderRadius: cardBorderRadius,
                      ),
                      child: Column(
                        children: [
                          _buildInformationRow(
                            label: "Họ và tên: ",
                            value: widget.userName,
                          ),
                          _buildInformationRow(
                            label: "Số điện thoại: ",
                            value: widget.userPhone,
                          ),
                          _buildInformationRow(
                            label: "Địa chỉ: ",
                            value: widget.userAddress,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    _buildHeader(title: "THÔNG TIN VẬT PHẨM"),
                    ExpandProduct(
                      cart: state.addedListProduct,
                      isHasIcon: false,
                    ),
                    const SizedBox(height: 24.0),
                    _buildHeader(title: "CÁCH THU GOM"),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        border: Border.all(color: primaryColor),
                        borderRadius: cardBorderRadius,
                      ),
                      child: Text(
                        "Nhân viên đến thu gom tại địa chỉ đã nhập vào ngày ${DateFormat('dd/MM/yyyy').format(state.selectedDate ?? DateTime.now())}.",
                        style: contentStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Container(
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
                  label: "Xác nhận",
                  onTap: () {
                    context.read<OrderBloc>().add(
                          OrderEvent.createOrder(
                            userName: widget.userName,
                            userPhone: widget.userPhone,
                            userAddress: widget.userAddress,
                            userNote: widget.userNote,
                            addedListProduct: state.addedListProduct ?? [],
                            selectedDate: state.selectedDate ?? DateTime.now(),
                            selectedTime: state.selectedTime ?? "",
                            pickUpOption: state.selectedPickUpOption ??
                                PickUpOption.comeBranch,
                          ),
                        );
                  },
                  width: 130,
                  height: 40,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInformationRow({
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text(
            label,
            style: contentStyle,
          ),
          Text(
            value,
            style: contentStyle.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader({required String title}) {
    return Column(
      children: [
        Text(
          title,
          style: titleStyle.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}
