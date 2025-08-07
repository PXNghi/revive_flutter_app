import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:revive_flutter_project/core/constants/numbers.dart';
import 'package:revive_flutter_project/core/services/session_data.dart';
import 'package:revive_flutter_project/features/product/model/upload_image_response.dart';
import 'package:mime/mime.dart';

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

  Future<UploadImageResponse> uploadImage(
  Uri url,
  List<String> paths,
) async {
  final request = http.MultipartRequest('POST', url);

  for (String path in paths) {
    final mimeType = lookupMimeType(path);
    final mediaType = mimeType != null
        ? MediaType.parse(mimeType)
        : MediaType('application', 'octet-stream');

    final file = await http.MultipartFile.fromPath(
      'images',
      path,
      contentType: mediaType,
    );

    request.files.add(file);
  }

  request.headers.addAll({
    'Authorization': 'Bearer ${SessionData.token()}',
    'Accept': 'application/json',
  });

  final streamedResponse = await request.send();
  final response = await http.Response.fromStream(streamedResponse);

  if (response.statusCode == 200) {
    print("Upload thành công: ${response.body}");
    return UploadImageResponse.fromJson(jsonDecode(response.body));
  } else {
    print("Lỗi upload: ${response.statusCode} - ${response.body}");
    throw Exception("Upload failed");
  }
}
}