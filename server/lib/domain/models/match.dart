import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:undervoltage/domain/json/game/json_match.dart';
import 'package:undervoltage/domain/json/messages/json_message.dart';
import 'package:undervoltage/domain/models/card.dart';
import 'package:undervoltage/domain/models/hand.dart';
import 'package:undervoltage/domain/models/player.dart';
import 'package:undervoltage/domain/models/round.dart';
import 'package:undervoltage/domain/models/summary.dart';
import 'package:undervoltage/domain/types/match_status.dart';
import 'package:undervoltage/domain/types/player_status.dart';
import 'package:undervoltage/rooms/room.dart';
import 'package:undervoltage/server/server.dart';

class Match {
  final Room room;
  final Map<String, Player> players;
  final List<Summary> summary;
  int roundCount;
  Round round;
  MatchStatus status;

  Match._({
    required this.room,
    required this.players,
    required this.summary,
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
      players: players,
      summary: [],
      roundCount: 1,
      round: Round.create(players.values.toList()),
      status: MatchStatus.playing,
    );
  }

  JsonMatch get json => JsonMatch(
        players: players.map((key, value) => MapEntry(key, value.json)),
        roundCount: roundCount,
        round: round.json,
        status: status,
        summary: summary.map((e) => e.json).toList(),
      );

  int get maxPoints => players.length * 50;

  bool get allPlayersReady {
    for (final Player player in players.values) {
      if (player.status == PlayerStatus.readingSummary) {
        return false;
      }
    }

    return true;
  }

  bool get matchFinished {
    int playersLost = 0;

    for (final Player player in players.values) {
      if (player.points >= maxPoints) {
        playersLost++;
      }
    }

    return playersLost >= (players.length - 1);
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
        final Summary summaryLine = Summary();

        for (final Player player in players.values) {
          if ((player.status == PlayerStatus.playing) &&
              round.hasHandFor(player.id)) {
            final Hand hand = round.playerHand(player.id);
            final int newPoints = player.updatePoints(hand);

            if (player.points >= maxPoints) {
              player.updateStatus(PlayerStatus.finished);
              _sendMatchData();
            } else {
              player.updateStatus(PlayerStatus.readingSummary);
            }

            summaryLine.add(player.id, newPoints);
          } else {
            summaryLine.add(player.id, player.points);
          }
        }

        summary.add(summaryLine);

        if (matchFinished) {
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
      final List<Player> playersAlive = players.values
          .where((p) => p.status == PlayerStatus.playing)
          .toList();

      status = MatchStatus.playing;
      roundCount++;
      round = Round.create(playersAlive);
    }

    _sendUpdate();
  }

  void _sendUpdate() => room.broadcast(JsonMessage.update(json));

  void update(double dt) {}

  Future _sendMatchData() async {
    final Map<String, int> playersData = {};
    final List<String> playerIds = [];

    for (final Player player in players.values) {
      playersData[player.name] = player.points;
      playerIds.add(player.id);
    }

    final Map<String, dynamic> data = {
      'matchId': room.id,
      'timestamp': DateTime.now(),
      'playersData': playersData,
      'playerIds': playerIds,
    };

    print(jsonEncode(data));

    final url = Uri.parse('');
    await http.get(url, headers: {Server.X_API_KEY_HEADER: Server.API_KEY});
  }
}
