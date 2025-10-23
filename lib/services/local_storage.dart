import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wheel_of_luck/models/Item.dart';

class LocalStorage {
  /// Save any list of serializable objects
  static Future<void> saveList<T extends Item>(
    String key,
    List<T> items,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(items.map((e) => e.toJson()).toList());
    await prefs.setString(key, encoded);
  }

  /// Load a list of objects with a provided `fromJson` factory
  static Future<List<T>> loadList<T extends Item>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(key);
    if (data == null) return [];

    final decoded = jsonDecode(data) as List;
    return decoded.map((e) => fromJson(Map<String, dynamic>.from(e))).toList();
  }

  /// Clear a specific key
  static Future<void> clear(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
