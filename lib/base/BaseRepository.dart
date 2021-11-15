import 'dart:io';


import 'package:device_info/device_info.dart';
import 'package:intl/intl.dart';

import 'network/ApiHitter.dart';

class BaseRepository {
  final apiHitter = ApiHitter();
  final dio = ApiHitter.getDio();

  getCurrentTimeString() {
    final now = new DateTime.now();
    final formatter = new DateFormat('yyyy-MM-dd H:m:s');
    return formatter.format(now);
  }

  String getUtcTime() {
    return DateTime.now().toUtc().toString();
  }

  Future<String> getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }

  String getdevice() {
    if (Platform.isIOS)
      return "ios";
    else
      return "android";
  }
}
