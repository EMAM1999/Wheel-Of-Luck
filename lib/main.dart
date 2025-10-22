import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:wheel_of_luck/utils/game_logic.dart';
import 'screens/game_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load or initialize defaultItems before app runs
  await GameLogic.initializeDefaults();

  // Lock orientation to portrait only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown, // optional (for upside-down portrait)
  ]);

  runApp(const WheelOfLuckApp());
}

class WheelOfLuckApp extends StatelessWidget {
  const WheelOfLuckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameScreen(),
    );
  }
}
