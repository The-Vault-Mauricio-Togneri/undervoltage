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
}
