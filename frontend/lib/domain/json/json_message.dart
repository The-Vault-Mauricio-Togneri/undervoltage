import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:undervoltage/domain/json/json_error.dart';
import 'package:undervoltage/domain/json/json_join_room.dart';
import 'package:undervoltage/domain/json/json_start.dart';
import 'package:undervoltage/domain/json/json_welcome.dart';

part 'json_message.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonMessage {
  @JsonKey(name: 'type')
  final MessageType type;

  @JsonKey(name: 'welcome')
  final JsonWelcome? welcome;

  @JsonKey(name: 'start')
  final JsonStart? start;

  @JsonKey(name: 'joinRoom')
  final JsonJoinRoom? joinRoom;

  @JsonKey(name: 'error')
  final JsonError? error;

  const JsonMessage({
    required this.type,
    this.welcome,
    this.start,
    this.joinRoom,
    this.error,
  });

  dynamic get message {
    switch (type) {
      case MessageType.welcome:
        return welcome;
      case MessageType.start:
        return start;
      case MessageType.joinRoom:
        return joinRoom;
      case MessageType.error:
        return error;
    }
  }

  factory JsonMessage.fromString(String json) =>
      JsonMessage.fromJson(jsonDecode(json));

  factory JsonMessage.fromJson(Map<String, dynamic> json) =>
      _$JsonMessageFromJson(json);

  factory JsonMessage.welcome() => const JsonMessage(
        type: MessageType.welcome,
        welcome: JsonWelcome(),
      );

  factory JsonMessage.start() => const JsonMessage(
        type: MessageType.start,
        start: JsonStart(),
      );

  factory JsonMessage.joinRoom({
    required String roomId,
    required String playerId,
  }) =>
      JsonMessage(
        type: MessageType.joinRoom,
        joinRoom: JsonJoinRoom(
          roomId: roomId,
          playerId: playerId,
        ),
      );

  factory JsonMessage.error(String message) => JsonMessage(
        type: MessageType.error,
        error: JsonError(message: message),
      );

  Map<String, dynamic> toJson() => _$JsonMessageToJson(this);

  @override
  String toString() => jsonEncode(toJson());
}

enum MessageType {
  welcome,
  start,
  joinRoom,
  error,
}
