import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:revive_flutter_project/core/constants/strings.dart';
import 'package:revive_flutter_project/core/constants/ui_values.dart';
import 'package:revive_flutter_project/core/services/session_data.dart';
import 'package:revive_flutter_project/core/widgets/my_appbar.dart';
import 'package:revive_flutter_project/core/widgets/my_button.dart';
import 'package:revive_flutter_project/core/widgets/my_icon_button.dart';
import 'package:revive_flutter_project/core/widgets/my_tab_item.dart';
import 'package:revive_flutter_project/core/widgets/my_textfield.dart';
import 'package:revive_flutter_project/core/widgets/order_item.dart';
import 'package:revive_flutter_project/features/order/bloc/main_order/main_order_bloc.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppbar(
        title: "",
        isLeadingImplied: false,
        customLeading: MyIconButton(
          icon: chatIcon,
          onTap: () {
            if (SessionData.mine?.role == "Admin") {
              context.pushNamed('chat-list-page');
            } else {
              context.pushNamed('chat-page');
            }
          },
          size: 24,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: MyIconButton(
              icon: addIcon,
              size: 30.0,
              onTap: () {
                context.pushNamed('create-order');
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: MyIconButton(
              icon: searchIcon,
              size: 30.0,
              onTap: () {
                context.pushNamed('search-order-page');
              },
            ),
          ),
        ],
      ),
      body: BlocConsumer<MainOrderBloc, MainOrderState>(
        listener: (context, state) {
          final int currentPage = _pageController.page?.round() ?? 0;
          if (state.selectedIndex != currentPage) {
            _pageController.jumpToPage(state.selectedIndex);
          }
          final offset = (state.selectedIndex * 100.0) -
              (MediaQuery.of(context).size.width / 2) +
              (100.0 / 2);
          _scrollController.animateTo(
            offset.clamp(0, _scrollController.position.maxScrollExtent),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        builder: (context, state) {
          return Padding(
            padding: pageHorizontalPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "ĐƠN HÀNG CỦA BẠN",
                  style: headerStyle,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 45,
                  child: _buildTabs(
                    context,
                    state,
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) => context.read<MainOrderBloc>().add(
                          MainOrderEvent.changeTab(index),
                        ),
                    children: [
                      _buildOrderSection(state),
                      _buildOrderSection(state),
                      _buildOrderSection(state),
                      _buildOrderSection(state),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabs(BuildContext context, MainOrderState state) {
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
          isChosen: state.selectedIndex == index,
          onTap: () {
            context.read<MainOrderBloc>().add(
                  MainOrderEvent.changeTab(index),
                );
          },
        );
      },
    );
  }

  _buildOrderSection(MainOrderState state) {
    if (state is Loaded) {
      return ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(height: 32.0),
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
              final shouldRefresh =
                  await context.pushNamed('detailed-order-page', extra: {
                'order': orderItem,
                'bloc': bloc,
              });
              if (shouldRefresh == true) {
                context
                    .read<MainOrderBloc>()
                    .add(MainOrderEvent.changeTab(state.selectedIndex));
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
      );
    }

    return const Center(
      child: CircularProgressIndicator(),
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
