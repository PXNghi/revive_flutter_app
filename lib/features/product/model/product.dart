import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:revive_flutter_project/features/product/model/category.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed 
class Product with _$Product {
  const factory Product({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'description') @Default("") String description,
    @JsonKey(name: 'price') @Default(0.0) double price,
    @JsonKey(name: 'image') @Default("") String image,
    @JsonKey(name: 'amount') @Default(0) int amount,
    @JsonKey(name: 'category') required Category category,
  }) = _Product;

  factory Product.fromJson(Map<String, Object?> json) => _$ProductFromJson(json);
}