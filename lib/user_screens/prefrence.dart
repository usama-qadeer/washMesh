import 'package:shared_preferences/shared_preferences.dart';

class MyPrefferences {
  static SharedPreferences? _preferences;
  static const boolkey = "boolkey";
  static init() async {
    _preferences = await SharedPreferences.getInstance();
    return _preferences;
  }

  static Future saveBool(bool a) {
    return _preferences!.setBool("boolkey", a);
  }

  static bool fetechBool() => _preferences!.getBool("boolkey") ?? false;
}
