
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
  Uri apiSendForgetPasswordOtp() => Uri.parse('$baseUrl/api/auth/send-forgot-password-code');
  Uri apiConfirmForgetPasswordOtp() => Uri.parse('$baseUrl/api/auth/confirm-forgot-verification-code');
  Uri apiResetPassword() => Uri.parse('$baseUrl/api/auth/reset-password');

  // user
  Uri apiGetProfileByToken() => Uri.parse('$baseUrl/api/user/get-profile-by-token');

  // branch
  Uri apiGetAllBranches() => Uri.parse('$baseUrl/api/branch/get-all-branches');
  Uri apiGetBranchById(String id) => Uri.parse('$baseUrl/api/branch/get-branch-by-id/$id');
  Uri apiCreateNewBranch() => Uri.parse('$baseUrl/api/branch/create-new-branch');
  Uri apiUpdateBranch(String id) => Uri.parse('$baseUrl/api/branch/update-branch/$id');
  Uri apiDeleteBranch(String id) => Uri.parse('$baseUrl/api/branch/delete-branch/$id');

}