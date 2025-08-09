import 'package:freezed_annotation/freezed_annotation.dart';

part 'monthly_revenue.freezed.dart';
part 'monthly_revenue.g.dart';

@freezed
class MonthlyRevenue with _$MonthlyRevenue {
  const factory MonthlyRevenue({
    @JsonKey(name: 'month') @Default(0) int month,
    @JsonKey(name: 'year') @Default(0) int year,
    @JsonKey(name: 'totalRevenue') @Default(0) double totalRevenue,
    @JsonKey(name: 'orderCount') @Default(0) int orderCount,
  }) = _MonthlyRevenue;

  factory MonthlyRevenue.fromJson(Map<String, Object?> json) =>
      _$MonthlyRevenueFromJson(json);
}
