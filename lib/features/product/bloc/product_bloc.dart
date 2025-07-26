import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:revive_flutter_project/features/product/model/category.dart';
import 'package:revive_flutter_project/features/product/product_usecases.dart';

part 'product_event.dart';
part 'product_state.dart';
part 'product_bloc.freezed.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductUsecase _productUsecase = ProductUsecase();
  ProductBloc() : super(const ProductState.initial()) {
    on<_GetAllCategories>(_handleGetCategories);
    on<_SelectCategory>(_handleSelectCategory);
    on<_CreateCategory>(_handleCreateCategory);
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
}
