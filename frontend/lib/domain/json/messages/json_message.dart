import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:undervoltage/domain/json/game/json_match.dart';
import 'package:undervoltage/domain/json/messages/client_server/json_discard_card.dart';
import 'package:undervoltage/domain/json/messages/client_server/json_increase_fault.dart';
import 'package:undervoltage/domain/json/messages/client_server/json_join_room.dart';
import 'package:undervoltage/domain/json/messages/client_server/json_play_card.dart';
import 'package:undervoltage/domain/json/messages/client_server/json_summary_accept.dart';
import 'package:undervoltage/domain/json/messages/server_client/json_error.dart';
import 'package:undervoltage/domain/json/messages/server_client/json_update.dart';
import 'package:undervoltage/domain/json/messages/server_client/json_welcome.dart';

part 'json_message.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonMessage {
  @JsonKey(name: 'type')
  final MessageType type;

  @JsonKey(name: 'error')
  final JsonError? error;

  @JsonKey(name: 'welcome')
  final JsonWelcome? welcome;

  @JsonKey(name: 'update')
  final JsonUpdate? update;

  @JsonKey(name: 'joinRoom')
  final JsonJoinRoom? joinRoom;

  @JsonKey(name: 'playCard')
  final JsonPlayCard? playCard;

  @JsonKey(name: 'discardCard')
  final JsonDiscardCard? discardCard;

  @JsonKey(name: 'increaseFault')
  final JsonIncreaseFault? increaseFault;

  @JsonKey(name: 'summaryAccepted')
  final JsonSummaryAccept? summaryAccepted;

  const JsonMessage({
    required this.type,
    this.error,
    this.welcome,
    this.update,
    this.joinRoom,
    this.playCard,
    this.discardCard,
    this.increaseFault,
    this.summaryAccepted,
  });

  dynamic get message {
    switch (type) {
      case MessageType.error:
        return error;
      case MessageType.welcome:
        return welcome;
      case MessageType.update:
        return update;

      case MessageType.joinRoom:
        return joinRoom;
      case MessageType.playCard:
        return playCard;
      case MessageType.discardCard:
        return discardCard;
      case MessageType.increaseFault:
        return increaseFault;
      case MessageType.summaryAccepted:
        return summaryAccepted;
    }
  }

  factory JsonMessage.fromString(String json) =>
      JsonMessage.fromJson(jsonDecode(json));

  factory JsonMessage.fromJson(Map<String, dynamic> json) =>
      _$JsonMessageFromJson(json);

  factory JsonMessage.error(String message) => JsonMessage(
        type: MessageType.error,
        error: JsonError(message: message),
      );

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

  factory JsonMessage.playCard({
    required String roomId,
    required String cardId,
    required String playerId,
  }) =>
      JsonMessage(
        type: MessageType.playCard,
        playCard: JsonPlayCard(
          roomId: roomId,
          cardId: cardId,
          playerId: playerId,
        ),
      );

  factory JsonMessage.discardCard({
    required String roomId,
    required String playerId,
  }) =>
      JsonMessage(
        type: MessageType.discardCard,
        discardCard: JsonDiscardCard(
          roomId: roomId,
          playerId: playerId,
        ),
      );

  factory JsonMessage.increaseFault({
    required String roomId,
    required String playerId,
  }) =>
      JsonMessage(
        type: MessageType.increaseFault,
        increaseFault: JsonIncreaseFault(
          roomId: roomId,
          playerId: playerId,
        ),
      );

  factory JsonMessage.summaryAccepted({
    required String roomId,
    required String playerId,
  }) =>
      JsonMessage(
        type: MessageType.summaryAccepted,
        summaryAccepted: JsonSummaryAccept(
          roomId: roomId,
          playerId: playerId,
        ),
      );

  Map<String, dynamic> toJson() => _$JsonMessageToJson(this);

  @override
  String toString() => jsonEncode(toJson());
}

enum MessageType {
  // server -> client
  error,
  welcome,
  update,

  // client -> server
  joinRoom,
  playCard,
  discardCard,
  increaseFault,
  summaryAccepted,
}
