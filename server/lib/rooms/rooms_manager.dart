import 'dart:io';
import 'package:undervoltage/domain/json/api/json_create_room.dart';
import 'package:undervoltage/domain/json/messages/client_server/json_discard_card.dart';
import 'package:undervoltage/domain/json/messages/client_server/json_increase_fault.dart';
import 'package:undervoltage/domain/json/messages/client_server/json_join_room.dart';
import 'package:undervoltage/domain/json/messages/client_server/json_play_card.dart';
import 'package:undervoltage/domain/json/messages/client_server/json_summary_accept.dart';
import 'package:undervoltage/domain/json/messages/json_message.dart';
import 'package:undervoltage/rooms/room.dart';
import 'package:undervoltage/utils/map_list.dart';

class RoomsManager {
  final MapList<String, Room> rooms = MapList();
  final Map<WebSocket, Room> websocketToRoom = {};

  void create(JsonCreateRoom json) {
    final Room room = Room.fromJson(json);
    rooms.add(json.roomId, room);
  }

  void join({
    required JsonJoinRoom json,
    required WebSocket socket,
  }) {
    final Room room = _getRoom(
      roomId: json.roomId,
      socket: socket,
    );
    room.join(
      playerId: json.playerId,
      socket: socket,
    );
    websocketToRoom[socket] = room;
  }

  void leave(WebSocket socket) {
    if (websocketToRoom.containsKey(socket)) {
      final Room room = websocketToRoom[socket]!;
      room.leave(socket);
      websocketToRoom.remove(socket);
    } else {
      throw JsonMessage.error('Connection not linked with any room');
    }
  }

  void playCard({
    required JsonPlayCard json,
    required WebSocket socket,
  }) {
    final Room room = _getRoom(
      roomId: json.roomId,
      socket: socket,
    );
    room.playCard(
      cardId: json.cardId,
      playerId: json.playerId,
    );
  }

  void discardCard({
    required JsonDiscardCard json,
    required WebSocket socket,
  }) {
    final Room room = _getRoom(
      roomId: json.roomId,
      socket: socket,
    );
    room.discardCard(json.playerId);
  }

  void increaseFault({
    required JsonIncreaseFault json,
    required WebSocket socket,
  }) {
    final Room room = _getRoom(
      roomId: json.roomId,
      socket: socket,
    );
    room.increaseFault(json.playerId);
  }

  void summaryAccepted({
    required JsonSummaryAccept json,
    required WebSocket socket,
  }) {
    final Room room = _getRoom(
      roomId: json.roomId,
      socket: socket,
    );
    room.summaryAccepted(json.playerId);
  }

  Room _getRoom({
    required String roomId,
    required WebSocket socket,
  }) {
    if (rooms.has(roomId)) {
      return rooms.get(roomId);
    } else {
      throw JsonMessage.error('Room with ID $roomId does not exist');
    }
  }

  void update(double dt) {
    for (final Room room in rooms.list) {
      room.update(dt);
    }
  }
}
