import 'package:flutter/material.dart' hide Card;
import 'package:undervoltage/domain/models/game/card.dart';
import 'package:undervoltage/domain/types/card_color.dart';

class Palette {
  static const MaterialColor primary = Colors.blue;
  static const Color transparent = Colors.transparent;
  static const Color black = Colors.black;
  static const Color white = Colors.white;
  static const Color grey = Colors.grey;
  static const Color lightGrey = Color(0xffdddddd);
  static const Color green = Colors.green;
  static const Color red = Colors.red;

  static Color fromCard(Card card) {
    if (card.color == CardColor.red) {
      return Colors.red;
    } else if (card.color == CardColor.green) {
      return Colors.green;
    } else if (card.color == CardColor.blue) {
      return Colors.blue;
    } else {
      return Colors.black;
    }
  }
}
