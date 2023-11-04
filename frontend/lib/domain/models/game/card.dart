import 'package:undervoltage/domain/json/game/json_card.dart';
import 'package:undervoltage/domain/types/card_color.dart';

class Card {
  final String id;
  final CardColor color;
  final int diff;
  final int value;

  const Card({
    required this.id,
    required this.color,
    required this.diff,
    required this.value,
  });

  factory Card.fromJson(JsonCard json) => Card(
        id: json.id,
        color: json.color,
        diff: json.diff,
        value: json.value,
      );

  bool canAccept(Card card) {
    final value1 = _normalize(value + diff);
    final value2 = _normalize(value - diff);

    return (card.value == value1) || (card.value == value2);
  }

  int _normalize(int value) {
    if (value > 10) {
      return value - 10;
    } else if (value < 1) {
      return value + 10;
    } else {
      return value;
    }
  }
}
