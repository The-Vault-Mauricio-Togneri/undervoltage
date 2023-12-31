import 'dart:math';
import 'package:undervoltage/domain/json/game/json_round.dart';
import 'package:undervoltage/domain/models/card.dart';
import 'package:undervoltage/domain/models/hand.dart';
import 'package:undervoltage/domain/models/player.dart';
import 'package:undervoltage/utils/logger.dart';

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
      final List<Card> hiddenPile = [];
      final List<Card> revealedPile = [];

      hands[player.id] = Hand(
        hiddenPile: hiddenPile,
        revealedPile: revealedPile,
        faults: 0,
      );
    }

    while (cards.length >= players.length) {
      for (final Player player in players) {
        final Hand hand = hands[player.id]!;
        final Card card = cards.removeAt(0);

        if (hand.revealedSize < 3) {
          hand.addRevealed(card);
        } else {
          hand.addHidden(card);
        }
      }
    }

    return Round(
      discardPile: [firstCard],
      playersHand: hands,
    );
  }

  JsonRound get json => JsonRound(
        discardPile: discardPile.map((e) => e.json).toList(),
        playersHand: playersHand.map((key, value) => MapEntry(key, value.json)),
      );

  Card get topCard => discardPile.last;

  void addCard(Card card) => discardPile.add(card);

  Hand playerHand(String playerId) => playersHand[playerId]!;

  bool hasHandFor(String playerId) => playersHand.containsKey(playerId);

  bool get isBlocked => discardPile.isNotEmpty && _allPlayersBlocked(topCard);

  bool _allPlayersBlocked(Card topCard) {
    for (final Hand hand in playersHand.values) {
      if (!hand.isBlocked(topCard)) {
        return false;
      }
    }

    return playersHand.isNotEmpty;
  }

  void unblock() {
    int limit = discardPile.length;

    while (isBlocked && (limit > 0)) {
      final Card bottom = discardPile.removeAt(0);
      discardPile.add(bottom);
      Logger.info('Moved card: $bottom to top of discard pile');
      limit--;
    }

    Logger.info('Round no longer blocked');
  }
}
