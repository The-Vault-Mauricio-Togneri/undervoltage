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
      players: (json['players'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, JsonPlayer.fromJson(e as Map<String, dynamic>)),
      ),
      roundCount: json['roundCount'] as int,
      round: json['round'] == null
          ? const JsonRound()
          : JsonRound.fromJson(json['round'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$JsonMatchToJson(JsonMatch instance) => <String, dynamic>{
      'id': instance.id,
      'numberOfPlayers': instance.numberOfPlayers,
      'maxPoints': instance.maxPoints,
      'status': _$MatchStatusEnumMap[instance.status]!,
      'players': instance.players,
      'roundCount': instance.roundCount,
      'round': instance.round,
    };

const _$MatchStatusEnumMap = {
  MatchStatus.loading: 'loading',
  MatchStatus.waitingForPlayers: 'waitingForPlayers',
  MatchStatus.playing: 'playing',
  MatchStatus.summary: 'summary',
  MatchStatus.finished: 'finished',
};
