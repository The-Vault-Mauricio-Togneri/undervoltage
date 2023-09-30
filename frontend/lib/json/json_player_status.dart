import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:undervoltage/models/player.dart';

part 'json_player_status.g.dart';

@JsonSerializable()
class JsonPlayerStatus {
  final String name;
  final bool isSelf;
  final int direction;
  final int points;
  final int? money;
  final int? mineLevel;
  final int? attackLevel;

  const JsonPlayerStatus({
    required this.name,
    required this.isSelf,
    required this.direction,
    required this.points,
    this.money,
    this.mineLevel,
    this.attackLevel,
  });

  Player get player => Player(
        name: name,
        direction: direction,
        isSelf: isSelf,
      );

  factory JsonPlayerStatus.fromString(String json) => JsonPlayerStatus.fromJson(jsonDecode(json));

  factory JsonPlayerStatus.fromJson(Map<String, dynamic> json) => _$JsonPlayerStatusFromJson(json);

  Map<String, dynamic> toJson() => _$JsonPlayerStatusToJson(this);
}
