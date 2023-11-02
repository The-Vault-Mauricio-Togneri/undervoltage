import 'package:undervoltage/models/card.dart';
import 'package:undervoltage/models/hand.dart';

class Round {
  final List<Card> discardPile;
  final Map<String, Hand> playersHand;

  const Round._({
    required this.discardPile,
    required this.playersHand,
  });

  factory Round.create() {
    // TODO(momo): implement
    return const Round._(
      discardPile: [],
      playersHand: {},
    );
  }
}
