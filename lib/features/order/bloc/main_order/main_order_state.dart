part of 'main_order_bloc.dart';

@freezed
class MainOrderState with _$MainOrderState {
  const factory MainOrderState.initial() = Initial;
  const factory MainOrderState.loading({required int selectedIndex}) = Loading;
  const factory MainOrderState.loaded({required List<Order> orders}) = Loaded;
  const factory MainOrderState.success() = Success;
  const factory MainOrderState.error(String message) = Error;

  const MainOrderState._();

  List<Order> get orders => mapOrNull(loaded: (state) => state.orders) ?? [];

  int get selectedIndex => mapOrNull(loading: (state) => state.selectedIndex) ?? 0;

}
