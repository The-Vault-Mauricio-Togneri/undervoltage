import 'package:flutter/material.dart';

class Palette {
  static const MaterialColor primary = Colors.blue;
  static const Color transparent = Colors.transparent;
  static const Color black = Colors.black;
  static const Color white = Colors.white;
  static const Color grey = Colors.grey;
  static const Color green = Colors.green;
  static const Color red = Colors.red;

  static Color fromCard(JsonCard card) {
    if (card.color == 'red') {
      return Colors.red;
    } else if (card.color == 'green') {
      return Colors.green;
    } else if (card.color == 'blue') {
      return Colors.blue;
    } else {
      return Colors.black;
    }
  }
}
