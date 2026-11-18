import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SafeStorage {
  static late SharedPreferences _prefs;
  static const FlutterSecureStorage _secure = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static T getJson<T>(String key, T fallback, T Function(dynamic) parser) {
    try {
      final raw = _prefs.getString('hoja_$key');
      if (raw == null || raw.isEmpty) return fallback;
      return parser(jsonDecode(raw));
    } catch (e) {
      debugPrint('SafeStorage read error [$key]: $e');
      return fallback;
    }
  }

  static Future<bool> setJson(String key, dynamic value) async {
    try {
      return await _prefs.setString('hoja_$key', jsonEncode(value));
    } catch (e) {
      debugPrint('SafeStorage write error [$key]: $e');
      return false;
    }
  }

  static Future<void> writeSecure(String key, String value) async {
    await _secure.write(key: 'hoja_sec_$key', value: value);
  }

  static Future<String?> readSecure(String key) async {
    return await _secure.read(key: 'hoja_sec_$key');
  }

  static Future<void> deleteSecure(String key) async {
    await _secure.delete(key: 'hoja_sec_$key');
  }
}
