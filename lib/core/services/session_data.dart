import 'package:revive_flutter_project/core/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionData {

  static Future<void> init() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String token = _prefs.getString('token') ?? '';
    ApiService.authorizeHeader(token);
  }

  static Future<void> setToken(String token) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString('token', token);
  }

  static Future<String> token() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String token = _prefs.getString('token') ?? '';
    return token;
  }

  static Future<void> logout() async {
    await setToken('');
    ApiService.unauthorizeHeader();
  }
}