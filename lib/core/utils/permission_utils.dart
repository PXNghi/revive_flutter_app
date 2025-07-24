import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  static Future<bool> requestLocationPermission() async {
    final status = await Permission.location.status;

    if (status.isGranted) return true;

    final result = await Permission.location.request();

    if (result.isGranted) return true;

    if (result.isPermanentlyDenied) {
      await openAppSettings();
    }

    return false;
  }
}
