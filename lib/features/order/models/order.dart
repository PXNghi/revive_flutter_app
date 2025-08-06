import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:revive_flutter_project/features/order/models/detailed_order_response.dart';

part 'order.g.dart';
part 'order.freezed.dart';

@freezed 
class Order with _$Order {
  const factory Order({
    @JsonKey(name: '_id') @Default('') String id,
    @JsonKey(name: 'userId') @Default('') String userId,
    @JsonKey(name: 'userName') @Default('') String userName,
    @JsonKey(name: 'userPhone') @Default('') String userPhone,
    @JsonKey(name: 'userAddress') @Default('') String userAddress,
    @JsonKey(name: 'userNote') @Default('') String userNote,
    @JsonKey(name: 'adminNote') @Default('') String adminNote,
    @JsonKey(name: 'pickUpDate') required DateTime pickUpDate,
    @JsonKey(name: 'startTime') @Default('') String startTime,
    @JsonKey(name: 'endTime') @Default('') String endTime,
    @JsonKey(name: 'totalPrice') @Default(0) int totalPrice,
    @JsonKey(name: 'status') @Default('') String status,
    @JsonKey(name: 'detailedOrders') @Default([]) List<DetailedOrderResponse> detailedOrders,
  }) = _Order;

  factory Order.fromJson(Map<String, Object?> json) => _$OrderFromJson(json);
}
