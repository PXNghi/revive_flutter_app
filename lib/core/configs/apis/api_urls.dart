
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
  Uri apiUpdateAddress() => Uri.parse('$baseUrl/api/user/update-user-address');
  Uri apiUpdateProfile() => Uri.parse('$baseUrl/api/user/update-profile');
  Uri apiGetAllUsers() => Uri.parse('$baseUrl/api/user/get-all-users');
  Uri apiActivateUserAccount(String userId) => Uri.parse('$baseUrl/api/user/activate-account/$userId');
  Uri apiDeactivateUserAccount(String userId) => Uri.parse('$baseUrl/api/user/unactivate-account/$userId');
  Uri apiGetUserById(String userId) => Uri.parse('$baseUrl/api/user/get-user-by-id/$userId');
  Uri apiUpdateUserProfileById(String userId) => Uri.parse('$baseUrl/api/user/update-user-profile-by-id/$userId');

  // branch
  Uri apiGetAllBranches() => Uri.parse('$baseUrl/api/branch/get-all-branches');
  Uri apiGetBranchById(String id) => Uri.parse('$baseUrl/api/branch/get-branch-by-id/$id');
  Uri apiCreateNewBranch() => Uri.parse('$baseUrl/api/branch/create-new-branch');
  Uri apiUpdateBranch(String id) => Uri.parse('$baseUrl/api/branch/update-branch/$id');
  Uri apiDeleteBranch(String id) => Uri.parse('$baseUrl/api/branch/delete-branch/$id');
  Uri apiGetAllBranchesNearby(double lat, double lon) => Uri.parse('$baseUrl/api/branch/get-all-branches-nearby?lat=$lat&lon=$lon');

  // category
  Uri apiGetAllCategories() => Uri.parse('$baseUrl/api/category/get-all-categories');
  Uri apiGetCategoryById(String id) => Uri.parse('$baseUrl/api/category/get-category-by-id/$id');
  Uri apiCreateNewCategory() => Uri.parse('$baseUrl/api/category/create-new-category');
  Uri apiUpdateCategory(String id) => Uri.parse('$baseUrl/api/category/update-category/$id');
  Uri apiDeleteCategory(String id) => Uri.parse('$baseUrl/api/category/delete-category/$id');

  // product
  Uri apiGetAllProducts() => Uri.parse('$baseUrl/api/product/get-all-products');
  Uri apiGetAllProductsByCategory(String categoryId) => Uri.parse('$baseUrl/api/product/get-product-by-category/$categoryId');
  Uri apiGetProductById(String id) => Uri.parse('$baseUrl/api/product/get-product-by-id/$id');
  Uri apiCreateNewProduct() => Uri.parse('$baseUrl/api/product/create-new-product');
  Uri apiUpdateProduct(String id) => Uri.parse('$baseUrl/api/product/update-product/$id');
  Uri apiDeleteProduct(String id) => Uri.parse('$baseUrl/api/product/delete-product/$id');
}