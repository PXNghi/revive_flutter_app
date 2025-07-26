import 'dart:convert';

import 'package:http/http.dart';
import 'package:revive_flutter_project/core/configs/apis/api_urls.dart';
import 'package:revive_flutter_project/core/services/api_services.dart';
import 'package:revive_flutter_project/features/product/model/category.dart';

class ProductUsecase {
  static final ProductUsecase _singleton = ProductUsecase._internal();

  factory ProductUsecase() => _singleton;

  ProductUsecase._internal();

  Future<List<Category>> getAllCategories() async {
    try {
      final Response response =
          await ApiService().get(ApiUrls().apiGetAllCategories());
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> data = responseData['data'];
      if (data.isEmpty) {
        return [];
      } else {
        return data.map((category) => Category.fromJson(category)).toList();
      }
    } catch (e) {
      print("Error fetching categories: $e");
      rethrow;
    }
  }

  Future<bool> createCategory(String categoryName) async {
    final bodyRequest = {
      'category_name': categoryName,
      'category_description': "",
    };

    try {
      final Response response = await ApiService().post(
        ApiUrls().apiCreateNewCategory(),
        bodyRequest,
      );
      if (response.statusCode == 201) {
        return true;
      } else {
        print("Error creating category: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error creating category: $e");
      return false;
    }
  }
}
