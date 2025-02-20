import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

enum PermissionType {
  storage,
  camera,
  photos,
}

Future<bool> checkPermission(PermissionType permissionType) async {
  bool isGranted = false;

  switch (permissionType) {
    case PermissionType.storage:
      if (Platform.isAndroid) {
        var androidInfo = await DeviceInfoPlugin().androidInfo;
        // Check Android version
        if (androidInfo.version.sdkInt >= 33) {
          // For Android 13 (API 33) and above, storage permission is implicitly granted for certain types
          isGranted =
              true; // Default true for Android 13+ (No need for any permission request)
        } else {
          // For Android below 13 (API < 33), request storage permission
          if (await Permission.storage.isDenied ||
              await Permission.storage.isPermanentlyDenied) {
            await Permission.storage.request();
          }
          isGranted = await Permission.storage.isGranted;
        }
      } else if (Platform.isIOS) {
        // iOS doesn't require storage permission for general file access
        isGranted = true;
      }
      break;

    case PermissionType.camera:
      if (await Permission.camera.isDenied ||
          await Permission.camera.isPermanentlyDenied) {
        await Permission.camera.request();
      }
      isGranted = await Permission.camera.isGranted;
      break;

    case PermissionType.photos:
      if (Platform.isIOS) {
        // iOS Photos Permission
        if (await Permission.photos.isDenied ||
            await Permission.photos.isPermanentlyDenied) {
          await Permission.photos.request();
        }
        isGranted = await Permission.photos.isGranted;
      } else if (Platform.isAndroid) {
        return true;
      }

      break;
  }

  return isGranted;
}
