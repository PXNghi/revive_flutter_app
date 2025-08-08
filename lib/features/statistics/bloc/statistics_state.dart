part of 'statistics_bloc.dart';

@freezed
class StatisticsState with _$StatisticsState {
  const factory StatisticsState.initial() = _Initial;
  const factory StatisticsState.loading() = _Loading;
  const factory StatisticsState.loaded({
    @Default([]) List<Category> categories,
    @Default([]) List<MonthlyRevenue> monthlyRevenues,
    ProductAmount? productAmount,
    ProductSales? productSales,
  }) = _Loaded;
  const factory StatisticsState.error(String message) = _Error;

  const StatisticsState._();

  List<MonthlyRevenue> get monthlyRevenues => mapOrNull(loaded: (state) => state.monthlyRevenues) ?? [];

  List<Category> get categories => mapOrNull(loaded: (state) => state.categories) ?? [];

  ProductAmount? get productAmount => mapOrNull(loaded: (state) => state.productAmount);

  ProductSales? get productSales => mapOrNull(loaded: (state) => state.productSales);
}
