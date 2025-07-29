import 'package:revive_flutter_project/core/services/api_services.dart';
import 'package:revive_flutter_project/features/person/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionData {
  static User? _mine;
  static Address? _currentUserAddress;

  static User? get mine => _mine;
  static Address? get currentUserAddress => _currentUserAddress;

  static Future<void> init() async {
    
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

  static Future<void> login(String token, Map<String, dynamic> data) async {
    final User myInformation = User.fromJson(data);
    _mine = myInformation;
    print("my profile: $myInformation");
    ApiService.authorizeHeader(token);
    await setToken(token);
  }

  static Future<void> updateAddress(Address address) async {
    _currentUserAddress = address;
  }
}