import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:undervoltage/domain/models/player.dart';
import 'package:undervoltage/domain/types/player_status.dart';

part 'json_player.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonPlayer {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'status')
  final PlayerStatus status;

  @JsonKey(name: 'points')
  final int points;

  const JsonPlayer({
    required this.id,
    required this.name,
    required this.status,
    required this.points,
  });

  Player get player => Player(
        id: id,
        name: name,
        status: status,
        points: points,
      );

  factory JsonPlayer.fromString(String json) =>
      JsonPlayer.fromJson(jsonDecode(json));

  factory JsonPlayer.fromJson(Map<String, dynamic> json) =>
      _$JsonPlayerFromJson(json);

  Map<String, dynamic> toJson() => _$JsonPlayerToJson(this);
}
