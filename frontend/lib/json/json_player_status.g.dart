// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_player_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonPlayerStatus _$JsonPlayerStatusFromJson(Map<String, dynamic> json) => JsonPlayerStatus(
      name: json['name'] as String,
      isSelf: json['isSelf'] as bool,
      direction: json['direction'] as int,
      points: json['points'] as int,
      money: json['money'] as int?,
      mineLevel: json['mineLevel'] as int?,
      attackLevel: json['attackLevel'] as int?,
    );

Map<String, dynamic> _$JsonPlayerStatusToJson(JsonPlayerStatus instance) => <String, dynamic>{
      'name': instance.name,
      'isSelf': instance.isSelf,
      'direction': instance.direction,
      'points': instance.points,
      'money': instance.money,
      'mineLevel': instance.mineLevel,
      'attackLevel': instance.attackLevel,
    };
