
import 'package:revive_flutter_project/core/configs/apis/my_enviroment.dart';

class ApiUrls {
  static final ApiUrls _singleton = ApiUrls._internal();

  ApiUrls._internal();

  factory ApiUrls() => _singleton;

  static final String baseUrl = Enviroment.baseUrl;

  // authentication
  Uri apiLogin() => Uri.parse('$baseUrl/api/auth/login');
  Uri apiRegister() => Uri.parse('$baseUrl/api/auth/register');
  Uri apiSendVerificationOtp() => Uri.parse('$baseUrl/api/auth/send-verification-code');
  Uri apiConfirmVerificationOtp() => Uri.parse('$baseUrl/api/auth/confirmed-verification-code');
  Uri apiChangePassword() => Uri.parse('$baseUrl/api/auth/change-password');
  Uri apiSendForgetPasswordOtp() => Uri.parse('$baseUrl/api/auth/send-forget-password-code');
  Uri apiConfirmForgetPasswordOtp() => Uri.parse('$baseUrl/api/auth/confirm-forgot-verification-code');
  Uri apiResetPassword() => Uri.parse('$baseUrl/api/auth/reset-password');

}