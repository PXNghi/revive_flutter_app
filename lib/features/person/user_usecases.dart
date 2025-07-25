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

  Future<bool> updateAddress(String address, double lat, double lon) async {
    print("debug");
    print("address: $address, lat: $lat, lon: $lon");
    try {
      print("come to update huh");
      final bodyRequest = {"address": address, "lat": lat, "lon": lon};
      final Response response = await ApiService().post(ApiUrls().apiUpdateAddress(), bodyRequest);
        print(response.body);
      if (response.statusCode == 200) {
        print("come true");
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error at update address usecase: $e");
      rethrow;
    }
  }
}