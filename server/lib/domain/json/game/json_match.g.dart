// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_match.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonMatch _$JsonMatchFromJson(Map<String, dynamic> json) => JsonMatch(
      players: (json['players'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, JsonPlayer.fromJson(e as Map<String, dynamic>)),
      ),
      roundCount: json['roundCount'] as int,
      round: JsonRound.fromJson(json['round'] as Map<String, dynamic>),
      status: $enumDecode(_$MatchStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$JsonMatchToJson(JsonMatch instance) => <String, dynamic>{
      'players': instance.players,
      'roundCount': instance.roundCount,
      'round': instance.round,
      'status': _$MatchStatusEnumMap[instance.status]!,
    };

const _$MatchStatusEnumMap = {
  MatchStatus.playing: 'playing',
  MatchStatus.summary: 'summary',
  MatchStatus.finished: 'finished',
};
