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

  factory Card.red(int id, int value) => Card(
        id: id.toString(),
        color: CardColor.red,
        diff: 3,
        value: value,
      );

  factory Card.green(int id, int value) => Card(
        id: id.toString(),
        color: CardColor.green,
        diff: 2,
        value: value,
      );

  factory Card.blue(int id, int value) => Card(
        id: id.toString(),
        color: CardColor.blue,
        diff: 1,
        value: value,
      );

  JsonCard get json => JsonCard(
        id: id,
        color: color,
        diff: diff,
        value: value,
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

  static List<Card> generate(int amount, Card card) {
    const List<Card> result = [];

    for (int i = 0; i < amount; i++) {
      result.add(card);
    }

    return result;
  }

  static List<Card> all() {
    int cardId = 1;

    final blue = [
      ...generate(3, Card.blue(cardId++, 1)), // 1
      ...generate(3, Card.blue(cardId++, 2)), // 2
      ...generate(3, Card.blue(cardId++, 3)), // 3
      ...generate(3, Card.blue(cardId++, 4)), // 4
      ...generate(2, Card.blue(cardId++, 5)), // 5
      ...generate(2, Card.blue(cardId++, 6)), // 6
      ...generate(2, Card.blue(cardId++, 7)), // 7
      ...generate(2, Card.blue(cardId++, 8)), // 8
      ...generate(2, Card.blue(cardId++, 9)), // 9
      ...generate(2, Card.blue(cardId++, 10)), // 10
    ];

    final green = [
      ...generate(2, Card.green(cardId++, 1)), // 1
      ...generate(2, Card.green(cardId++, 2)), // 2
      ...generate(2, Card.green(cardId++, 3)), // 3
      ...generate(2, Card.green(cardId++, 4)), // 4
      ...generate(3, Card.green(cardId++, 5)), // 5
      ...generate(3, Card.green(cardId++, 6)), // 6
      ...generate(3, Card.green(cardId++, 7)), // 7
      ...generate(3, Card.green(cardId++, 8)), // 8
      ...generate(2, Card.green(cardId++, 9)), // 9
      ...generate(2, Card.green(cardId++, 10)), // 10
    ];

    final red = [
      ...generate(3, Card.red(cardId++, 1)), // 1
      ...generate(3, Card.red(cardId++, 2)), // 2
      ...generate(3, Card.red(cardId++, 3)), // 3
      ...generate(2, Card.red(cardId++, 4)), // 4
      ...generate(2, Card.red(cardId++, 5)), // 5
      ...generate(2, Card.red(cardId++, 6)), // 6
      ...generate(2, Card.red(cardId++, 7)), // 7
      ...generate(2, Card.red(cardId++, 8)), // 8
      ...generate(3, Card.red(cardId++, 9)), // 9
      ...generate(3, Card.red(cardId++, 10)), // 10
    ];

    return [
      ...blue,
      ...green,
      ...red,
    ];
  }
}
