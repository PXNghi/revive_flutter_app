import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:revive_flutter_project/features/product/model/category.dart';
import 'package:revive_flutter_project/features/product/model/product.dart';
import 'package:revive_flutter_project/features/product/product_usecases.dart';
import 'package:image_picker/image_picker.dart';

part 'product_event.dart';
part 'product_state.dart';
part 'product_bloc.freezed.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductUsecase _productUsecase = ProductUsecase();
  File? imageFile;
  ProductBloc() : super(const ProductState.initial()) {
    on<_FetchAllCategoriesAndProducts>(_handleFetchAllCategoriesAndProducts);
    on<_GetAllCategories>(_handleGetCategories);
    on<_SelectCategory>(_handleSelectCategory);
    on<_CreateCategory>(_handleCreateCategory);
    on<_UpdateCategory>(_handleUpdateCategory);
    on<_DeleteCategory>(_handleDeleteCategory);
    on<_GetAllProducts>(_handleGetAllProducts);
    on<_GetAllProductsByCategory>(_handleGetAllProductsByCategory);
    on<_CreateProduct>(_handleCreateProduct);
    on<_UpdateProduct>(_handleUpdateProduct);
    on<_DeleteProduct>(_handleDeleteProduct);
    on<_ToggleEditingMode>(_handleToggleEditingMode);
    on<_WarningDelete>(_handleWarningDelete);
    on<_UploadImage>(_handleUploadImage);
    on<_DeleteImage>(_handleDeleteImage);
  }

  FutureOr<void> _handleFetchAllCategoriesAndProducts(
    _FetchAllCategoriesAndProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductState.loading());
    final List<Category> categories = await _productUsecase.getAllCategories();
    final List<Product> products = await _productUsecase.getAllProducts();
    emit(ProductState.loaded(categories: categories, products: products));
  }

  FutureOr<void> _handleGetCategories(
    event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductState.loading());
    final List<Category> categories = await _productUsecase.getAllCategories();

    emit(ProductState.loaded(categories: categories));
  }

  FutureOr<void> _handleSelectCategory(
    _SelectCategory event,
    Emitter<ProductState> emit,
  ) async {
    if (state is Loaded) {
      final currentState = state as Loaded;
      emit(currentState.copyWith(selectedCategoryIndex: event.index));
    } else {
      emit(const ProductState.error("Invalid state for selecting category"));
    }
  }

  FutureOr<void> _handleCreateCategory(
    _CreateCategory event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductState.loading());
    String url = "";
    if (imageFile != null) {
      final uploadResponse =
          await _productUsecase.uploadImage([imageFile!.path]);
      url = uploadResponse.url[0];
    }
    final response = await _productUsecase.createCategory(
      event.categoryName,
      categoryImage: url,
    );
    if (response) {
      add(const ProductEvent.fetchAllCategoriesAndProducts());
    } else {
      emit(const ProductState.error("Đã có lỗi xảy ra khi tạo danh mục"));
    }
  }

  FutureOr<void> _handleUpdateCategory(
    _UpdateCategory event,
    Emitter<ProductState> emit,
  ) async {
    try {
      String url = "";
      if (imageFile != null) {
        final uploadResponse =
            await _productUsecase.uploadImage([imageFile!.path]);
        url = uploadResponse.url[0];
      }
      print("url: $url");
      final response = await _productUsecase.updateCategory(
        event.newCategoryId,
        event.newCategoryName,
        newCategoryImage: url,
      );
      if (response) {
        add(const ProductEvent.fetchAllCategoriesAndProducts());
        emit(const ProductState.productUpdated());
      } else {
        emit(
            const ProductState.error("Đã có lỗi xảy ra khi cập nhật danh mục"));
      }
    } catch (e) {
      print("Error updating category: $e");
      emit(ProductState.error("Error updating category: $e"));
    }
  }

  FutureOr<void> _handleDeleteCategory(
    _DeleteCategory event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductState.loading());
    try {
      final response = await _productUsecase.deleteCategory(event.categoryId);
      if (response) {
        add(const ProductEvent.fetchAllCategoriesAndProducts());
      } else {
        emit(const ProductState.error("Đã có lỗi xảy ra khi xóa danh mục"));
      }
    } catch (e) {
      print("Error deleting category: $e");
      emit(ProductState.error("Error deleting category: $e"));
    }
  }

  FutureOr<void> _handleGetAllProducts(
    _GetAllProducts event,
    Emitter<ProductState> emit,
  ) async {
    try {
      if (state is Loaded) {
        final currentState = state as Loaded;
        emit(const ProductState.loading());
        final List<Product> products = await _productUsecase.getAllProducts();
        emit(currentState.copyWith(products: products));
      }
    } catch (e) {
      print("Error fetching products: $e");
      emit(ProductState.error("Error fetching products: $e"));
    }
  }

  FutureOr<void> _handleGetAllProductsByCategory(
    _GetAllProductsByCategory event,
    Emitter<ProductState> emit,
  ) async {
    try {
      if (state is Loaded) {
        final loadedState = state as Loaded;
        emit(const ProductState.loading());
        final List<Product> products =
            await _productUsecase.getAllProductsByCategory(event.categoryId);
        emit(loadedState.copyWith(products: products));
      }
    } catch (e) {
      print("Error fetching products by category: $e");
      emit(ProductState.error("Error fetching products by category: $e"));
    }
  }

  FutureOr<void> _handleCreateProduct(
    _CreateProduct event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductState.loading());
    try {
      print("come here");
      String url = "";
      if (imageFile != null) {
        final uploadResponse =
            await _productUsecase.uploadImage([imageFile!.path]);
        url = uploadResponse.url[0];
        print("url: $url");
      }
      final response = await _productUsecase.createNewProduct(
        productName: event.name,
        productPrice: event.price,
        productCategory: event.categoryId,
        productDescription: event.description,
        productImage: url,
      );
      if (response) {
        emit(const ProductState.productCreated());
      } else {
        emit(const ProductState.error("Đã có lỗi xảy ra khi tạo sản phẩm"));
      }
    } catch (e) {
      print("Error creating product: $e");
      emit(ProductState.error("Error creating product: $e"));
    }
  }

  FutureOr<void> _handleUpdateProduct(
    _UpdateProduct event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductState.loading());
    try {
      final response = await _productUsecase.updateProduct(
        id: event.id,
        name: event.name,
        price: event.price,
        description: event.description,
        categoryId: event.categoryId,
        image: event.image,
      );

      if (response) {
        emit(const ProductState.productUpdated());
      } else {
        emit(
            const ProductState.error("Đã có lỗi xảy ra khi cập nhật sản phẩm"));
      }
    } catch (e) {
      print("Error updating product: $e");
      emit(ProductState.error("Error updating product: $e"));
    }
  }

  FutureOr<void> _handleDeleteProduct(
    _DeleteProduct event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductState.loading());
    try {
      final response = await _productUsecase.deleteProduct(event.id);
      if (response) {
        add(const ProductEvent.fetchAllCategoriesAndProducts());
      } else {
        emit(const ProductState.error("Đã có lỗi xảy ra khi xóa sản phẩm"));
      }
    } catch (e) {
      print("Error deleting product: $e");
      emit(ProductState.error("Error deleting product: $e"));
    }
  }

  FutureOr<void> _handleToggleEditingMode(
    _ToggleEditingMode event,
    Emitter<ProductState> emit,
  ) async {
    if (state is Loaded) {
      final currentState = state as Loaded;
      emit(currentState.copyWith(isEditingMode: !currentState.isEditingMode));
    } else {
      print("Invalid state for toggling editing mode");
      emit(const ProductState.error("Invalid state for toggling editing mode"));
    }
  }

  FutureOr<void> _handleWarningDelete(
    _WarningDelete event,
    Emitter<ProductState> emit,
  ) async {
    if (state is Loaded) {
      final currentState = state as Loaded;
      emit(
        currentState.copyWith(
          warningMessage: event.message,
          isDeleteProduct: event.isProduct,
          warningDeleteProductId: event.productId,
        ),
      );
    } else {
      print("Invalid state for warning delete");
      emit(const ProductState.error("Invalid state for warning delete"));
    }
  }

  FutureOr<void> _handleUploadImage(
    _UploadImage event,
    Emitter<ProductState> emit,
  ) async {
    try {
      if (state is Loaded) {
        final loadedState = state as Loaded;
        final result =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        if (result != null) {
          imageFile = File(result.path);
          emit(loadedState.copyWith(image: imageFile));
        }
      }
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  FutureOr<void> _handleDeleteImage(
    _DeleteImage event,
    Emitter<ProductState> emit,
  ) async {
    try {
      if (state is Loaded) {
        final loadedState = state as Loaded;
        if (event.isEdit == true) {
          // final res = await _productUsecase.deleteImage(event.imagePath!, );
          // if (res) {
          //   emit(loadedState.copyWith(image: null));
          // }
        } else {
          emit(loadedState.copyWith(image: null));
        }
      }
    } catch (e) {
      print("Error deleting image: $e");
    }
  }
}
