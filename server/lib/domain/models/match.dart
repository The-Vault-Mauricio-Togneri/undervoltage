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
  final Room room;
  final Map<String, Player> players;
  int roundCount;
  Round round;
  MatchStatus status;

  Match._({
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
      room: room,
      status: MatchStatus.playing,
      players: players,
      roundCount: 1,
      round: Round.create(players.values.toList()),
    );
  }

  JsonMatch get json => JsonMatch(
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

  bool get playerLost {
    for (final Player player in players.values) {
      if (player.points >= 100) {
        return true;
      }
    }

    return false;
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
        for (final Player player in players.values) {
          final Hand hand = round.playerHand(player.id);
          player.updatePoints(hand);
          player.updateStatus(PlayerStatus.readingSummary);
        }

        if (playerLost) {
          status = MatchStatus.finished;
        } else {
          status = MatchStatus.summary;
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
      status = MatchStatus.playing;
      roundCount++;
      round = Round.create(players.values.toList());
    }

    _sendUpdate();
  }

  void _sendUpdate() => room.broadcast(JsonMessage.update(json));

  void update(double dt) {}
}
