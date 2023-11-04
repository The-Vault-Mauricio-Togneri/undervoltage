import 'dart:math';
import 'package:undervoltage/domain/models/card.dart';
import 'package:undervoltage/domain/models/hand.dart';
import 'package:undervoltage/domain/models/player.dart';

class Round {
  final List<Card> discardPile;
  final Map<String, Hand> playersHand;

  const Round({
    required this.discardPile,
    required this.playersHand,
  });

  factory Round.create(List<Player> players) {
    final List<Card> cards = Card.all();
    cards.shuffle(Random());

    final Card firstCard = cards.removeAt(0);

    final Map<String, Hand> hands = {};

    for (final Player player in players) {
      hands[player.id] = const Hand(
        hiddenPile: [],
        revealedPile: [],
        faults: 0,
      );
    }

    while (cards.length >= players.length) {
      for (final Player player in players) {
        final Hand hand = hands[player.id]!;
        final Card card = cards.removeAt(0);

        if (hand.revealedPile.length < 3) {
          hand.revealedPile.add(card);
        } else {
          hand.hiddenPile.add(card);
        }
      }
    }

    return Round(
      discardPile: [firstCard],
      playersHand: hands,
    );
  }

  Card get lastCard => discardPile[discardPile.length - 1];

  void unblock() {
    if (discardPile.isNotEmpty) {
      final Card first = discardPile.removeAt(0);
      discardPile.add(first);
    }
  }
}
