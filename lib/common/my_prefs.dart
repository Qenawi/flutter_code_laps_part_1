import 'package:flutter_code_laps_part_1/data/login_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _Prefs {
  static final ftoken = "FireBaseToken";
  static final funame = "funame";
  static final fisLoggedIn = "islogged";
  static final fphone = "fphone";
  static final ffullname = "ffullname";
  static final fjop_titile = "fjop_titile";
}

cacheLogin(LoginResponse data) {
  save(_Prefs.fisLoggedIn, true);
  save(_Prefs.ffullname, data.full_name);
  save(_Prefs.fphone, data.phone);
  save(_Prefs.funame, data.uname);
  save(_Prefs.fjop_titile, data.joptitle);
}
clearCache() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool(_Prefs.fisLoggedIn, false);
  prefs.setString(_Prefs.ffullname, "");
  prefs.setString(_Prefs.fphone, "");
  prefs.setString(_Prefs.funame, "");
  prefs.setString(_Prefs.fjop_titile, "");
}
save(String key, dynamic value) async {
  final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
  if (value is bool) {
    sharedPrefs.setBool(key, value);
  } else if (value is String) {
    sharedPrefs.setString(key, value);
  } else if (value is int) {
    sharedPrefs.setInt(key, value);
  } else if (value is double) {
    sharedPrefs.setDouble(key, value);
  } else if (value is List<String>) {
    sharedPrefs.setStringList(key, value);
  }
}
Future<LoginResponse> getCacheLogin() async
{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var name = prefs.getString(_Prefs.ffullname) ?? "";
  var phone = prefs.getString(_Prefs.fphone) ?? "";
  var uname = prefs.getString(_Prefs.funame) ?? "";
  var joptitile = prefs.getString(_Prefs.fjop_titile) ?? "";
  return LoginResponse(uname, name, phone, joptitile);
}

Future<String> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString(_Prefs.ftoken) ?? "";
  return token;
}

Future<bool> isLogged() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var res = prefs.getBool(_Prefs.fisLoggedIn) ?? false;
  return res;
}
