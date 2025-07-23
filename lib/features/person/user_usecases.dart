import 'dart:convert';

import 'package:http/http.dart';
import 'package:revive_flutter_project/core/configs/apis/api_urls.dart';
import 'package:revive_flutter_project/core/services/api_services.dart';

class UserUsecases {
  static final UserUsecases _singleton = UserUsecases._internal();

  factory UserUsecases() => _singleton;

  UserUsecases._internal();

  Future<dynamic> getUserProfileByToken(String token) async {
    try {
      ApiService.authorizeHeader(token);
      final Response response = await ApiService().get(ApiUrls().apiGetProfileByToken());
      final Map<String, dynamic> data = json.decode(response.body);
      print("response body: $data");
      return data;
    } catch (e) {
      print("Error at get user profile usecase: $e");
      rethrow;
    }
  }
}