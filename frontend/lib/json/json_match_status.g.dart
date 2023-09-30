// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_match_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonMatchStatus _$JsonMatchStatusFromJson(Map<String, dynamic> json) => JsonMatchStatus(
      id: json['id'] as String,
      remainingTime: (json['remainingTime'] as num).toDouble(),
      players: (json['players'] as List<dynamic>).map((e) => JsonPlayerStatus.fromJson(e as Map<String, dynamic>)).toList(),
      lanes: (json['lanes'] as List<dynamic>).map((e) => JsonLane.fromJson(e as Map<String, dynamic>)).toList(),
    );

Map<String, dynamic> _$JsonMatchStatusToJson(JsonMatchStatus instance) => <String, dynamic>{
      'id': instance.id,
      'remainingTime': instance.remainingTime,
      'players': instance.players,
      'lanes': instance.lanes,
    };
