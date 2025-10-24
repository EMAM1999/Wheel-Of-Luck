import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wheel_of_luck/pages/events_page/utils/events_storage.dart';
import 'package:wheel_of_luck/pages/wheel_page/utils/wheel_storage.dart';
import 'pages/home_page.dart';

void main() async {
  // Load or initialize defaultItems before app runs
  await initializeEventsData();
  await initializeWheelData();
  // await GameLogic.initializeDefaults();

  // Lock orientation to portrait only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown, // optional (for upside-down portrait)
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EMAM Hub',
      theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
      home: const HomePage(),
    );
  }
}
