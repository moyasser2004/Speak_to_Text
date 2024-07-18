import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {

  static Future<bool> _checkPermission(Permission permission) async {
    PermissionStatus status = await permission.status;
    if (status.isDenied) {
      status = await permission.request();
      if (status.isGranted) {
        return true;
      } else {
        return false;
      }
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
      if (status.isGranted) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  static Future<bool> checkLocations() async =>
      _checkPermission(Permission.location);

  static Future<bool> checkNotification() async =>
      _checkPermission(Permission.notification);

}
