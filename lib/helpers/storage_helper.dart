import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

Future<void> setStorageStringItem(String key, String value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
}

Future<void> setStorageJsonItem(
    String key, Map<String, dynamic> jsonObject) async {
  final prefs = await SharedPreferences.getInstance();
  String jsonString =
      jsonEncode(jsonObject); // Encode the JSON object to a string
  await prefs.setString(key, jsonString);
}

Future<String?> getStorageStringItem(String key) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

Future<Map<String, dynamic>?> getStorageJsonItem(String key) async {
  final prefs = await SharedPreferences.getInstance();
  String? jsonString = prefs.getString(key);

  if (jsonString != null) {
    return jsonDecode(jsonString)
        as Map<String, dynamic>; // Decode the string back to a JSON object
  }
  return null; // Return null if the key doesn't exist
}
