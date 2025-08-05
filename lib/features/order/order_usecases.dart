import 'dart:convert';

import 'package:http/http.dart';
import 'package:revive_flutter_project/core/configs/apis/api_urls.dart';
import 'package:revive_flutter_project/core/services/api_services.dart';
import 'package:revive_flutter_project/features/order/models/added_list_product.dart';
import 'package:revive_flutter_project/features/order/models/detailed_order_model.dart';
import 'package:revive_flutter_project/features/order/models/slot_response.dart';
import 'package:revive_flutter_project/features/product/model/upload_image_response.dart';

class OrderUsecases {
  static final OrderUsecases _singleton = OrderUsecases._internal();

  factory OrderUsecases() => _singleton;

  OrderUsecases._internal();

  Future<SlotResponse> getAvailableSlots(String date) async {
    try {
      final Response response =
          await ApiService().get(ApiUrls().apiGetAvailableScheduleByDate(date));
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
      final Response response =
          await ApiService().get(ApiUrls().apiGetDisabledDates(month));
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

  Future<bool> createOrder({
    required String userName,
    required String userPhone,
    required String userAddress,
    String? userNote,
    required List<AddedListProduct> addedListProduct,
    required DateTime selectedDate,
  }) async {
    // final timeStart = selectedTime.split("-")[0];
    // final timeEnd = selectedTime.split("-")[1];
    // final timeStartStandardize = toIsoStringWithTimezone(
    //     combineDateAndTime(selectedDate, timeStart));
    // final timeEndStandardize = toIsoStringWithTimezone(
    //     combineDateAndTime(selectedDate, timeEnd));
    List<DetailedOrder> detailedOrders =
        addedListProduct.map((item) => item.detailedOrder).toList();
    try {
      final bodyRequest = {
        "userName": userName,
        "userPhone": userPhone,
        "userAddress": userAddress,
        "userNote": userNote ?? "",
        "pickUpDate": selectedDate.toIso8601String(),
        "products": detailedOrders,
      };

      final Response response =
          await ApiService().post(ApiUrls().apiCreateNewOrder(), bodyRequest);
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['success'] == true) {
        return true;
      } else {
        throw Exception(data['message']);
      }
    } catch (e) {
      print("Error at create order usecase: $e");
      rethrow;
    }
  }

  Future<UploadImageResponse> uploadImage(List<String> paths) async {
    try {
      final UploadImageResponse response = await ApiService()
          .uploadImage(ApiUrls().apiUploadOrderImage(), paths);
      return response;
    } catch (e) {
      print("Error uploading image: $e");
      rethrow;
    }
  }

  DateTime combineDateAndTime(DateTime date, String timeString) {
    final parts = timeString.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    return DateTime(date.year, date.month, date.day, hour, minute);
  }

  String toIsoStringWithTimezone(DateTime dt) {
    final duration = dt.timeZoneOffset;
    final hours = duration.inHours.abs().toString().padLeft(2, '0');
    final minutes = (duration.inMinutes.abs() % 60).toString().padLeft(2, '0');
    final sign = duration.isNegative ? '-' : '+';
    final offset = '$sign$hours:$minutes';

    return dt.toIso8601String() + offset;
  }
}
