import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:undervoltage/types/player_status.dart';

part 'json_player.g.dart';

@JsonSerializable()
class JsonPlayer {
  final String id;
  final String name;
  final int points;
  final PlayerStatus status;

  const JsonPlayer({
    required this.id,
    required this.name,
    required this.points,
    required this.status,
  });

  factory JsonPlayer.fromString(String json) =>
      JsonPlayer.fromJson(jsonDecode(json));

  factory JsonPlayer.fromJson(Map<String, dynamic> json) =>
      _$JsonPlayerFromJson(json);

  Map<String, dynamic> toJson() => _$JsonPlayerToJson(this);
}
