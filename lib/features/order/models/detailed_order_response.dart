import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:revive_flutter_project/features/product/model/product.dart';

part 'detailed_order_response.g.dart';
part 'detailed_order_response.freezed.dart';

@freezed 
class DetailedOrderResponse with _$DetailedOrderResponse {
  const factory DetailedOrderResponse({
    @JsonKey(name: '_id') @Default('') String id,
    @JsonKey(name: 'orderId') @Default('') String orderId,
    @JsonKey(name: 'productId') Product? product,
    @JsonKey(name: 'productNote') @Default('') String productNote,
    @JsonKey(name: 'amount') @Default(0.0) double amount,
    @JsonKey(name: 'image') @Default('') String image,
    @JsonKey(name: 'price') @Default(0) int price,
  }) = _DetailedOrderResponse;

  factory DetailedOrderResponse.fromJson(Map<String, Object?> json) =>
      _$DetailedOrderResponseFromJson(json);
}