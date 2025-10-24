import 'package:wheel_of_luck/models/wheel_item.dart';
import 'package:wheel_of_luck/services/local_storage.dart';

const _itemsKey = 'wheel_items';

List<WheelItem> _storedElements = [
  WheelItem(symbol: '💎', content: 'Diamond', points: 10),
  WheelItem(symbol: '🔥', content: 'Fire', points: 5),
  WheelItem(symbol: '🌊', content: 'Water', points: 8),
  WheelItem(symbol: '🍀', content: 'Luck', points: 7),
  WheelItem(symbol: '⚡', content: 'Thunder', points: 6),
  WheelItem(symbol: '🌹', content: 'Rose', points: 9),
  WheelItem(symbol: '👑', content: 'Crown', points: 12),
];

List<WheelItem> getItems() => _storedElements;

Future<void> saveItems(List<WheelItem> items) async {
  await LocalStorage.saveList(_itemsKey, items);
}

Future<List<WheelItem>> loadItems() async {
  return await LocalStorage.loadList(
    _itemsKey,
    (json) => WheelItem.fromJson(json),
  );
}

Future<void> clear() async {
  LocalStorage.clear(_itemsKey);
}

Future<void> initializeWheelData() async {
  // Load from storage
  final localElements = await loadItems();

  // If first time or no saved data → use hardcoded fallback
  if (localElements.isEmpty) {
    await saveItems(_storedElements);
  } else {
    _storedElements = localElements;
  }
}
