import 'package:undervoltage/domain/json/game/json_hand.dart';
import 'package:undervoltage/domain/json/messages/json_message.dart';
import 'package:undervoltage/domain/models/card.dart';

class Hand {
  final List<Card> hiddenPile;
  final List<Card> revealedPile;
  final int faults;

  const Hand({
    required this.hiddenPile,
    required this.revealedPile,
    required this.faults,
  });

  JsonHand get json => JsonHand(
        hiddenPile: hiddenPile.map((e) => e.json).toList(),
        revealedPile: revealedPile.map((e) => e.json).toList(),
        faults: faults,
      );

  bool get finished => (hiddenPile.isEmpty) && (revealedPile.isEmpty);

  void removeCard(Card card) {
    revealedPile.remove(card);
  }

  Card cardById(String cardId) {
    for (final Card card in revealedPile) {
      if (card.id == cardId) {
        return card;
      }
    }

    throw JsonMessage.error('Card with ID $cardId not found');
  }
}
