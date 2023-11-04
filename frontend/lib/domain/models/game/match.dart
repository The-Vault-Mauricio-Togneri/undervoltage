import 'package:undervoltage/domain/json/game/json_match.dart';
import 'package:undervoltage/domain/models/game/hand.dart';
import 'package:undervoltage/domain/models/game/player.dart';
import 'package:undervoltage/domain/models/game/round.dart';
import 'package:undervoltage/domain/types/match_status.dart';

class Match {
  final String id;
  final Map<String, Player> players;
  final int roundCount;
  final Round round;
  MatchStatus status;

  Match._({
    required this.id,
    required this.players,
    required this.roundCount,
    required this.round,
    required this.status,
  });

  factory Match.fromJson(JsonMatch json) => Match._(
        id: json.id,
        players: json.players
            .map((key, value) => MapEntry(key, Player.fromJson(value))),
        roundCount: json.roundCount,
        round: Round.fromJson(json.round),
        status: json.status,
      );

  Hand hand(String playerId) => round.playersHand[playerId]!;
}
