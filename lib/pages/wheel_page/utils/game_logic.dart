import 'package:wheel_of_luck/pages/wheel_page/utils/wheel_storage.dart';

import '../../../models/player.dart';
import '../../../models/wheel_item.dart';
import 'dart:math';

class GameLogic {
  List<WheelItem> items = [];
  late List<Player> players;
  int currentPlayer = 0;

  GameLogic(String player1, String player2) {
    players = [Player(player1), Player(player2)];
    // ✅ Create a copy of defaultItems (so we don’t mutate the global list)
    items = List.from(getItems());
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
    items = List.from(getItems());
    currentPlayer = 0;
  }
}
