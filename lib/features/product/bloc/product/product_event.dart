part of 'product_bloc.dart';

@freezed
class ProductEvent with _$ProductEvent {
  const factory ProductEvent.fetchAllCategoriesAndProducts() =
      _FetchAllCategoriesAndProducts;
  const factory ProductEvent.getAllCategories() = _GetAllCategories;
  const factory ProductEvent.selectCategory(int index) = _SelectCategory;
  const factory ProductEvent.createCategory(String categoryName) =
      _CreateCategory;
  const factory ProductEvent.getAllProducts() = _GetAllProducts;
  const factory ProductEvent.getAllProductsByCategory(String categoryId) =
      _GetAllProductsByCategory;
  const factory ProductEvent.getProductById(String id) = _GetProductById;
  const factory ProductEvent.createProduct({
    required String name,
    required double price,
    @Default("") String description,
    required String categoryId,
    @Default("") String image,
  }) = _CreateProduct;
  const factory ProductEvent.updateProduct(Product product) = _UpdateProduct;
  const factory ProductEvent.deleteProduct(String id) = _DeleteProduct;
}
