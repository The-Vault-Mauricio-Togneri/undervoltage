import 'dart:io';
import 'package:tensionpath/domain/json/json_join_room.dart';
import 'package:tensionpath/domain/json/json_message.dart';
import 'package:tensionpath/extensions/web_socket_extension.dart';
import 'package:tensionpath/rooms/rooms_manager.dart';
import 'package:tensionpath/utils/logger.dart';

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
