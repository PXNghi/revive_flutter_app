part of 'order_bloc.dart';

@freezed
class OrderState with _$OrderState {
  const factory OrderState.initial() = _Initial;
  const factory OrderState.loading() = _Loading;
  const factory OrderState.loaded({
    @Default([]) List<Category> categories,
    @Default([]) List<Product> products,
    File? imageFile,
  }) = _Loaded;
  const factory OrderState.validateError({
    String? userNameError,
    String? userAddressError,
    String? userPhoneError,
    bool? isChoosePickUpOption,
  }) = _ValidateError;
  const factory OrderState.createSuccess() = _CreateSuccess;
  const factory OrderState.error(String message) = _Error;

  const OrderState._();

  List<Category>? get categories => mapOrNull(loaded: (value) => value.categories) ?? [];
  List<Product>? get products => mapOrNull(loaded: (value) => value.products) ?? [];
  File? get imageFile => mapOrNull(loaded: (value) => value.imageFile);
  String? get userNameError => mapOrNull(validateError: (value) => value.userNameError);
  String? get userAddressError => mapOrNull(validateError: (value) => value.userAddressError);
  String? get userPhoneError => mapOrNull(validateError: (value) => value.userPhoneError);
  bool? get isChoosePickUpOption => mapOrNull(validateError: (value) => value.isChoosePickUpOption);
}
