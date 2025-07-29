import 'dart:convert';

import 'package:http/http.dart';
import 'package:revive_flutter_project/core/configs/apis/api_urls.dart';
import 'package:revive_flutter_project/core/services/api_services.dart';
import 'package:revive_flutter_project/core/services/session_data.dart';
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

  Future<User> getUserById(String userId) async {
    try {
      final Response response =
          await ApiService().get(ApiUrls().apiGetUserById(userId));
      final Map<String, dynamic> data = json.decode(response.body);
      return User.fromJson(data['data']);
    } catch (e) {
      print("Error at get user by id usecase: $e");
      rethrow;
    }
  }

  Future<User?> updateUserProfileById(
    String userId,
    String userName,
    String userPhone,
  ) async {
    final Map<String, String> bodyRequest = {
      "full_name": userName,
      "phone": userPhone,
    };
    try {
      final Response response = await ApiService().put(
        ApiUrls().apiUpdateUserProfileById(userId),
        bodyRequest,
      );
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['success'] == false) {
        return null;
      } else {
        final token = await SessionData.token();
        SessionData.login(token, data['data']);
        return User.fromJson(data['data']);
      }
    } catch (e) {
      print("Error at update user profile by id usecase: $e");
      rethrow;
    }
  }

  Future<String?> changePassword(String oldPassword, String newPassword, String confirmedPassword) async {
    final Map<String, String> bodyRequest = {
      "old_password": oldPassword,
      "new_password": newPassword,
      "confirmed_password": confirmedPassword,
    };
    try {
      final Response response = await ApiService().patch(ApiUrls().apiChangePassword(), bodyRequest);
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['success'] == true) {
        return null;
      } else {
        return data['message'];
      }
      
    } catch (e) {
      print("Error at change password usecase: $e");
      rethrow;
    }
  }
}
