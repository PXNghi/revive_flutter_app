import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:revive_flutter_project/features/product/model/category.dart';
import 'package:revive_flutter_project/features/product/model/product.dart';
import 'package:revive_flutter_project/features/product/product_usecases.dart';

part 'product_event.dart';
part 'product_state.dart';
part 'product_bloc.freezed.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductUsecase _productUsecase = ProductUsecase();
  ProductBloc() : super(const ProductState.initial()) {
    on<_FetchAllCategoriesAndProducts>(_handleFetchAllCategoriesAndProducts);
    on<_GetAllCategories>(_handleGetCategories);
    on<_SelectCategory>(_handleSelectCategory);
    on<_CreateCategory>(_handleCreateCategory);
    on<_GetAllProducts>(_handleGetAllProducts);
    on<_GetAllProductsByCategory>(_handleGetAllProductsByCategory);
    on<_CreateProduct>(_handleCreateProduct);
    on<_UpdateProduct>(_handleUpdateProduct);
    on<_DeleteProduct>(_handleDeleteProduct);
  }

  FutureOr<void> _handleFetchAllCategoriesAndProducts(
    _FetchAllCategoriesAndProducts event,
    Emitter<ProductState> emit,
  ) async {
    print("Fetching all categories and products");
    emit(const ProductState.loading());
    final List<Category> categories = await _productUsecase.getAllCategories();
    final List<Product> products = await _productUsecase.getAllProducts();
    print("fetched");
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
    final response = await _productUsecase.createCategory(event.categoryName);
    if (response) {
      add(const ProductEvent.getAllCategories());
    } else {
      emit(const ProductState.error("Đã có lỗi xảy ra khi tạo danh mục"));
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
      emit(ProductState.error("Error fetching products by category: $e"));
    }
  }

  FutureOr<void> _handleUpdateProduct(
    _UpdateProduct event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductState.loading());
    try {
      final response = await _productUsecase.updateProduct(event.product);
      if (response) {
        add(const ProductEvent.getAllProducts());
      } else {
        emit(
            const ProductState.error("Đã có lỗi xảy ra khi cập nhật sản phẩm"));
      }
    } catch (e) {
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
        add(const ProductEvent.getAllProducts());
      } else {
        emit(const ProductState.error("Đã có lỗi xảy ra khi xóa sản phẩm"));
      }
    } catch (e) {
      emit(ProductState.error("Error deleting product: $e"));
    }
  }

  FutureOr<void> _handleCreateProduct(
    _CreateProduct event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductState.loading());
    try {
      final response = await _productUsecase.createNewProduct(
        productName: event.name,
        productPrice: event.price,
        productCategory: event.categoryId,
        productDescription: event.description,
        productImage: event.image,
      );
      if (response) {
        emit(const ProductState.productCreated());
      } else {
        emit(const ProductState.error("Đã có lỗi xảy ra khi tạo sản phẩm"));
      }
    } catch (e) {
      emit(ProductState.error("Error creating product: $e"));
    }
  }
}
