part of 'order_bloc.dart';

@freezed
class OrderState with _$OrderState {
  const factory OrderState.initial() = _Initial;
  const factory OrderState.loading() = _Loading;
  const factory OrderState.loaded({
    @Default([]) List<Category> categories,
    @Default([]) List<Product> products,
    @Default([]) List<DetailedOrder> cart,
    @Default([]) List<AddedListProduct> addedListProduct,
    PickUpOption? selectedPickUpOption,
    List<DateTime>? disabledDates,
    DateTime? selectedDateAndTime,
    String? selectedTime,
    String? userNameError,
    String? userAddressError,
    String? userPhoneError,
    bool? isChoosePickUpOption,

    File? imageFile,
  }) = _Loaded;
  const factory OrderState.createSuccess() = _CreateSuccess;
  const factory OrderState.error(String message) = _Error;

  const OrderState._();

  bool get isLoading => mapOrNull(loading: (_) => true) ?? false;
  List<Category>? get categories => mapOrNull(loaded: (value) => value.categories) ?? [];
  List<Product>? get products => mapOrNull(loaded: (value) => value.products) ?? [];
  List<DetailedOrder>? get cart => mapOrNull(loaded: (value) => value.cart) ?? [];
  List<AddedListProduct>? get addedListProduct => mapOrNull(loaded: (value) => value.addedListProduct) ?? [];
  PickUpOption? get selectedPickUpOption => mapOrNull(loaded: (value) => value.selectedPickUpOption);
  List<DateTime>? get disabledDates => mapOrNull(loaded: (value) => value.disabledDates);
  DateTime? get selectedDateAndTime => mapOrNull(loaded: (value) => value.selectedDateAndTime);
  String? get selectedTime => mapOrNull(loaded: (value) => value.selectedTime);
  File? get imageFile => mapOrNull(loaded: (value) => value.imageFile);
  String? get userNameError => mapOrNull(loaded: (value) => value.userNameError);
  String? get userAddressError => mapOrNull(loaded: (value) => value.userAddressError);
  String? get userPhoneError => mapOrNull(loaded: (value) => value.userPhoneError);
  bool? get isChoosePickUpOption => mapOrNull(loaded: (value) => value.isChoosePickUpOption);
}
