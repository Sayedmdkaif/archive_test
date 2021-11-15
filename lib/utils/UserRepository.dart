import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:zacharchive_flutter/common/Strings.dart';
import 'package:zacharchive_flutter/modals/LoginModal.dart';

import 'Prefs.dart';

Future<LoginModal?> getUser() async {
  //SharedPreferences prefs = await SharedPreferences.getInstance();
  var u = Prefs.getString(
    Strings.USER,
  );
  if (u != null)
    return LoginModal.fromJson(await json.decode(u));
  else
    return null;
}

Future<void> clearPreference() async {
  // SharedPreferences prefs = await SharedPreferences.getInstance();

  var rememberEmail =
      await getPrefrenceData(defaultValue: '', key: Strings.rememberEmail);
  var rememberPassword =
      await getPrefrenceData(defaultValue: '', key: Strings.rememberPassword);

  if (rememberEmail != null)
    print('clearPrefEmail' + rememberEmail);
  else
    print('clearPrefEmail_IsNull');

  await Prefs.clear()!;

  if (rememberEmail != null) {
    print('setRememberDataKaif');

    await setPrefrenceData(data: rememberEmail, key: Strings.rememberEmail);
    await setPrefrenceData(data: rememberPassword, key: Strings.rememberPassword);
  }
}

Future<bool> saveUser(LoginModal userData) async {
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  return Prefs.setString(Strings.USER, json.encode(userData.toJson()));
}

Future<bool> setPrefrenceData({dynamic data, required String key}) async {
  // SharedPreferences prefs = await SharedPreferences.getInstance();

  if (data is bool)
    return Prefs.setBool(key, data);
  else if (data is String)
    return Prefs.setString(key, data);
  else if (data is int)
    return Prefs.setInt(key, data);
  else
    return false;
}

Future<dynamic> getPrefrenceData(
    {dynamic defaultValue, required String key}) async {
  // SharedPreferences prefs = await SharedPreferences.getInstance();

  if (defaultValue is bool)
    return Prefs.getBool(key);
  else if (defaultValue is String)
    return Prefs.getString(key);
  else if (defaultValue is int)
    return Prefs.getInt(key);
  else
    return false;
}

Future<bool> removPrefrenceData({required String key}) async {
  //SharedPreferences prefs = await SharedPreferences.getInstance();

  return Prefs.remove(key)!;
}
