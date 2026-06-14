import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../widget/notifications/app_notification.dart';

Future<void> requestMultiplePermission(BuildContext context) async {
  await [
    Permission.storage,
    // Permission.camera,
    Permission.notification,
  ].request();
}

Future<bool> requestPermissionCamera(BuildContext context) async {
  if (Platform.isAndroid) {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    if (androidInfo.version.sdkInt <= 32) {
      var status = await Permission.camera.request();
      if (!status.isGranted) {
        if (context.mounted) {
          AppNotification.error(
            context,
            'Por favor, concede permisos de acceso a la cámara',
          );
        }
        return false;
      }
      return true;
    } else {
      var status = await Permission.camera.request();
      if (!status.isGranted) {
        if (context.mounted) {
          AppNotification.error(
            context,
            'Por favor, concede permisos de acceso a la cámara',
          );
        }
        return false;
      }
      return true;
    }
  } else {
    return true;
  }
}

Future<bool> requestPermissionStorage(BuildContext context) async {
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    if (await Permission.storage.request().isGranted) {
      return true;
    } else {
      if (context.mounted) {
        AppNotification.error(
          context,
          'Por favor, concede permisos de acceso al almacenamiento',
        );
      }
      return false;
    }
  }
  return true;
}

Future<bool> requestPermissionLocation(BuildContext context) async {
  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }

  if (permission == LocationPermission.deniedForever) {
    if (context.mounted) {
      AppNotification.error(
        context,
        'Debe permitir el acceso a la ubicación',
      );
    }
    await Geolocator.openAppSettings();
    return false;
  }

  // Android: exigir "Permitir siempre" (ACCESS_BACKGROUND_LOCATION)
  // if (Platform.isAndroid && permission == LocationPermission.whileInUse) {
  //   if (context.mounted) {
  //     await DialogBackgroundLocation.show(context);
  //   }
  //   return false;
  // }

  return permission == LocationPermission.always;
}

Future<bool> requestPermissionNotification(BuildContext context) async {
  if (Platform.isAndroid) {
    final androidInfo = await DeviceInfoPlugin().androidInfo;

    if (androidInfo.version.sdkInt >= 33) {
      var status = await Permission.notification.status;

      if (!status.isGranted) {
        status = await Permission.notification.request();
      }

      if (!status.isGranted) {
        if (context.mounted) {
          AppNotification.error(
            context,
            'Por favor, concede permisos de notificación',
          );
        }
        return false;
      }
    }
    return true;
  } else if (Platform.isIOS) {
    return true;
  } else {
    return true;
  }
}
