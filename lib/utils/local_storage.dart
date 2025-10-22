import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/wheel_item.dart';

class LocalStorage {
  static const _keyItems = 'wheel_items';

  /// Save items to local storage
  static Future<void> saveItems(List<WheelItem> items) async {
    final prefs = await SharedPreferences.getInstance();

    // Convert each WheelItem to a map, then encode to JSON string
    final jsonItems =
        items.map((item) => item.toMap()).toList();

    await prefs.setString(_keyItems, jsonEncode(jsonItems));
  }


  /// Load items from local storage (returns empty list if not found)
  static Future<List<WheelItem>> loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyItems);

    if (jsonString == null) return [];

    final List decoded = jsonDecode(jsonString);
    return decoded.map((e) => WheelItem.fromMap(e)).toList();
  }

  /// Clear saved items (reset to default)
  static Future<void> clearItems() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyItems);
  }
}
