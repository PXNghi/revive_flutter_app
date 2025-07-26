
part of 'product_bloc.dart';

@freezed 
class ProductEvent with _$ProductEvent {
  const factory ProductEvent.getAllCategories() = _GetAllCategories;
  const factory ProductEvent.selectCategory(int index) = _SelectCategory;
  const factory ProductEvent.createCategory(String categoryName) = _CreateCategory;
}