// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_output_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonOutputMessage _$JsonOutputMessageFromJson(Map<String, dynamic> json) => JsonOutputMessage(
      event: $enumDecode(_$OutputEventEnumMap, json['event']),
      playerName: json['playerName'] as String?,
      matchId: json['matchId'] as String?,
      laneId: json['laneId'] as int?,
      amount: json['amount'] as int?,
    );

Map<String, dynamic> _$JsonOutputMessageToJson(JsonOutputMessage instance) => <String, dynamic>{
      'event': _$OutputEventEnumMap[instance.event]!,
      'playerName': instance.playerName,
      'matchId': instance.matchId,
      'laneId': instance.laneId,
      'amount': instance.amount,
    };

const _$OutputEventEnumMap = {
  OutputEvent.ECHO: 'ECHO',
  OutputEvent.JOIN_PUBLIC: 'JOIN_PUBLIC',
  OutputEvent.CREATE_PRIVATE: 'CREATE_PRIVATE',
  OutputEvent.JOIN_PRIVATE: 'JOIN_PRIVATE',
  OutputEvent.INCREASE_MINE: 'INCREASE_MINE',
  OutputEvent.INCREASE_ATTACK: 'INCREASE_ATTACK',
  OutputEvent.LAUNCH_UNITS: 'LAUNCH_UNITS',
  OutputEvent.DISCONNECT: 'DISCONNECT',
};
