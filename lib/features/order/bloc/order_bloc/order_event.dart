part of 'order_bloc.dart';

@freezed
class OrderEvent with _$OrderEvent {
  const factory OrderEvent.started() = _Started;
  const factory OrderEvent.fetchAllCategory() = _FetchAllCategory;
  const factory OrderEvent.fetchAllProductByCategory(String categoryId) =
      _FetchAllProductByCategory;
  const factory OrderEvent.uploadProductImage() = _UploadProductImage;
  const factory OrderEvent.deleteProductImage() = _DeleteProductImage;
  const factory OrderEvent.choosePickupOption(PickUpOption pick) =
      _ChoosePickupOption;
  const factory OrderEvent.getDisabledDates(String month) = _GetDisabledDates;
  const factory OrderEvent.chooseDatePickup(DateTime selectedDate) =
      _ChooseDatePickup;
  const factory OrderEvent.chooseTimePickup({
    required String timeStart,
    required String timeEnd,
  }) = _ChooseTimePickup;
  const factory OrderEvent.clearTimePickup() = _ClearTimePickup;
  const factory OrderEvent.getUserById(String userId) = _GetUserById;
  const factory OrderEvent.validateInformations({
    required String userName,
    required String userPhone,
    required String userAddress,
    required List<Product> products,
    required String pickUpOption,
    DateTime? pickUpDate,
  }) = _ValidateInformations;
  const factory OrderEvent.addProductToCart(DetailedOrder detailedOrder) =
      _AddProductToCart;
  const factory OrderEvent.createOrder() = _CreateOrder;
  const factory OrderEvent.deleteCartItem(DetailedOrder detailedOrder) = _DeleteCartItem;
}
