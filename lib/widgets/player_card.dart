import 'package:flutter/material.dart';
import '../models/player.dart';

class PlayerCard extends StatelessWidget {
  final Player player;
  final bool isActive;

  const PlayerCard({super.key, required this.player, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isActive
              ? [Colors.greenAccent, Colors.teal]
              : [Colors.blueGrey.shade800, Colors.black87],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (isActive)
            const BoxShadow(
              color: Colors.greenAccent,
              blurRadius: 15,
              spreadRadius: 2,
            ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Text(
            player.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
              shadows: [
                Shadow(color: Colors.black, blurRadius: 4),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${player.points} pts',
            style: const TextStyle(
              color: Colors.amber,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
