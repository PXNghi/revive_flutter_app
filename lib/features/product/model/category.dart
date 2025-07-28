import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';
part 'category.g.dart';

@freezed 
class Category with _$Category {
  const factory Category({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: 'category_name') required String name,
    @JsonKey(name: 'category_description') required String description,
    @JsonKey(name: 'category_image') @Default("") String image,
  }) = _Category;

  factory Category.fromJson(Map<String, Object?> json) => _$CategoryFromJson(json);
}