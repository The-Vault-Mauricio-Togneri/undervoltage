import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:undervoltage/json/json_player.dart';
import 'package:undervoltage/json/json_round.dart';
import 'package:undervoltage/types/match_status.dart';

part 'json_match.g.dart';

@JsonSerializable()
class JsonMatch {
  final String id;
  final int numberOfPlayers;
  final int maxPoints;
  final MatchStatus status;
  final Map<String, JsonPlayer> players;
  final int roundCount;
  final JsonRound round;

  const JsonMatch({
    required this.id,
    required this.numberOfPlayers,
    required this.maxPoints,
    required this.status,
    required this.players,
    required this.roundCount,
    this.round = const JsonRound(),
  });

  int get playersJoined => players.length;

  factory JsonMatch.fromId(String id, MatchStatus status) => JsonMatch(
        id: id,
        numberOfPlayers: 0,
        maxPoints: 0,
        status: status,
        players: {},
        roundCount: 0,
        round: const JsonRound(
          discardPile: [],
          playersHand: {},
        ),
      );

  factory JsonMatch.fromString(String json) =>
      JsonMatch.fromJson(jsonDecode(json));

  factory JsonMatch.fromJson(Map<String, dynamic> json) =>
      _$JsonMatchFromJson(json);

  Map<String, dynamic> toJson() => _$JsonMatchToJson(this);
}
