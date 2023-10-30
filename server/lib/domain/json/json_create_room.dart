import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'json_create_room.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonCreateRoom {
  @JsonKey(name: 'roomId')
  final String roomId;

  @JsonKey(name: 'createdAt')
  final DateTime createdAt;

  @JsonKey(name: 'numberOfPlayers')
  final int numberOfPlayers;

  @JsonKey(name: 'matchType')
  final String matchType;

  @JsonKey(name: 'players')
  final Map<String, String> players;

  const JsonCreateRoom({
    required this.roomId,
    required this.createdAt,
    required this.numberOfPlayers,
    required this.matchType,
    required this.players,
  });

  factory JsonCreateRoom.fromString(String json) =>
      JsonCreateRoom.fromJson(jsonDecode(json));

  factory JsonCreateRoom.fromJson(Map<String, dynamic> json) =>
      _$JsonCreateRoomFromJson(json);

  Map<String, dynamic> toJson() => _$JsonCreateRoomToJson(this);
}
