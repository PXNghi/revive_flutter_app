import 'dart:convert';

import 'package:http/http.dart';
import 'package:revive_flutter_project/core/configs/apis/api_urls.dart';
import 'package:revive_flutter_project/core/services/api_services.dart';
import 'package:revive_flutter_project/core/services/session_data.dart';

class AuthUsecases {
  static final AuthUsecases _singleton = AuthUsecases._internal();

  factory AuthUsecases() => _singleton;

  AuthUsecases._internal();

  Future<bool> isLoggedIn() async {
    final String token = await SessionData.token();
    if (token.isEmpty) {
      return false;
    } else {
      try {
        ApiService.authorizeHeader(token);
        return true;
      } catch (e) {
        await SessionData.logout();
        return false;
      }
    }
  }

  Future<bool> login(String email, String password) async {
    final bodyRequest = {
      "email": email,
      "password": password,
    };
    try {
      final Response response = await ApiService().post(
        ApiUrls().apiLogin(),
        bodyRequest,
      );
      final Map<String, dynamic> data = json.decode(response.body);
      if (data["success"] == true) {
        ApiService.authorizeHeader(data["data"]["token"]);
        await SessionData.setToken(data["data"]["token"]);
        return true;
      } else {
        print("error login: ${data["message"]}");
      }
    } catch (e) {
      print("Error at login usecase: $e");
      rethrow;
    }
    return false;
  }

  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final Map<String, String> bodyRequest = {
      "full_name": fullName,
      "email": email,
      "password": password,
      "confirmed_password": confirmPassword
    };
    try {
      final Response response = await ApiService().post(
        ApiUrls().apiRegister(),
        bodyRequest,
      );
      final Map<String, dynamic> data = json.decode(response.body);
      if (data["success"] == true) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error at register usecase: $e");
      rethrow;
    }
  }
}
