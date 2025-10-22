import '../models/player.dart';
import '../models/wheel_item.dart';
import '../utils/local_storage.dart';
import 'dart:math';

List<WheelItem> defaultItems = [];

class GameLogic {
  List<WheelItem> items = [];
  late List<Player> players;
  int currentPlayer = 0;

  static Future<void> initializeDefaults() async {
    // Load from storage
    final storedItems = await LocalStorage.loadItems();

    // If first time or no saved data → use hardcoded fallback
    if (storedItems.isEmpty) {
      defaultItems = [
        WheelItem(symbol: '💎', content: 'Diamond', points: 10),
        WheelItem(symbol: '🔥', content: 'Fire', points: 5),
        WheelItem(symbol: '🌊', content: 'Water', points: 8),
        WheelItem(symbol: '🍀', content: 'Luck', points: 7),
        WheelItem(symbol: '⚡', content: 'Thunder', points: 6),
        WheelItem(symbol: '🌹', content: 'Rose', points: 9),
        WheelItem(symbol: '👑', content: 'Crown', points: 12),
      ];
      await LocalStorage.saveItems(defaultItems);
    } else {
      defaultItems = storedItems;
    }
  }

  GameLogic(String player1, String player2) {
    players = [Player(player1), Player(player2)];
    // ✅ Create a copy of defaultItems (so we don’t mutate the global list)
    items = List.from(defaultItems);
  }

  WheelItem spinWheel() {
    final random = Random();
    final index = random.nextInt(items.length);
    return items[index];
  }

  void accept(WheelItem item) {
    players[currentPlayer].points += item.points;
    items.remove(item);
    nextTurn();
  }

  void reject(WheelItem item) {
    final other = (currentPlayer + 1) % players.length;
    players[other].points += item.points;
    nextTurn();
  }

  void nextTurn() {
    currentPlayer = (currentPlayer + 1) % players.length;
  }

  void restart() {
    for (var p in players) {
      p.points = 0;
    }
    // ✅ Re-copy default items instead of reusing reference
    items = List.from(defaultItems);
    currentPlayer = 0;
  }
}
