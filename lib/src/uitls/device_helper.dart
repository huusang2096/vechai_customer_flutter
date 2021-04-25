import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DeviceHelper {
  BuildContext _context;

  BuildContext get context => _context;

  DeviceHelper._privateConstructor();

  static final DeviceHelper instance = DeviceHelper._privateConstructor();

  setContext(BuildContext context) {
    _context = context;
  }

  Future<String> getId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }

  Future<String> getDeviceType() async {
    switch (Theme.of(context).platform) {
      case TargetPlatform.iOS:
        return "ios";
      case TargetPlatform.android:
        return "android";
      case TargetPlatform.fuchsia:
        return "fuchsia";
      case TargetPlatform.macOS:
        return "macOS";
    }
  }

  Future<String> getDeviceName() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.name; // unique ID on iOS
    } else {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.device; // unique ID on Android
    }
  }
}
