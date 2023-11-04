import 'package:undervoltage/domain/json/game/json_hand.dart';
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

  void removeCard(String cardId) {
    for (int i = 0; i < revealedPile.length; i++) {
      final Card card = revealedPile[i];

      if (card.id != cardId) {
        revealedPile.removeAt(i);
        break;
      }
    }
  }
}
