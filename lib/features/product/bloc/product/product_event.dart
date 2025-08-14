part of 'product_bloc.dart';

@freezed
class ProductEvent with _$ProductEvent {
  const factory ProductEvent.fetchAllCategoriesAndProducts() =
      _FetchAllCategoriesAndProducts;
  const factory ProductEvent.getAllCategories() = _GetAllCategories;
  const factory ProductEvent.selectCategory(int index) = _SelectCategory;
  const factory ProductEvent.createCategory(String categoryName,
      {String? categoryUrl}) = _CreateCategory;
  const factory ProductEvent.updateCategory(
    String newCategoryId,
    String newCategoryName, {
    String? newCategoryUrl,
    String? type,
  }) = _UpdateCategory;
  const factory ProductEvent.deleteCategory(String categoryId) =
      _DeleteCategory;

  const factory ProductEvent.getAllProducts({String? search}) = _GetAllProducts;
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
  const factory ProductEvent.updateProduct({
    required String id,
    String? name,
    double? price,
    String? description,
    String? categoryId,
    String? image,
  }) = _UpdateProduct;
  const factory ProductEvent.deleteProduct(String id) = _DeleteProduct;
  const factory ProductEvent.toggleEditingMode() = _ToggleEditingMode;
  const factory ProductEvent.warningDelete(
    String message,
    bool isProduct,
    String productId,
    String categoryId,
  ) = _WarningDelete;
  const factory ProductEvent.uploadImage() = _UploadImage;
  const factory ProductEvent.editImage(String path, String type) =
      _EditImage;
  const factory ProductEvent.deleteImage() = _DeleteImage;
  const factory ProductEvent.toggleSearchMode() = _ToggleSearchMode;
  const factory ProductEvent.refreshPage() = _RefreshPage;
}
