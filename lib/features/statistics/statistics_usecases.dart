import 'dart:convert';

import 'package:http/http.dart';
import 'package:revive_flutter_project/core/configs/apis/api_urls.dart';
import 'package:revive_flutter_project/core/services/api_services.dart';
import 'package:revive_flutter_project/features/statistics/models/monthly_revenue.dart';
import 'package:revive_flutter_project/features/statistics/models/product_amount.dart';
import 'package:revive_flutter_project/features/statistics/models/product_sales.dart';

class StatisticsUsecases {
  static final StatisticsUsecases _singleton = StatisticsUsecases._internal();

  factory StatisticsUsecases() => _singleton;

  StatisticsUsecases._internal();

  Future<List<MonthlyRevenue>> getMonthlyRevenueByYear(String year) async {
    try {
      final Response response =
          await ApiService().get(ApiUrls().apiGetMonthlyRevenue(year));
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['success'] == true) {
        return (data['data'] as List)
            .map((e) => MonthlyRevenue.fromJson(e))
            .toList();
      } else {
        print("Error at get monthly usecase: ${data['message']}");
        return [];
      }
    } catch (e) {
      print("Error at get monthly usecase: $e");
      rethrow;
    }
  }

  Future<ProductAmount> getAmountOfProduct(String categoryId) async {
    try {
      final Response response =
          await ApiService().get(ApiUrls().apiGetAmountOfProduct(categoryId));
      final Map<String, dynamic> data = json.decode(response.body);
      return ProductAmount.fromJson(data);
    } catch (e) {
      print("Error at get amount of product usecase: $e");
      rethrow;
    }
  }

  Future<ProductSales> getProductSalesInYear(int month, int year) async {
    try {
      final Response response =
          await ApiService().get(ApiUrls().apiGetSaledProduct(month, year));
      final Map<String, dynamic> data = json.decode(response.body);
      return ProductSales.fromJson(data['data']);
    } catch (e) {
      print("Error at get product sales in year usecase: $e");
      rethrow;
    }
  }
}
