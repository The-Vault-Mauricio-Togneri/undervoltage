import 'package:undervoltage/domain/json/game/json_match.dart';
import 'package:undervoltage/domain/json/messages/json_message.dart';
import 'package:undervoltage/domain/models/card.dart';
import 'package:undervoltage/domain/models/hand.dart';
import 'package:undervoltage/domain/models/player.dart';
import 'package:undervoltage/domain/models/round.dart';
import 'package:undervoltage/domain/types/match_status.dart';
import 'package:undervoltage/rooms/room.dart';

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

  JsonMatch get json => JsonMatch(
        id: id,
        players: players.map((key, value) => MapEntry(key, value.json)),
        roundCount: roundCount,
        round: round.json,
        status: status,
      );

  void playCard({
    required String cardId,
    required String playerId,
  }) {
    final Hand hand = round.playerHand(playerId);
    final Card selectedCard = hand.cardById(cardId);

    if (round.topCard.canAccept(selectedCard) || hand.isLastCard) {
      round.addCard(selectedCard);
      hand.removeCard(selectedCard);

      if (hand.finished) {
        status = MatchStatus.summary;

        for (final Player player in players.values) {
          final Hand hand = round.playerHand(playerId);
          player.updatePoints(hand);
        }
      } else {
        // TODO(momo): check if blocked
      }

      _sendUpdate();
    }
  }

  void discardCard(String playerId) {
    final Hand hand = round.playerHand(playerId);
    hand.discardCard();
    _sendUpdate();
  }

  void increaseFault(String playerId) {
    final Hand hand = round.playerHand(playerId);
    hand.increaseFaults();
    _sendUpdate();
  }

  void summaryAccepted(String playerId) => players[playerId]?.summaryAccepted();

  /*bool get isBlocked =>
      (round.discardPile.isNotEmpty) &&
      allPlayersBlocked(
        round.playersHand.values.toList(),
        round.lastCard,
      );*/

  /*bool allPlayersBlocked(List<Hand> hands, Card topCard) {
    for (final Hand hand in hands) {
      if (!playerBlocked(hand, topCard)) {
        return false;
      }
    }

    return hands.isNotEmpty;
  }*/

  /*bool playerBlocked(Hand hand, Card topCard) {
    if (hand.hiddenPile.isEmpty) {
      return !canPlayCards(hand.revealedPile, topCard);
    } else {
      return false;
    }
  }*/

  /*bool canPlayCards(List<Card> cards, Card topCard) {
    for (final Card card in cards) {
      if (topCard.canAccept(card)) {
        return true;
      }
    }

    return false;
  }*/

  //void unblock() => round.unblock();

  /*void checkStatus() {
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
  }*/

  void _sendUpdate() => room.broadcast(JsonMessage.update(json));

  void update(double dt) {}
}
