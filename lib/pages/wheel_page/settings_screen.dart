import 'package:flutter/material.dart';
import 'package:wheel_of_luck/pages/wheel_page/utils/wheel_storage.dart';
import '../../models/player.dart';
import '../../models/wheel_item.dart';

class SettingsScreen extends StatefulWidget {
  final List<Player> players;
  final List<WheelItem> items;

  const SettingsScreen({super.key, required this.players, required this.items});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late List<Player> players;
  late List<WheelItem> items;

  @override
  void initState() {
    super.initState();
    players = widget.players
        .map((p) => Player(p.name)..points = p.points)
        .toList();
    items = widget.items
        .map(
          (i) =>
              WheelItem(symbol: i.symbol, content: i.content, points: i.points),
        )
        .toList();
  }

  void _addItem() {
    setState(() {
      items.add(WheelItem(symbol: '✨', content: 'New', points: 0));
    });
  }

  void _deleteItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  void _save() async {
    // ✅ Update global list used by GameLogic
    getItems()
      ..clear()
      ..addAll(items);

    // Persist changes
    await saveItems(getItems());

    // ✅ Return data to game screen
    Navigator.pop(context, {'players': players, 'items': items});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade900,
      appBar: AppBar(
        title: const Text(
          "Game Settings",
          style: TextStyle(
            // fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.deepPurpleAccent,
        actions: [
          IconButton(onPressed: _save, icon: const Icon(Icons.check)),
          const SizedBox(width: 5),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Players",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Player name fields
            ...players.asMap().entries.map((entry) {
              final i = entry.key;
              final player = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: TextField(
                  controller: TextEditingController(text: player.name),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Player ${i + 1}",
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white10,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (v) => players[i].name = v,
                ),
              );
            }),

            const SizedBox(height: 20),
            const Divider(color: Colors.white38),
            const Text(
              "Wheel Items",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Wheel items list
            ...items.asMap().entries.map((entry) {
              final i = entry.key;
              final item = entry.value;
              return Card(
                color: Colors.deepPurple.shade700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: TextField(
                          controller: TextEditingController(text: item.symbol),
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: "Symbol",
                            labelStyle: TextStyle(color: Colors.white70),
                          ),
                          onChanged: (v) => item.symbol = v,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: TextEditingController(text: item.content),
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: "Content",
                            labelStyle: TextStyle(color: Colors.white70),
                          ),
                          onChanged: (v) => item.content = v,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 1,
                        child: TextField(
                          controller: TextEditingController(
                            text: item.points.toString(),
                          ),
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Points",
                            labelStyle: TextStyle(color: Colors.white70),
                          ),
                          onChanged: (v) => item.points = int.tryParse(v) ?? 0,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => _deleteItem(i),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),

            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _addItem,
              icon: const Icon(Icons.add),
              label: const Text("Add New Item"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
