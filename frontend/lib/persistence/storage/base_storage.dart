import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static Future<bool> contains(String field) async {
    final SharedPreferences preferences = await _preferences();

    return preferences.containsKey(field);
  }

  static Future<bool> getBool(String field, bool defaultValue) async {
    final SharedPreferences preferences = await _preferences();

    return preferences.getBool(field) ?? defaultValue;
  }

  static Future<int> getInt(String field, int defaultValue) async {
    final SharedPreferences preferences = await _preferences();

    return preferences.getInt(field) ?? defaultValue;
  }

  static Future<String> getString(String field, String defaultValue) async {
    final SharedPreferences preferences = await _preferences();

    return preferences.getString(field) ?? defaultValue;
  }

  static Future<List<String>> getStringList(
      String field, List<String> defaultValue) async {
    final SharedPreferences preferences = await _preferences();

    return preferences.getStringList(field) ?? defaultValue;
  }

  static Future setBool(String field, bool value) async {
    final SharedPreferences preferences = await _preferences();
    preferences.setBool(field, value);
  }

  static Future setInt(String field, int value) async {
    final SharedPreferences preferences = await _preferences();
    preferences.setInt(field, value);
  }

  static Future setString(String field, String value) async {
    final SharedPreferences preferences = await _preferences();
    preferences.setString(field, value);
  }

  static Future setStringList(String field, List<String> value) async {
    final SharedPreferences preferences = await _preferences();
    preferences.setStringList(field, value);
  }

  static Future clear(String field) async {
    final SharedPreferences preferences = await _preferences();
    preferences.remove(field);
  }

  static Future<SharedPreferences> _preferences() async =>
      SharedPreferences.getInstance();
}
