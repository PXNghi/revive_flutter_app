part of 'home_bloc.dart';

@freezed 
class HomeState with _$HomeState {
  const factory HomeState.initial() = HomeInitial;
  const factory HomeState.loading() = HomeLoading;
  const factory HomeState.loaded({
    @Default([]) List<Branch> branches,
    @Default([]) List<Product> products
  }) = HomeLoaded;
  const factory HomeState.error(String message) = HomeError;

  const HomeState._();

  List<Branch>? get branches => mapOrNull(loaded: (value) => value.branches) ?? [];

  List<Product>? get products => mapOrNull(loaded: (value) => value.products) ?? [];

}