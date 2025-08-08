part of 'statistics_bloc.dart';

@freezed
class StatisticsEvent with _$StatisticsEvent {
  const factory StatisticsEvent.started() = _Started;
  const factory StatisticsEvent.refresh() = _Refresh;
  const factory StatisticsEvent.getMonthlyRevenueByYear(String year) = _GetMonthlyRevenueByYear;
  const factory StatisticsEvent.getAmountOfProduct(String categoryId) = _GetAmountOfProduct;
  const factory StatisticsEvent.getSaledProductInYear(int month, int year) = _GetProductSalesInYear;
}