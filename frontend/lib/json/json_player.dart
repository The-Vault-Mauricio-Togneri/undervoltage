import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'json_player.g.dart';

@JsonSerializable()
class JsonPlayer {
  final String id;
  final String name;
  final int points;

  const JsonPlayer({
    required this.id,
    required this.name,
    required this.points,
  });

  factory JsonPlayer.fromString(String json) =>
      JsonPlayer.fromJson(jsonDecode(json));

  factory JsonPlayer.fromJson(Map<String, dynamic> json) =>
      _$JsonPlayerFromJson(json);

  Map<String, dynamic> toJson() => _$JsonPlayerToJson(this);
}
