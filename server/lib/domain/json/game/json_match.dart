import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:undervoltage/domain/json/game/json_player.dart';
import 'package:undervoltage/domain/json/game/json_round.dart';
import 'package:undervoltage/domain/json/game/json_summary.dart';
import 'package:undervoltage/domain/types/match_status.dart';

part 'json_match.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonMatch {
  @JsonKey(name: 'players')
  final Map<String, JsonPlayer> players;

  @JsonKey(name: 'roundCount')
  final int roundCount;

  @JsonKey(name: 'round')
  final JsonRound round;

  @JsonKey(name: 'status')
  final MatchStatus status;

  @JsonKey(name: 'summary')
  final List<JsonSummary> summary;

  const JsonMatch({
    required this.players,
    required this.roundCount,
    required this.round,
    required this.status,
    required this.summary,
  });

  factory JsonMatch.fromString(String json) =>
      JsonMatch.fromJson(jsonDecode(json));

  factory JsonMatch.fromJson(Map<String, dynamic> json) =>
      _$JsonMatchFromJson(json);

  Map<String, dynamic> toJson() => _$JsonMatchToJson(this);
}
