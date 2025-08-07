part of 'main_order_bloc.dart';

@freezed
class MainOrderEvent with _$MainOrderEvent {
  const factory MainOrderEvent.started() = _Started;
  const factory MainOrderEvent.changeTab(int tabIndex) = _ChangeTab;
  const factory MainOrderEvent.refreshPage(int tabIndex) = _RefreshPage;
  const factory MainOrderEvent.cancelOrder(String orderId) = _CancelOrder;
  const factory MainOrderEvent.acceptOrder(String orderId) = _AcceptOrder;
  const factory MainOrderEvent.chooseAnotherDate(DateTime selectedDate) = _ChooseAnotherDate;
  const factory MainOrderEvent.updateNewInformation({
    @Default('') String orderId,
    DateTime? orderDate,
    String? orderTimeStart,
    String? orderTimeEnd,
    String? adminNote,
    String? status,
  }) = _UpdateNewInformation;
  const factory MainOrderEvent.rejectOrder({
    @Default('') String orderId,
    @Default('') String rejectReason,
  }) = _RejectOrder;
  const factory MainOrderEvent.updateOrderStatus({
    @Default('') String orderId,
    @Default('') String branchProcessId,
    @Default('') String status,
  }) = _UpdateOrderStatus;
  const factory MainOrderEvent.clearInformations() = _ClearInformations;
}
