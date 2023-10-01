// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_match.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonMatch _$JsonMatchFromJson(Map<String, dynamic> json) => JsonMatch(
      id: json['id'] as String,
      numberOfPlayers: json['numberOfPlayers'] as int,
      maxPoints: json['maxPoints'] as int,
      status: $enumDecode(_$MatchStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$JsonMatchToJson(JsonMatch instance) => <String, dynamic>{
      'id': instance.id,
      'numberOfPlayers': instance.numberOfPlayers,
      'maxPoints': instance.maxPoints,
      'status': _$MatchStatusEnumMap[instance.status]!,
    };

const _$MatchStatusEnumMap = {
  MatchStatus.waitingForPlayers: 'waitingForPlayers',
  MatchStatus.started: 'started',
};
