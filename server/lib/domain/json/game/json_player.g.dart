// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonPlayer _$JsonPlayerFromJson(Map<String, dynamic> json) => JsonPlayer(
      id: json['id'] as String,
      name: json['name'] as String,
      status: $enumDecode(_$PlayerStatusEnumMap, json['status']),
      points: json['points'] as int,
    );

Map<String, dynamic> _$JsonPlayerToJson(JsonPlayer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'status': _$PlayerStatusEnumMap[instance.status]!,
      'points': instance.points,
    };

const _$PlayerStatusEnumMap = {
  PlayerStatus.playing: 'playing',
  PlayerStatus.readingSummary: 'readingSummary',
  PlayerStatus.finished: 'finished',
};
