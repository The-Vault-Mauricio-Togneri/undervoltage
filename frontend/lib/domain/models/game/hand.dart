import 'package:undervoltage/domain/json/game/json_hand.dart';
import 'package:undervoltage/domain/models/game/card.dart';

class Hand {
  final List<Card> hiddenPile;
  final List<Card> revealedPile;
  final int faults;

  const Hand({
    required this.hiddenPile,
    required this.revealedPile,
    required this.faults,
  });

  factory Hand.fromJson(JsonHand json) => Hand(
        hiddenPile: json.hiddenPile.map(Card.fromJson).toList(),
        revealedPile: json.revealedPile.map(Card.fromJson).toList(),
        faults: json.faults,
      );

  bool get isLastCard => (hiddenPile.isEmpty) && (revealedPile.length == 1);
}
