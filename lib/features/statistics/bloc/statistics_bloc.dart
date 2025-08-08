import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:revive_flutter_project/features/product/model/category.dart';
import 'package:revive_flutter_project/features/product/product_usecases.dart';
import 'package:revive_flutter_project/features/statistics/models/monthly_revenue.dart';
import 'package:revive_flutter_project/features/statistics/models/product_amount.dart';
import 'package:revive_flutter_project/features/statistics/models/product_sales.dart';
import 'package:revive_flutter_project/features/statistics/statistics_usecases.dart';

part 'statistics_event.dart';
part 'statistics_state.dart';
part 'statistics_bloc.freezed.dart';

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  final StatisticsUsecases _statisticsUsecases = StatisticsUsecases();
  final ProductUsecase _productUsecases = ProductUsecase();
  StatisticsBloc() : super(const StatisticsState.initial()) {
    on<_Started>(_handleInitial);
    on<_GetMonthlyRevenueByYear>(_handleGetMonthlyRevenueByYear);
    on<_GetAmountOfProduct>(_handleGetAmountOfProduct);
    on<_GetProductSalesInYear>(_handleGetProductSalesInYear);
  }

  FutureOr<void> _handleInitial(
    _Started event,
    Emitter<StatisticsState> emit,
  ) async {
    emit(const StatisticsState.loading());
    try {
      final List<MonthlyRevenue> monthlyRevenues = await _statisticsUsecases
          .getMonthlyRevenueByYear(DateTime.now().year.toString());
      final List<Category> categories =
          await _productUsecases.getAllCategories();
      final ProductAmount product =
          await _statisticsUsecases.getAmountOfProduct(categories.first.id);
      final ProductSales productSales =
          await _statisticsUsecases.getProductSalesInYear(
        DateTime.now().month,
        DateTime.now().year,
      );
      emit(StatisticsState.loaded(
        monthlyRevenues: monthlyRevenues,
        categories: categories,
        productAmount: product,
        productSales: productSales,
      ));
    } catch (e) {
      print("Error at initial statistics: $e");
    }
  }

  FutureOr<void> _handleGetMonthlyRevenueByYear(
    _GetMonthlyRevenueByYear event,
    Emitter<StatisticsState> emit,
  ) async {
    try {
      if (state is _Loaded) {
        final loadedState = state as _Loaded;
        final List<MonthlyRevenue> monthlyRevenues = await _statisticsUsecases
            .getMonthlyRevenueByYear(event.year.toString());
        emit(loadedState.copyWith(monthlyRevenues: monthlyRevenues));
      }
    } catch (e) {
      print("Error at get monthly revenue by year: $e");
    }
  }

  FutureOr<void> _handleGetAmountOfProduct(
    _GetAmountOfProduct event,
    Emitter<StatisticsState> emit,
  ) async {
    try {
      final ProductAmount product =
          await _statisticsUsecases.getAmountOfProduct(event.categoryId);
      if (state is _Loaded) {
        final loadedState = state as _Loaded;
        emit(loadedState.copyWith(productAmount: product));
      }
    } catch (e) {
      print("Error at get amount of product: $e");
    }
  }

  FutureOr<void> _handleGetProductSalesInYear(
    _GetProductSalesInYear event,
    Emitter<StatisticsState> emit,
  ) async {
    try {
      final ProductSales productSales = await _statisticsUsecases
          .getProductSalesInYear(event.month, event.year);
      if (state is _Loaded) {
        final loadedState = state as _Loaded;
        emit(loadedState.copyWith(productSales: productSales));
      }
    } catch (e) {
      print("Error at get product sales in year: $e");
    }
  }
}
