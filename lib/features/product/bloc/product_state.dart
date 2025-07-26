
part of 'product_bloc.dart';

@freezed
class ProductState with _$ProductState {
  const factory ProductState.initial() = Initial;
  const factory ProductState.loading() = Loading;
  const factory ProductState.loaded({
    @Default([]) List<Category> categories,
    @Default(0) int selectedCategoryIndex,
  }) = Loaded;
  const factory ProductState.error(String message) = Error;

  const ProductState._();

  List<Category> get categories => mapOrNull(loaded: (state) => state.categories) ?? [];

  int get selectedCategoryIndex => mapOrNull(loaded: (state) => state.selectedCategoryIndex) ?? 0;
}