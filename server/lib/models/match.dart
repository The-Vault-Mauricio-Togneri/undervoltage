import 'package:undervoltage/models/player.dart';
import 'package:undervoltage/models/round.dart';
import 'package:undervoltage/rooms/room.dart';
import 'package:undervoltage/types/match_status.dart';
import 'package:undervoltage/types/player_status.dart';

class Match {
  final String id;
  final Room room;
  final MatchStatus status;
  final Map<String, Player> players;
  final int roundCount;
  final Round round;

  const Match._({
    required this.id,
    required this.room,
    required this.status,
    required this.players,
    required this.roundCount,
    required this.round,
  });

  factory Match.create(Room room) {
    final Map<String, Player> players = {};

    for (final String playerId in room.players.keys) {
      players[playerId] = Player(
        id: playerId,
        name: room.players[playerId]!,
        points: 0,
        status: PlayerStatus.playing,
      );
    }

    return Match._(
      id: room.id,
      room: room,
      status: MatchStatus.playing,
      players: players,
      roundCount: 1,
      round: Round.create(),
    );
  }

  void update(double dt) {
    /*if (timeSpent.toInt() % 5 == 0) {
      for (final WebSocket socket in playerIdToWebSocket.values) {
        socket.send(JsonMessage(type: timeSpent.toString()));
      }
    }*/
  }
}
