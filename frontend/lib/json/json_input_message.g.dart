// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_input_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonInputMessage _$JsonInputMessageFromJson(Map<String, dynamic> json) => JsonInputMessage(
      event: $enumDecode(_$InputEventEnumMap, json['event']),
      playerName: json['playerName'] as String?,
      matchId: json['matchId'] as String?,
      laneId: json['laneId'] as int?,
      amount: json['amount'] as int?,
      direction: json['direction'] as int?,
      attackLevel: json['attackLevel'] as int?,
      finishState: $enumDecodeNullable(_$FinishStateEnumMap, json['finishState']),
      matchStatus: json['matchStatus'] == null ? null : JsonMatchStatus.fromJson(json['matchStatus'] as Map<String, dynamic>),
      configuration: json['configuration'] == null ? null : JsonMatchConfiguration.fromJson(json['configuration'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$JsonInputMessageToJson(JsonInputMessage instance) => <String, dynamic>{
      'event': _$InputEventEnumMap[instance.event]!,
      'playerName': instance.playerName,
      'matchId': instance.matchId,
      'laneId': instance.laneId,
      'amount': instance.amount,
      'direction': instance.direction,
      'attackLevel': instance.attackLevel,
      'finishState': _$FinishStateEnumMap[instance.finishState],
      'matchStatus': instance.matchStatus,
      'configuration': instance.configuration,
    };

const _$InputEventEnumMap = {
  InputEvent.ECHO: 'ECHO',
  InputEvent.WAITING_PUBLIC: 'WAITING_PUBLIC',
  InputEvent.WAITING_PRIVATE: 'WAITING_PRIVATE',
  InputEvent.MATCH_READY: 'MATCH_READY',
  InputEvent.MATCH_STARTED: 'MATCH_STARTED',
  InputEvent.MATCH_UPDATE: 'MATCH_UPDATE',
  InputEvent.LANE_REWARD_WON: 'LANE_REWARD_WON',
  InputEvent.LANE_REWARD_LOST: 'LANE_REWARD_LOST',
  InputEvent.LANE_WON: 'LANE_WON',
  InputEvent.LANE_LOST: 'LANE_LOST',
  InputEvent.UNITS_LAUNCHED: 'UNITS_LAUNCHED',
  InputEvent.MATCH_FINISHED: 'MATCH_FINISHED',
  InputEvent.INVALID_MATCH_ID: 'INVALID_MATCH_ID',
  InputEvent.INVALID_PLAYER_NAME: 'INVALID_PLAYER_NAME',
  InputEvent.INVALID_LANE_ID: 'INVALID_LANE_ID',
  InputEvent.INVALID_AMOUNT: 'INVALID_AMOUNT',
  InputEvent.PLAYER_DISCONNECTED: 'PLAYER_DISCONNECTED',
};

const _$FinishStateEnumMap = {
  FinishState.WON: 'WON',
  FinishState.LOST: 'LOST',
  FinishState.TIE: 'TIE',
};
