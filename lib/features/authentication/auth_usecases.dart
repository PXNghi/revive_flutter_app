import 'dart:convert';

import 'package:http/http.dart';
import 'package:revive_flutter_project/core/configs/apis/api_urls.dart';
import 'package:revive_flutter_project/core/services/api_services.dart';
import 'package:revive_flutter_project/core/services/session_data.dart';
import 'package:revive_flutter_project/features/authentication/models/auth_response.dart';

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

  Future<AuthResponse> login(String email, String password) async {
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
        await SessionData.login(data["token"], data);
        return const AuthResponse(success: true, message: "Đăng nhập thành công");
      } else {
        print("error login: ${data["message"]}");
        return AuthResponse(success: false, message: data["message"]);
      }
    } catch (e) {
      print("Error at login usecase: $e");
      rethrow;
    }
  }

  Future<AuthResponse> register({
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
      return AuthResponse(success: data["success"], message: data["message"]);
    } catch (e) {
      print("Error at register usecase: $e");
      rethrow;
    }
  }

  Future<bool> logout() async {
    await SessionData.logout();
    return true;
  }

  Future<AuthResponse> verifyAccount(String email, String otp) async {
    final Map<String, String> bodyRequest = {
      "email": email.trim(),
      "provided_code": otp,
    };
    try {
      final Response response = await ApiService()
          .post(ApiUrls().apiConfirmVerificationOtp(), bodyRequest);
      final Map<String, dynamic> data = json.decode(response.body);
      return AuthResponse(success: data["success"] ?? false, message: data["message"]);
    } catch (e) {
      print("Error at verify account usecase: $e");
      rethrow;
    }
  }

  Future<bool> resendOTP(String email) async {
    final Response response = await ApiService() 
        .post(ApiUrls().apiSendVerificationOtp(), {"email": email.trim()});
    final Map<String, dynamic> data = json.decode(response.body);
    print(data);
    return data['success'];
  }

  Future<AuthResponse> sendForgetPasswordOTP(String email) async {
    final Map<String, String> bodyRequest = {
      "email": email.trim(),
    };
    try {
      final Response response = await ApiService().patch(ApiUrls().apiSendForgetPasswordOtp(), bodyRequest);
      final Map<String, dynamic> data = json.decode(response.body);
      return AuthResponse(success: data["success"] ?? false, message: data["message"]);
    } catch (e) {
      print("Error at send forget password otp usecase: $e");
      rethrow;
    }
  }

  Future<AuthResponse> verifyForgetPasswordOTP(String email, String otp) async {
    final Map<String, String> bodyRequest = {
      "email": email.trim(),
      "provided_code": otp,
    };
    try {
      final Response response = await ApiService()
          .post(ApiUrls().apiConfirmForgetPasswordOtp(), bodyRequest);
      final Map<String, dynamic> data = json.decode(response.body);
      return AuthResponse(success: data["success"] ?? false, message: data["message"]);
    } catch (e) {
      print("Error at verify forget password otp usecase: $e");
      rethrow;
    }
  }

  Future<AuthResponse> resetPassword(String email, String password, String confirmedPassword) async {
    final Map<String, String> bodyRequest = {
      "email": email.trim(),
      "new_password": password,
      "confirmed_password": confirmedPassword
    };
    try {
      final Response response = await ApiService()
          .patch(ApiUrls().apiResetPassword(), bodyRequest);
      final Map<String, dynamic> data = json.decode(response.body);
      return AuthResponse(success: data["success"] ?? false, message: data["message"]);
    } catch (e) {
      print("Error at reset password usecase: $e");
      rethrow;
    }
  }
}
