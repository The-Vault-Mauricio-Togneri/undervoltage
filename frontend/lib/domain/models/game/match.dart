import 'package:undervoltage/domain/json/game/json_match.dart';
import 'package:undervoltage/domain/models/game/hand.dart';
import 'package:undervoltage/domain/models/game/player.dart';
import 'package:undervoltage/domain/models/game/round.dart';
import 'package:undervoltage/domain/models/game/summary.dart';
import 'package:undervoltage/domain/models/user_logged.dart';
import 'package:undervoltage/domain/types/match_status.dart';

class Match {
  final Map<String, Player> players;
  final List<Summary> summary;
  final int roundCount;
  final Round round;
  final MatchStatus status;

  Match._({
    required this.players,
    required this.summary,
    required this.roundCount,
    required this.round,
    required this.status,
  });

  factory Match.fromJson(JsonMatch json) => Match._(
        players: json.players
            .map((key, value) => MapEntry(key, Player.fromJson(value))),
        summary: json.summary.map(Summary.fromJson).toList(),
        roundCount: json.roundCount,
        round: Round.fromJson(json.round),
        status: json.status,
      );

  int get maxPoints => players.length * 50;

  Player get self {
    for (final Player player in players.values) {
      if (player.id == LoggedUser.get.id) {
        return player;
      }
    }

    throw Exception('Self not found');
  }

  Hand hand(String playerId) => round.playersHand[playerId]!;
}
