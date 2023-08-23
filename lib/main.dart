import 'package:flutter/material.dart';

import 'my_game_screen.dart';

void main() {
  runApp(const ticTacToe());
}

class ticTacToe extends StatelessWidget {
  const ticTacToe({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const TicTacToePage(title: 'Flutter Demo Home Page'),
    );
  }
}


