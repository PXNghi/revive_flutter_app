import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:revive_flutter_project/core/constants/numbers.dart';

class ApiService {
  static final Map<String, String> _header = {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };

  static void authorizeHeader(String token) {
    _header["Authorization"] = "Bearer $token";
  }

  static void unauthorizeHeader() {
    _header.remove("Authorization");
  }

  Future<http.Response> get(Uri link) async {
    try {
      final http.Response response = await http.get(link, headers: _header).timeout(
        apiTimeOutDuration, onTimeout: () {
          throw TimeoutException('The connection has timed out, Please try again.');
        }
      );
      return response;
    } catch (e) {
      print("Error at get request: $e");
      rethrow;
    }
  }

  Future<http.Response> post(Uri link, Map<String, dynamic> data) async {
    try {
      final String body = json.encode(data);
      final http.Response response = await http.post(
        link,
        headers: _header,
        body: body,
      ).timeout(apiTimeOutDuration, onTimeout: () {
        throw TimeoutException('The connection has timed out, Please try again.');
      });
      return response;
    } catch (e) {
      print("Error at post request: $e");
      rethrow;
    }
  }

  Future<http.Response> put(Uri link, Map<String, dynamic> data) async {
    try {
      final String body = json.encode(data);
      final http.Response response = await http.put(
        link,
        headers: _header,
        body: body,
      ).timeout(apiTimeOutDuration, onTimeout: () {
        throw TimeoutException('The connection has timed out, Please try again.');
      });
      return response;
    } catch (e) {
      print("Error at put request: $e");
      rethrow;
    }
  }

  Future<http.Response> patch(Uri link, Map<String, dynamic> data) async {
    try {
      final String body = json.encode(data);
      final http.Response response = await http.patch(
        link,
        headers: _header,
        body: body,
      ).timeout(apiTimeOutDuration, onTimeout: () {
        throw TimeoutException('The connection has timed out, Please try again.');
      });
      return response;
    } catch (e) {
      print("Error at patch request: $e");
      rethrow;
    }
  }

  Future<http.Response> delete(Uri link, {Map<String, dynamic>? data}) async {
    try {
      final String body = json.encode(data ?? {});
      final http.Response response = await http.delete(
        link,
        headers: _header,
        body: body,
      ).timeout(apiTimeOutDuration, onTimeout: () {
        throw TimeoutException('The connection has timed out, Please try again.');
      });
      return response;
    } catch (e) {
      print("Error at delete request: $e");
      rethrow;
    }
  }
}