part of 'main_order_bloc.dart';

@freezed
class MainOrderState with _$MainOrderState {
  const factory MainOrderState.initial() = Initial;
  const factory MainOrderState.loading({required int selectedIndex}) = Loading;
  const factory MainOrderState.loaded({
    @Default([]) List<Order> orders,
    @Default(0) int selectedIndex,
    String? reasonError,
    DateTime? selectedDate,
    Order? order,
    List<String>? availableStatus,
    String? selectedStatus,
  }) = Loaded;
  const factory MainOrderState.success() = Success;
  const factory MainOrderState.error(String message) = Error;

  const MainOrderState._();

  List<Order> get orders => mapOrNull(loaded: (state) => state.orders) ?? [];
  int get selectedIndex =>
      mapOrNull(loaded: (state) => state.selectedIndex) ?? 0;
  String? get reasonError => mapOrNull(loaded: (state) => state.reasonError);
  DateTime? get selectedDate => mapOrNull(loaded: (state) => state.selectedDate);
  Order? get order => mapOrNull(loaded: (state) => state.order);
  List<String>? get availableStatus =>
      mapOrNull(loaded: (state) => state.availableStatus);
  String? get selectedStatus =>
      mapOrNull(loaded: (state) => state.selectedStatus);
}
