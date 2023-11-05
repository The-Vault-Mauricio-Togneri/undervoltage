import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:undervoltage/domain/json/game/json_match.dart';
import 'package:undervoltage/domain/json/messages/client_server/json_join_room.dart';
import 'package:undervoltage/domain/json/messages/server_client/json_error.dart';
import 'package:undervoltage/domain/json/messages/server_client/json_update.dart';
import 'package:undervoltage/domain/json/messages/server_client/json_welcome.dart';

part 'json_message.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonMessage {
  @JsonKey(name: 'type')
  final MessageType type;

  @JsonKey(name: 'welcome')
  final JsonWelcome? welcome;

  @JsonKey(name: 'update')
  final JsonUpdate? update;

  @JsonKey(name: 'joinRoom')
  final JsonJoinRoom? joinRoom;

  @JsonKey(name: 'error')
  final JsonError? error;

  const JsonMessage({
    required this.type,
    this.welcome,
    this.update,
    this.joinRoom,
    this.error,
  });

  dynamic get message {
    switch (type) {
      case MessageType.welcome:
        return welcome;
      case MessageType.update:
        return update;
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

  factory JsonMessage.update(JsonMatch match) => JsonMessage(
        type: MessageType.update,
        update: JsonUpdate(match: match),
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
  update,
  joinRoom,
  error,
}
