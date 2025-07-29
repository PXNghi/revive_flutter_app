import 'dart:convert';

import 'package:http/http.dart';
import 'package:revive_flutter_project/core/configs/apis/api_urls.dart';
import 'package:revive_flutter_project/core/services/api_services.dart';
import 'package:revive_flutter_project/features/person/models/user.dart';

class UserUsecases {
  static final UserUsecases _singleton = UserUsecases._internal();

  factory UserUsecases() => _singleton;

  UserUsecases._internal();

  Future<dynamic> getUserProfileByToken(String token) async {
    try {
      ApiService.authorizeHeader(token);
      final Response response =
          await ApiService().get(ApiUrls().apiGetProfileByToken());
      final Map<String, dynamic> data = json.decode(response.body);
      print("response body: $data");
      return data;
    } catch (e) {
      print("Error at get user profile usecase: $e");
      rethrow;
    }
  }

  Future<bool> updateAddress(String address, double lat, double lon) async {
    try {
      final bodyRequest = {"address": address, "lat": lat, "lon": lon};
      final Response response =
          await ApiService().post(ApiUrls().apiUpdateAddress(), bodyRequest);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error at update address usecase: $e");
      rethrow;
    }
  }

  Future<List<User>> getAllUsers() async {
    try {
      final Response response =
          await ApiService().get(ApiUrls().apiGetAllUsers());
      final Map<String, dynamic> data = json.decode(response.body);
      return (data['data'] as List).map((e) => User.fromJson(e)).toList();
    } catch (e) {
      print("Error at get all users usecase: $e");
      rethrow;
    }
  }

  Future<bool> activateUser(String userId) async {
    try {
      final Response response = await ApiService()
          .patch(ApiUrls().apiActivateUserAccount(userId), {});
      final Map<String, dynamic> data = json.decode(response.body);
      return data['success'];
    } catch (e) {
      print("Error at activate user usecase: $e");
      rethrow;
    }
  }

  Future<bool> deactivateUser(String userId) async {
    try {
      final Response response = await ApiService()
          .patch(ApiUrls().apiDeactivateUserAccount(userId), {});
      final Map<String, dynamic> data = json.decode(response.body);
      print("data: $data");
      return data['success'];
    } catch (e) {
      print("Error at deactivate user usecase: $e");
      rethrow;
    }
  }
}
