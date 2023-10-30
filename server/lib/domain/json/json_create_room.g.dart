// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_create_room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonCreateRoom _$JsonCreateRoomFromJson(Map<String, dynamic> json) =>
    JsonCreateRoom(
      roomId: json['roomId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      numberOfPlayers: json['numberOfPlayers'] as int,
      matchType: json['matchType'] as String,
      players: Map<String, String>.from(json['players'] as Map),
    );

Map<String, dynamic> _$JsonCreateRoomToJson(JsonCreateRoom instance) =>
    <String, dynamic>{
      'roomId': instance.roomId,
      'createdAt': instance.createdAt.toIso8601String(),
      'numberOfPlayers': instance.numberOfPlayers,
      'matchType': instance.matchType,
      'players': instance.players,
    };
