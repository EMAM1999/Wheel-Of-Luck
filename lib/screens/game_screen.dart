import 'package:flutter/material.dart';
import '../utils/game_logic.dart';
import '../widgets/player_card.dart';
import '../widgets/decorated_wheel.dart';
import '../screens/settings_screen.dart';
import '../models/player.dart';
import '../models/wheel_item.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameLogic game;
  bool showOverlay = false;

  @override
  void initState() {
    super.initState();
    game = GameLogic("Medo", "DonDon");
  }

  void onResult(result) {
    setState(() => showOverlay = true);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black87,
        title: Text(
          '${result.symbol} (${result.points} pts)',
          style: TextStyle(color: Colors.amber),
        ),
        content: Text(
          '${result.content}',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              game.accept(result);
              Navigator.pop(context);
              setState(() => showOverlay = false);
            },
            child: const Text('Accept', style: TextStyle(color: Colors.green)),
          ),
          TextButton(
            onPressed: () {
              game.reject(result);
              Navigator.pop(context);
              setState(() => showOverlay = false);
            },
            child: const Text('Reject', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "🎡 Wheel Of Luck 🎡",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
            shadows: [Shadow(color: Colors.black, blurRadius: 2)],
          ),
        ),
        backgroundColor: Colors.deepPurpleAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SettingsScreen(
                    players: game.players,
                    items: defaultItems,
                  ),
                ),
              );

              if (result != null) {
                setState(() {
                  game.players = List<Player>.from(result['players']);
                  game.items = List<WheelItem>.from(result['items']);
                });
              }
            },
          ),
          const SizedBox(width: 5),
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              showAboutDialog(
                context: context,
                applicationName: 'Wheel of Luck',
                applicationVersion: '1.0.1',
                applicationLegalese:
                    '© 2025 Eng.Mohamed Ashraf (EMAM)\nLicensed under the MIT License.\nVisit: github.com/EMAM1999',
              );
            },
          ),
          const SizedBox(width: 5),
        ],
      ),

      backgroundColor: Colors.deepPurple.shade900,
      body: Stack(
        children: [
          Column(
            children: [
              // Top Player Cards (fixed)
              Container(
                color: Colors.black45,
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: game.players.asMap().entries.map((entry) {
                    final i = entry.key;
                    final player = entry.value;
                    return PlayerCard(
                      player: player,
                      isActive: i == game.currentPlayer,
                    );
                  }).toList(),
                ),
              ),
              // const SizedBox(height: 20),
              // Wheel
              Expanded(
                child: Center(
                  child: DecoratedWheel(items: game.items, onResult: onResult),
                ),
              ),
              // const SizedBox(height: 20),
              // 🔄 Reset button
              ElevatedButton.icon(
                icon: const Icon(
                  Icons.restart_alt_rounded,
                  color: Colors.white,
                ),
                label: const Text(
                  "Restart Game",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 8,
                  shadowColor: Colors.amberAccent,
                ),
                onPressed: () {
                  setState(() {
                    game.restart();
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
