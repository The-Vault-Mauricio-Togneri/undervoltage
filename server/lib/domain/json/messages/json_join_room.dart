import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'json_join_room.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonJoinRoom {
  @JsonKey(name: 'roomId')
  final String roomId;

  @JsonKey(name: 'playerId')
  final String playerId;

  const JsonJoinRoom({
    required this.roomId,
    required this.playerId,
  });

  factory JsonJoinRoom.fromString(String json) =>
      JsonJoinRoom.fromJson(jsonDecode(json));

  factory JsonJoinRoom.fromJson(Map<String, dynamic> json) =>
      _$JsonJoinRoomFromJson(json);

  Map<String, dynamic> toJson() => _$JsonJoinRoomToJson(this);
}
