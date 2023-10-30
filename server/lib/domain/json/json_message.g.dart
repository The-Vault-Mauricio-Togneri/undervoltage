// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonMessage _$JsonMessageFromJson(Map<String, dynamic> json) => JsonMessage(
      type: $enumDecode(_$MessageTypeEnumMap, json['type']),
      welcome: json['welcome'] == null
          ? null
          : JsonWelcome.fromJson(json['welcome'] as Map<String, dynamic>),
      start: json['start'] == null
          ? null
          : JsonStart.fromJson(json['start'] as Map<String, dynamic>),
      joinRoom: json['joinRoom'] == null
          ? null
          : JsonJoinRoom.fromJson(json['joinRoom'] as Map<String, dynamic>),
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

  writeNotNull('welcome', instance.welcome);
  writeNotNull('start', instance.start);
  writeNotNull('joinRoom', instance.joinRoom);
  return val;
}

const _$MessageTypeEnumMap = {
  MessageType.welcome: 'welcome',
  MessageType.start: 'start',
  MessageType.joinRoom: 'joinRoom',
  MessageType.error: 'error',
};
