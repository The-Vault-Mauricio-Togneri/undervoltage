import 'dart:io';
import 'package:undervoltage/domain/json/messages/client_server/json_discard_card.dart';
import 'package:undervoltage/domain/json/messages/client_server/json_increase_fault.dart';
import 'package:undervoltage/domain/json/messages/client_server/json_join_room.dart';
import 'package:undervoltage/domain/json/messages/client_server/json_play_card.dart';
import 'package:undervoltage/domain/json/messages/client_server/json_summary_accept.dart';
import 'package:undervoltage/domain/json/messages/json_message.dart';
import 'package:undervoltage/extensions/web_socket_extension.dart';
import 'package:undervoltage/rooms/rooms_manager.dart';
import 'package:undervoltage/utils/logger.dart';

class Handler {
  final RoomsManager roomsManager;

  const Handler(this.roomsManager);

  void onMessage(WebSocket socket, JsonMessage json) {
    Logger.log(socket, '<<< $json');

    final dynamic message = json.message;

    try {
      if (message is JsonJoinRoom) {
        roomsManager.join(
          json: message,
          socket: socket,
        );
      } else if (message is JsonPlayCard) {
        roomsManager.playCard(
          json: message,
          socket: socket,
        );
      } else if (message is JsonDiscardCard) {
        roomsManager.discardCard(
          json: message,
          socket: socket,
        );
      } else if (message is JsonIncreaseFault) {
        roomsManager.increaseFault(
          json: message,
          socket: socket,
        );
      } else if (message is JsonSummaryAccept) {
        roomsManager.summaryAccepted(
          json: message,
          socket: socket,
        );
      }
    } on JsonMessage catch (e) {
      socket.send(e);
    } catch (e) {
      socket.send(JsonMessage.error('Unknown error $e'));
    }
  }

  void onConnect(WebSocket socket) {
    Logger.log(socket, 'Connected');
    socket.send(JsonMessage.welcome());
  }

  void onDisconnect(WebSocket socket) {
    Logger.log(socket, 'Disconnected');
    roomsManager.leave(socket);
  }

  void onError(WebSocket socket, dynamic error) {
    Logger.log(socket, 'Error: $error');
  }
}
