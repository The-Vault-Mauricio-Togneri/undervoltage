import 'dart:io';
import 'package:undervoltage/domain/json/messages/json_join_room.dart';
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

    if (message is JsonJoinRoom) {
      roomsManager.join(
        json: message,
        socket: socket,
      );
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
