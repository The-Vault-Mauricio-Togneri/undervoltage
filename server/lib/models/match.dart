import 'package:undervoltage/models/card.dart';
import 'package:undervoltage/models/hand.dart';
import 'package:undervoltage/models/player.dart';
import 'package:undervoltage/models/round.dart';
import 'package:undervoltage/rooms/room.dart';
import 'package:undervoltage/types/match_status.dart';

class Match {
  final String id;
  final Room room;
  final Map<String, Player> players;
  final int roundCount;
  final Round round;
  MatchStatus status;

  Match._({
    required this.id,
    required this.room,
    required this.players,
    required this.roundCount,
    required this.round,
    required this.status,
  });

  factory Match.create(Room room) {
    final Map<String, Player> players = {};

    for (final String playerId in room.players.keys) {
      players[playerId] = Player.create(playerId, room.players[playerId]!);
    }

    return Match._(
      id: room.id,
      room: room,
      status: MatchStatus.playing,
      players: players,
      roundCount: 1,
      round: Round.create(players.values.toList()),
    );
  }

  bool get playerFinished {
    for (final Hand hand in round.playersHand.values) {
      if (hand.finished) {
        return true;
      }
    }

    return false;
  }

  bool get isBlocked =>
      (round.discardPile.isNotEmpty) &&
      allPlayersBlocked(
        round.playersHand.values.toList(),
        round.lastCard,
      );

  bool allPlayersBlocked(List<Hand> hands, Card topCard) {
    for (final Hand hand in hands) {
      if (!playerBlocked(hand, topCard)) {
        return false;
      }
    }

    return hands.isNotEmpty;
  }

  bool playerBlocked(Hand hand, Card topCard) {
    if (hand.hiddenPile.isEmpty) {
      return !canPlayCards(hand.revealedPile, topCard);
    } else {
      return false;
    }
  }

  bool canPlayCards(List<Card> cards, Card topCard) {
    for (final Card card in cards) {
      if (topCard.canAccept(card)) {
        return true;
      }
    }

    return false;
  }

  void endTurn() {
    status = MatchStatus.summary;

    for (final String playerId in round.playersHand.keys) {
      final Hand hand = round.playersHand[playerId]!;
      final Player player = players[playerId]!;
      player.updatePoints(hand);
    }
  }

  void unblock() => round.unblock();

  void removeCard(String playerId, String cardId) {
    final Hand hand = round.playersHand[playerId]!;
    hand.removeCard(cardId);
  }

  void playCard(String playerId, String cardId) {
    final Card topCard = round.lastCard;
    final Hand hand = round.playersHand[playerId]!;

    for (final Card card in hand.revealedPile) {
      if (card.id == cardId) {
        if (topCard.canAccept(card)) {
          round.discardPile.add(card);
          removeCard(playerId, cardId);
        }
      }
    }
  }

  void checkStatus() {
    if (status == MatchStatus.playing) {
      if (playerFinished) {
        endTurn();
      } else if (isBlocked) {
        int limit = round.discardPile.length;

        while (isBlocked && (limit > 1)) {
          unblock();
          limit--;
        }
      }
    }
  }

  void update(double dt) {
    /*if (timeSpent.toInt() % 5 == 0) {
      for (final WebSocket socket in playerIdToWebSocket.values) {
        socket.send(JsonMessage(type: timeSpent.toString()));
      }
    }*/
  }
}
