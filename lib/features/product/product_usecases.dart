import 'dart:convert';

import 'package:http/http.dart';
import 'package:revive_flutter_project/core/configs/apis/api_urls.dart';
import 'package:revive_flutter_project/core/services/api_services.dart';
import 'package:revive_flutter_project/features/product/model/category.dart';
import 'package:revive_flutter_project/features/product/model/product.dart';

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

  Future<bool> updateCategory(
    String newCategoryId,
    String newCategoryName,
  ) async {
    final bodyRequest = {
      'category_name': newCategoryName,
      'category_description': "",
    };

    try {
      final Response response = await ApiService().put(
        ApiUrls().apiUpdateCategory(newCategoryId),
        bodyRequest,
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        print("Error updating category: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error updating category: $e");
      return false;
    }
  }

  Future<bool> deleteCategory(String categoryId) async {
    try {
      final Response response = await ApiService().delete(
        ApiUrls().apiDeleteCategory(categoryId),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        print("Error deleting category: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error deleting category: $e");
      return false;
    }
  }

  Future<List<Product>> getAllProducts() async {
    try {
      final Response response =
          await ApiService().get(ApiUrls().apiGetAllProducts());
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> data = responseData['data'];
      if (data.isEmpty) {
        return [];
      } else {
        return data.map((product) => Product.fromJson(product)).toList();
      }
    } catch (e) {
      print("Error fetching products: $e");
      rethrow;
    }
  }

  Future<List<Product>> getAllProductsByCategory(String categoryId) async {
    try {
      final Response response = await ApiService().get(
        ApiUrls().apiGetAllProductsByCategory(categoryId),
      );
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> data = responseData['data'];
      if (data.isEmpty) {
        return [];
      } else {
        return data.map((product) => Product.fromJson(product)).toList();
      }
    } catch (e) {
      print("Error fetching products by category: $e");
      rethrow;
    }
  }

  Future<bool> createNewProduct({
    required String productName,
    required double productPrice,
    required String productCategory,
    String? productDescription,
    String? productImage,
  }) async {
    final bodyRequest = {
      'name': productName,
      'price': productPrice,
      'description': productDescription ?? "",
      'category': productCategory,
      'image': productImage ?? "",
    };

    try {
      final Response response = await ApiService().post(
        ApiUrls().apiCreateNewProduct(),
        bodyRequest,
      );
      if (response.statusCode == 201) {
        return true;
      } else {
        print("Error creating product: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error creating product: $e");
      return false;
    }
  }

  Future<bool> updateProduct({
    required String id,
    String? name,
    double? price,
    String? description,
    String? categoryId,
    String? image,
  }) async {
    final Map<String, dynamic> bodyRequest = {};

    if (name != null) bodyRequest['name'] = name;
    if (price != null) bodyRequest['price'] = price.toString();
    if (description != null) bodyRequest['description'] = description;
    if (categoryId != null) bodyRequest['category'] = categoryId;
    if (image != null) bodyRequest['image'] = image;

    try {
      final Response response = await ApiService().put(
        ApiUrls().apiUpdateProduct(id),
        bodyRequest,
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        print("Error updating product: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error updating product: $e");
      return false;
    }
  }

  Future<bool> deleteProduct(String id) async {
    try {
      final Response response = await ApiService().delete(
        ApiUrls().apiDeleteProduct(id),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        print("Error deleting product: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error deleting product: $e");
      return false;
    }
  }
}
