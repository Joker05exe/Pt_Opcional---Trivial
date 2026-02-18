import 'package:flutter/material.dart';
import 'screens/game_screen.dart';

void main() {
  runApp(const PtTrivialApp());
}

class PtTrivialApp extends StatelessWidget {
  const PtTrivialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pt_Trivial',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'Roboto', // Opcional
      ),
      home: const GameScreen(),
    );
  }
}