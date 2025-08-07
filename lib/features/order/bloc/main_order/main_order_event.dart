part of 'main_order_bloc.dart';

@freezed
class MainOrderEvent with _$MainOrderEvent {
  const factory MainOrderEvent.started() = _Started;
  const factory MainOrderEvent.changeTab(int tabIndex) = _ChangeTab;
  const factory MainOrderEvent.refreshPage(int tabIndex) = _RefreshPage;
  const factory MainOrderEvent.cancelOrder(String orderId) = _CancelOrder; 
}