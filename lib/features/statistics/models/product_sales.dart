import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_sales.freezed.dart';
part 'product_sales.g.dart';

@freezed 
class ProductSales with _$ProductSales {
  const factory ProductSales({
    @JsonKey(name: 'total') TotalMonthSale? total,
    @JsonKey(name: 'barChart') List<DaySaleAmount>? daySaleAmount,
    @JsonKey(name: 'pieChart') List<ProductTotalSale>? productTotalSale
  }) = _ProductSales;

  factory ProductSales.fromJson(Map<String, dynamic> json) => _$ProductSalesFromJson(json);
}

@freezed
class TotalMonthSale with _$TotalMonthSale {
  const factory TotalMonthSale({
    @JsonKey(name: 'kg') @Default(0) int totalAmount,
    @JsonKey(name: 'vnd') @Default(0) int totalPrice,
  }) = _TotalMonthSale;

  factory TotalMonthSale.fromJson(Map<String, dynamic> json) => _$TotalMonthSaleFromJson(json);
}

@freezed 
class DaySaleAmount with _$DaySaleAmount {
  const factory DaySaleAmount({
    @JsonKey(name: 'totalKg') @Default(0) int daySaleAmount,
    @JsonKey(name: 'day') @Default(0) int day,
  }) = _DaySaleAmount;

  factory DaySaleAmount.fromJson(Map<String, dynamic> json) => _$DaySaleAmountFromJson(json);
}

@freezed 
class ProductTotalSale with _$ProductTotalSale {
  const factory ProductTotalSale({
    @JsonKey(name: 'productName') @Default("") String productName,
    @JsonKey(name: 'totalKg') @Default(0) int totalProductSaleAmount,
    @JsonKey(name: 'percent') @Default(0) double percent,
  }) = _ProductTotalSale;

  factory ProductTotalSale.fromJson(Map<String, dynamic> json) => _$ProductTotalSaleFromJson(json);
}