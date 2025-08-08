import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_amount.freezed.dart';
part 'product_amount.g.dart';

@freezed 
class ProductAmount with _$ProductAmount {
  const factory ProductAmount({
    @JsonKey(name: 'category') @Default('') String category,
    @JsonKey(name: 'products') @Default([]) List<ProductChart> products,
    @JsonKey(name: 'total_amount') @Default(0.0) double total,
  }) = _ProductAmount;

  factory ProductAmount.fromJson(Map<String, dynamic> json) => _$ProductAmountFromJson(json);
}

@freezed 
class ProductChart with _$ProductChart {
  const factory ProductChart({
    @JsonKey(name: 'name') @Default('') String name,
    @JsonKey(name: 'amount') @Default(0.0) double amount,
  }) = _ProductChart;

  factory ProductChart.fromJson(Map<String, dynamic> json) => _$ProductChartFromJson(json);
}