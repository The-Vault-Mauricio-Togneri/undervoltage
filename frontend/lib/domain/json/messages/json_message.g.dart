// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonMessage _$JsonMessageFromJson(Map<String, dynamic> json) => JsonMessage(
      type: $enumDecode(_$MessageTypeEnumMap, json['type']),
      error: json['error'] == null
          ? null
          : JsonError.fromJson(json['error'] as Map<String, dynamic>),
      welcome: json['welcome'] == null
          ? null
          : JsonWelcome.fromJson(json['welcome'] as Map<String, dynamic>),
      update: json['update'] == null
          ? null
          : JsonUpdate.fromJson(json['update'] as Map<String, dynamic>),
      joinRoom: json['joinRoom'] == null
          ? null
          : JsonJoinRoom.fromJson(json['joinRoom'] as Map<String, dynamic>),
      playCard: json['playCard'] == null
          ? null
          : JsonPlayCard.fromJson(json['playCard'] as Map<String, dynamic>),
      discardCard: json['discardCard'] == null
          ? null
          : JsonDiscardCard.fromJson(
              json['discardCard'] as Map<String, dynamic>),
      increaseFault: json['increaseFault'] == null
          ? null
          : JsonIncreaseFault.fromJson(
              json['increaseFault'] as Map<String, dynamic>),
      summaryAccepted: json['summaryAccepted'] == null
          ? null
          : JsonSummaryAccept.fromJson(
              json['summaryAccepted'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$JsonMessageToJson(JsonMessage instance) {
  final val = <String, dynamic>{
    'type': _$MessageTypeEnumMap[instance.type]!,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('error', instance.error);
  writeNotNull('welcome', instance.welcome);
  writeNotNull('update', instance.update);
  writeNotNull('joinRoom', instance.joinRoom);
  writeNotNull('playCard', instance.playCard);
  writeNotNull('discardCard', instance.discardCard);
  writeNotNull('increaseFault', instance.increaseFault);
  writeNotNull('summaryAccepted', instance.summaryAccepted);
  return val;
}

const _$MessageTypeEnumMap = {
  MessageType.error: 'error',
  MessageType.welcome: 'welcome',
  MessageType.update: 'update',
  MessageType.joinRoom: 'joinRoom',
  MessageType.playCard: 'playCard',
  MessageType.discardCard: 'discardCard',
  MessageType.increaseFault: 'increaseFault',
  MessageType.summaryAccepted: 'summaryAccepted',
};
