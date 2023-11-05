import 'package:undervoltage/domain/json/game/json_match.dart';
import 'package:undervoltage/domain/json/messages/json_message.dart';
import 'package:undervoltage/domain/models/card.dart';
import 'package:undervoltage/domain/models/hand.dart';
import 'package:undervoltage/domain/models/player.dart';
import 'package:undervoltage/domain/models/round.dart';
import 'package:undervoltage/domain/types/match_status.dart';
import 'package:undervoltage/domain/types/player_status.dart';
import 'package:undervoltage/rooms/room.dart';

class Match {
  final String id;
  final Room room;
  final Map<String, Player> players;
  int roundCount;
  Round round;
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

  bool get allPlayersReady {
    for (final Player player in players.values) {
      if (player.status != PlayerStatus.playing) {
        return false;
      }
    }

    return true;
  }

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
          player.updateStatus(PlayerStatus.readingSummary);
        }
      } else if (round.isBlocked) {
        round.unblock();
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

  void summaryAccepted(String playerId) {
    players[playerId]?.updateStatus(PlayerStatus.playing);

    if (allPlayersReady) {
      roundCount++;
      round = Round.create(players.values.toList());
    }
  }

  void _sendUpdate() => room.broadcast(JsonMessage.update(json));

  void update(double dt) {}
}
