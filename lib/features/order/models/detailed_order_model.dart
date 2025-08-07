import 'package:freezed_annotation/freezed_annotation.dart';

part 'detailed_order_model.freezed.dart';
part 'detailed_order_model.g.dart';

@freezed 
class DetailedOrder with _$DetailedOrder {
  const factory DetailedOrder({
    @JsonKey(name: '_id') @Default('') String id,
    @JsonKey(name: 'orderId') @Default('') String orderId,
    @JsonKey(name: 'productId') @Default('') String productId,
    @JsonKey(name: 'productNote') @Default('') String productNote,
    @JsonKey(name: 'amount') @Default(0.0) double amount,
    @JsonKey(name: 'image') @Default('') String image,
    @JsonKey(name: 'price') @Default(0) int price,
  }) = _DetailedOrder;

  factory DetailedOrder.fromJson(Map<String, Object?> json) => _$DetailedOrderFromJson(json);
}