import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:undervoltage/domain/json/game/json_player.dart';
import 'package:undervoltage/domain/json/game/json_round.dart';
import 'package:undervoltage/domain/types/match_status.dart';

part 'json_match.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonMatch {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'players')
  final Map<String, JsonPlayer> players;

  @JsonKey(name: 'roundCount')
  final int roundCount;

  @JsonKey(name: 'round')
  final JsonRound round;

  @JsonKey(name: 'status')
  final MatchStatus status;

  const JsonMatch({
    required this.id,
    required this.players,
    required this.roundCount,
    required this.round,
    required this.status,
  });

  factory JsonMatch.fromString(String json) =>
      JsonMatch.fromJson(jsonDecode(json));

  factory JsonMatch.fromJson(Map<String, dynamic> json) =>
      _$JsonMatchFromJson(json);

  Map<String, dynamic> toJson() => _$JsonMatchToJson(this);
}
