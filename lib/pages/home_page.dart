import 'package:flutter/material.dart';
import 'wheel_page/wheel_page.dart';
import 'events_page/events_page.dart';
import 'about_page.dart';
import '../widgets/menu_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Game Hub")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            MenuButton(
              icon: Icons.casino,
              label: "Wheel of Luck",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WheelPage()),
              ),
            ),
            MenuButton(
              icon: Icons.event,
              label: "Events",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EventsPage()),
              ),
            ),
            MenuButton(
              icon: Icons.info,
              label: "About",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutPage()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
