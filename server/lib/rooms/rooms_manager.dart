import 'dart:io';
import 'package:undervoltage/domain/json/api/json_create_room.dart';
import 'package:undervoltage/domain/json/messages/client_server/json_join_room.dart';
import 'package:undervoltage/domain/json/messages/json_message.dart';
import 'package:undervoltage/extensions/web_socket_extension.dart';
import 'package:undervoltage/rooms/room.dart';
import 'package:undervoltage/utils/map_list.dart';

class RoomsManager {
  final MapList<String, Room> rooms = MapList();
  final Map<WebSocket, Room> websocketToRoom = {};

  void create(JsonCreateRoom json) {
    final Room room = Room.fromJson(json);
    rooms.add(json.roomId, room);
    print(rooms);
  }

  void join({
    required JsonJoinRoom json,
    required WebSocket socket,
  }) {
    if (rooms.has(json.roomId)) {
      final Room room = rooms.get(json.roomId);
      final bool joined = room.join(
        playerId: json.playerId,
        socket: socket,
      );

      if (joined) {
        websocketToRoom[socket] = room;
      } else {
        socket.send(
          JsonMessage.error(
            'Player ${json.playerId} cannot join room with ID ${json.roomId}',
          ),
        );
      }
    } else {
      socket.send(
        JsonMessage.error('Room with ID ${json.roomId} does not exist'),
      );
    }
  }

  void leave(WebSocket socket) {
    if (websocketToRoom.containsKey(socket)) {
      final Room room = websocketToRoom[socket]!;
      room.leave(socket);
      websocketToRoom.remove(socket);
    } else {
      socket.send(JsonMessage.error('Connection not linked with any room'));
    }
  }

  void update(double dt) {
    for (final Room room in rooms.list) {
      room.update(dt);
    }
  }
}
