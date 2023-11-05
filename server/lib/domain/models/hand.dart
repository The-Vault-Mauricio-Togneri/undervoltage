import 'package:undervoltage/domain/json/game/json_hand.dart';
import 'package:undervoltage/domain/json/messages/json_message.dart';
import 'package:undervoltage/domain/models/card.dart';

class Hand {
  final List<Card> hiddenPile;
  final List<Card> revealedPile;
  int faults;

  Hand({
    required this.hiddenPile,
    required this.revealedPile,
    required this.faults,
  });

  JsonHand get json => JsonHand(
        hiddenPile: hiddenPile.map((e) => e.json).toList(),
        revealedPile: revealedPile.map((e) => e.json).toList(),
        faults: faults,
      );

  // bool get finished => (hiddenPile.isEmpty) && (revealedPile.isEmpty);

  int get revealedSize => revealedPile.length;

  void discardCard() {
    if (hiddenPile.isNotEmpty) {
      final Card card = hiddenPile.removeAt(hiddenPile.length - 1);
      revealedPile.add(card);
    }
  }

  void increaseFaults() {
    faults++;
  }

  void addHidden(Card card) => hiddenPile.add(card);

  void addRevealed(Card card) => revealedPile.add(card);

  void removeCard(Card card) => revealedPile.remove(card);

  Card cardById(String cardId) {
    for (final Card card in revealedPile) {
      if (card.id == cardId) {
        return card;
      }
    }

    throw JsonMessage.error('Card with ID $cardId not found');
  }
}
