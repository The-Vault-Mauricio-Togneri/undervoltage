import 'package:flutter/material.dart';
import 'package:undervoltage/json/json_card.dart';

class Palette {
  static const MaterialColor primary = Colors.blue;
  static const Color transparent = Colors.transparent;
  static const Color black = Colors.black;
  static const Color white = Colors.white;
  static final Color white50 = Colors.white.withAlpha(128);
  static const Color grey = Colors.grey;

  static const Color blue = Colors.blue;

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
