import 'package:undervoltage/models/card.dart';

class Hand {
  final List<Card> hiddenPile;
  final List<Card> revealedPile;
  final int faults;

  const Hand({
    required this.hiddenPile,
    required this.revealedPile,
    required this.faults,
  });

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
