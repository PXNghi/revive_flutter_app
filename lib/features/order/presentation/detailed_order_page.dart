import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:revive_flutter_project/core/configs/apis/my_enviroment.dart';
import 'package:revive_flutter_project/core/constants/strings.dart';
import 'package:revive_flutter_project/core/constants/ui_values.dart';
import 'package:revive_flutter_project/core/services/session_data.dart';
import 'package:revive_flutter_project/core/widgets/my_appbar.dart';
import 'package:revive_flutter_project/core/widgets/my_button.dart';
import 'package:revive_flutter_project/core/widgets/my_dialog.dart';
import 'package:revive_flutter_project/core/widgets/my_icon_button.dart';
import 'package:revive_flutter_project/core/widgets/my_textfield.dart';
import 'package:revive_flutter_project/core/widgets/my_timeline.dart';
import 'package:revive_flutter_project/features/order/bloc/main_order/main_order_bloc.dart';
import 'package:revive_flutter_project/features/order/models/order.dart';
import 'package:table_calendar/table_calendar.dart';

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
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTapDown: (details) {
                  final Offset offset = details.globalPosition;
                  _showEditMenu(context, offset);
                },
                child: Image.asset(
                  editIcon,
                  width: 24,
                  height: 24,
                ),
              ),
            ),
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
                BlocBuilder<MainOrderBloc, MainOrderState>(
                  builder: (context, state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Ngày thu gom: ${DateFormat('dd/MM/yyyy').format(state.order?.pickUpDate ?? widget.order.pickUpDate)}",
                          style: contentStyle,
                        ),
                        const SizedBox(height: 8),
                        Visibility(
                          visible: state.order?.adminNote != null || widget.order.adminNote.isNotEmpty,
                          child: Text(
                            "Admin note: ${state.order?.adminNote ?? widget.order.adminNote}",
                            style: contentStyle.copyWith(color: alertColor),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 30),
                Visibility(
                  visible: !(widget.order.status == "cancelled"),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "TRẠNG THÁI",
                        style: titleStyle.copyWith(
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      BlocBuilder<MainOrderBloc, MainOrderState>(
                        builder: (context, state) {
                          return MyTimeline(
                            currentStatus:
                                state.order?.status ?? widget.order.status,
                          );
                        },
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

  Widget? _buildBottomBarByRole() {
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
                    onTap: () {
                      _showRejectReasonDialog(context, widget.order.id);
                    },
                    width: 130,
                    height: 40,
                    color: alertColor,
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: MyButton(
                    label: "Xác nhận",
                    onTap: () {
                      context
                          .read<MainOrderBloc>()
                          .add(MainOrderEvent.acceptOrder(widget.order.id));
                    },
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
              onTap: () {
                _showChangeStatusDialog(context);
              },
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
    } else {
      return null;
    }
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

  void _showChangeStatusDialog(BuildContext context) {
    final bloc = context.read<MainOrderBloc>();
  }

  void _showEditMenu(BuildContext context, Offset offset) {
    final Size screenSize = MediaQuery.of(context).size;
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx + 15,
        offset.dy + 20,
        screenSize.width - offset.dx,
        screenSize.height - offset.dy,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: const BorderSide(
          color: primaryColor,
          width: 1.0,
        ),
      ),
      color: Colors.white,
      items: [
        PopupMenuItem(
          value: 'edit-date',
          child: const Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Text(
              'Thay đổi ngày thu gom',
              style: contentStyle,
            ),
          ),
          onTap: () {
            _showEditDateDialog(context);
          },
        ),
        PopupMenuItem(
          value: 'add-admin-note',
          child: const Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Text(
              'Thêm ghi chú',
              style: contentStyle,
            ),
          ),
          onTap: () {
            _showAddAdminNoteDialog(context);
          },
        ),
      ],
    );
  }

  void _showEditDateDialog(BuildContext context) {
    final bloc = context.read<MainOrderBloc>();
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider.value(
          value: bloc,
          child: Dialog(
            insetPadding: pageHorizontalPadding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
              side: const BorderSide(
                color: primaryColor,
                width: 1.0,
              ),
            ),
            child: Container(
              padding: pageHorizontalPadding,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white,
              ),
              child: BlocBuilder<MainOrderBloc, MainOrderState>(
                builder: (context, state) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 24.0),
                      Text(
                        "THÔNG BÁO",
                        style: titleStyle.copyWith(
                          fontSize: 20.0,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      TableCalendar(
                        locale: 'vi_VN',
                        currentDay: widget.order.pickUpDate,
                        focusedDay: widget.order.pickUpDate,
                        firstDay: DateTime.utc(1970, 1, 1),
                        lastDay: DateTime.utc(2090, 1, 1),
                        calendarFormat: CalendarFormat.month,
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        headerStyle: const HeaderStyle(
                          titleCentered: true,
                          formatButtonVisible: false,
                        ),
                        calendarStyle: CalendarStyle(
                          isTodayHighlighted: true,
                          todayDecoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.7),
                            shape: BoxShape.circle,
                          ),
                          selectedDecoration: const BoxDecoration(
                            color: primaryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        onDaySelected: (selectedDay, focusedDay) {
                          context.read<MainOrderBloc>().add(
                              MainOrderEvent.chooseAnotherDate(selectedDay));
                        },
                        selectedDayPredicate: (day) {
                          return isSameDay(day, state.selectedDate);
                        },
                        enabledDayPredicate: (day) {
                          final today = DateTime.now();
                          final dayOnly =
                              DateTime(day.year, day.month, day.day);
                          final todayOnly =
                              DateTime(today.year, today.month, today.day);
                          final isTodayOrBefore = !dayOnly.isAfter(todayOnly);
                          return !isTodayOrBefore;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      MyButton(
                        width: 150.0,
                        label: "Xác nhận",
                        onTap: () {
                          context
                              .read<MainOrderBloc>()
                              .add(MainOrderEvent.updateNewInformation(
                                orderId: widget.order.id,
                                orderDate: state.selectedDate,
                              ));
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(height: 16.0),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAddAdminNoteDialog(BuildContext context) {
    final bloc = context.read<MainOrderBloc>();
    final TextEditingController _noteController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider.value(
          value: bloc,
          child: Dialog(
            insetPadding: pageHorizontalPadding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
              side: const BorderSide(
                color: primaryColor,
                width: 1.0,
              ),
            ),
            child: Container(
              padding: pageHorizontalPadding,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white,
              ),
              child: BlocBuilder<MainOrderBloc, MainOrderState>(
                builder: (context, state) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 24.0),
                      Text(
                        "THÔNG BÁO",
                        style: titleStyle.copyWith(
                          fontSize: 20.0,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      MyTextField(
                        label: "Nhập ghi chú",
                        controller: _noteController,
                        maxLines: 5,
                      ),
                      const SizedBox(height: 16.0),
                      MyButton(
                        width: 150.0,
                        label: "Xác nhận",
                        onTap: () {
                          context
                              .read<MainOrderBloc>()
                              .add(MainOrderEvent.updateNewInformation(
                                orderId: widget.order.id,
                                adminNote: _noteController.text,
                              ));
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(height: 16.0),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
