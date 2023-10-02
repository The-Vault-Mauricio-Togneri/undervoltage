// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonPlayer _$JsonPlayerFromJson(Map<String, dynamic> json) => JsonPlayer(
      id: json['id'] as String,
      name: json['name'] as String,
      points: json['points'] as int,
      status: $enumDecode(_$PlayerStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$JsonPlayerToJson(JsonPlayer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'points': instance.points,
      'status': _$PlayerStatusEnumMap[instance.status]!,
    };

const _$PlayerStatusEnumMap = {
  PlayerStatus.ready: 'ready',
  PlayerStatus.playing: 'playing',
  PlayerStatus.blocked: 'blocked',
  PlayerStatus.readingSummary: 'readingSummary',
};
