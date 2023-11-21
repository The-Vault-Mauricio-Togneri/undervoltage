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

  JsonCard get json => JsonCard(
        id: id,
        color: color,
        diff: diff,
        value: value,
      );

  bool canAccept(Card card) {
    final int value1 = _normalize(value + diff);
    final int value2 = _normalize(value - diff);

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

  static List<Card> generate(
    int amount,
    CardId cardId,
    CardColor color,
    int value,
  ) {
    final List<Card> result = [];

    for (int i = 0; i < amount; i++) {
      result.add(Card(
        id: cardId.next.toString(),
        color: color,
        diff: color.diff,
        value: value,
      ));
    }

    return result;
  }

  @override
  String toString() => 'ID=$id,COLOR=${color.name},DIFF=$diff,VALUE=$value';

  static List<Card> all() {
    final CardId cardId = CardId(1);

    final List<Card> blue = [
      ...generate(3, cardId, CardColor.blue, 1),
      ...generate(3, cardId, CardColor.blue, 2),
      ...generate(3, cardId, CardColor.blue, 3),
      ...generate(3, cardId, CardColor.blue, 4),
      ...generate(2, cardId, CardColor.blue, 5),
      ...generate(2, cardId, CardColor.blue, 6),
      ...generate(2, cardId, CardColor.blue, 7),
      ...generate(2, cardId, CardColor.blue, 8),
      ...generate(2, cardId, CardColor.blue, 9),
      ...generate(2, cardId, CardColor.blue, 10),
    ];

    final List<Card> green = [
      ...generate(2, cardId, CardColor.green, 1),
      ...generate(2, cardId, CardColor.green, 2),
      ...generate(2, cardId, CardColor.green, 3),
      ...generate(2, cardId, CardColor.green, 4),
      ...generate(3, cardId, CardColor.green, 5),
      ...generate(3, cardId, CardColor.green, 6),
      ...generate(3, cardId, CardColor.green, 7),
      ...generate(3, cardId, CardColor.green, 8),
      ...generate(2, cardId, CardColor.green, 9),
      ...generate(2, cardId, CardColor.green, 10),
    ];

    final List<Card> red = [
      ...generate(3, cardId, CardColor.red, 1),
      ...generate(3, cardId, CardColor.red, 2),
      ...generate(3, cardId, CardColor.red, 3),
      ...generate(2, cardId, CardColor.red, 4),
      ...generate(2, cardId, CardColor.red, 5),
      ...generate(2, cardId, CardColor.red, 6),
      ...generate(2, cardId, CardColor.red, 7),
      ...generate(2, cardId, CardColor.red, 8),
      ...generate(3, cardId, CardColor.red, 9),
      ...generate(3, cardId, CardColor.red, 10),
    ];

    return [
      ...blue,
      ...green,
      ...red,
    ];
  }
}

class CardId {
  int _current;

  CardId(this._current);

  int get next => _current++;
}
