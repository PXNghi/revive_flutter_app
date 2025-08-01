
part of 'product_bloc.dart';

@freezed
class ProductState with _$ProductState {
  const factory ProductState.initial() = Initial;
  const factory ProductState.loading() = Loading;
  const factory ProductState.loaded({
    @Default([]) List<Category> categories,
    @Default(-1) int selectedCategoryIndex,
    @Default([]) List<Product> products,
    @Default(false) bool isEditingMode,
    String? warningMessage,
    @Default(false) bool isDeleteProduct,
    @Default("") String warningDeleteProductId,
    @Default("") String warningDeleteCategoryId,
    File? image,
  }) = Loaded;
  const factory ProductState.error(String message) = Error;
  const factory ProductState.productCreated() = ProductCreated;
  const factory ProductState.productUpdated() = ProductUpdated;
  const factory ProductState.productDeleted() = ProductDeleted;

  const ProductState._();

  List<Category>? get categories => mapOrNull(loaded: (state) => state.categories) ?? [];

  int get selectedCategoryIndex => mapOrNull(loaded: (state) => state.selectedCategoryIndex) ?? 0;

  List<Product>? get products => mapOrNull(loaded: (state) => state.products) ?? [];

  bool get isEditingMode => mapOrNull(loaded: (state) => state.isEditingMode) ?? false;

  String? get warningMessage => mapOrNull(loaded: (state) => state.warningMessage);

  bool get isDeleteProduct => mapOrNull(loaded: (state) => state.isDeleteProduct) ?? false;

  String get warningDeleteProductId => mapOrNull(loaded: (state) => state.warningDeleteProductId) ?? "";

  String get warningDeleteCategoryId => mapOrNull(loaded: (state) => state.warningDeleteCategoryId) ?? "";

  File? get image => mapOrNull(loaded: (state) => state.image);

}