import 'package:flutter/material.dart';

import '../controllers/mainController.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        body: Center(
          child: PokemonList(),
        ),
      ),
    );
  }
}