import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:undervoltage/types/match_status.dart';

part 'json_match.g.dart';

@JsonSerializable()
class JsonMatch {
  final String id;
  final int numberOfPlayers;
  final int maxPoints;
  final MatchStatus status;

  const JsonMatch({
    required this.id,
    required this.numberOfPlayers,
    required this.maxPoints,
    required this.status,
  });

  factory JsonMatch.fromString(String json) =>
      JsonMatch.fromJson(jsonDecode(json));

  factory JsonMatch.fromJson(Map<String, dynamic> json) =>
      _$JsonMatchFromJson(json);

  Map<String, dynamic> toJson() => _$JsonMatchToJson(this);
}
