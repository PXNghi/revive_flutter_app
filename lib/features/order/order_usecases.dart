
import 'dart:convert';

import 'package:http/http.dart';
import 'package:revive_flutter_project/core/configs/apis/api_urls.dart';
import 'package:revive_flutter_project/core/services/api_services.dart';
import 'package:revive_flutter_project/features/order/models/slot_response.dart';

class OrderUsecases {
  static final OrderUsecases _singleton = OrderUsecases._internal();

  factory OrderUsecases() => _singleton;

  OrderUsecases._internal();

  Future<SlotResponse> getAvailableSlots(String date) async {
    try {
      final Response response = await ApiService().get(ApiUrls().apiGetAvailableScheduleByDate(date));
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['success'] == true) {
        return SlotResponse.fromJson(data);
      } else {
        throw Exception(data['message']);
      }
    } catch (e) {
      print("Error at get available slots usecase: $e");
      rethrow;
    }
  }

  Future<List<DateTime>> getDisabledDates(String month) async {
    try {
      final Response response = await ApiService().get(ApiUrls().apiGetDisabledDates(month));
      print("month is: $month");
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['success'] == true) {
        return (data['data'] as List).map((e) => DateTime.parse(e)).toList();
      } else {
        throw Exception(data['message']);
      }
    } catch (e) {
      print("Error at get disabled date usecase: $e");
      rethrow;
    }
  }

}