import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("About")),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          "🎯 EMAM Hub\n\n"
          "Developed by Mohamed Ashraf Hamza (EMAM)\n"
          "License: MIT\n"
          "Version: 2.0.1\n\n"
          "A creative collection of fun and tools by EMAM.",

          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
