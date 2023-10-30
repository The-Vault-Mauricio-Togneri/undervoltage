import 'dart:io';
import 'package:undervoltage/domain/json/json_create_room.dart';
import 'package:undervoltage/domain/json/json_message.dart';
import 'package:undervoltage/extensions/web_socket_extension.dart';
import 'package:undervoltage/utils/logger.dart';

class Room {
  final String id;
  final DateTime createdAt;
  final int numberOfPlayers;
  final String matchType;
  final Map<String, String> players;
  final Map<String, WebSocket> playerIdToWebSocket = {};
  final Map<WebSocket, String> webSocketToPlayerId = {};
  double timeSpent = 0;

  Room._({
    required this.id,
    required this.createdAt,
    required this.numberOfPlayers,
    required this.matchType,
    required this.players,
  });

  factory Room.fromJson(JsonCreateRoom json) => Room._(
        id: json.roomId,
        createdAt: json.createdAt,
        numberOfPlayers: json.numberOfPlayers,
        matchType: json.matchType,
        players: json.players,
      );

  bool join({
    required String playerId,
    required WebSocket socket,
  }) {
    if (players.containsKey(playerId)) {
      playerIdToWebSocket[playerId] = socket;
      webSocketToPlayerId[socket] = playerId;

      Logger.log(socket, 'Player $playerId joined room $id');

      if (playerIdToWebSocket.length == numberOfPlayers) {
        _broadcast(JsonMessage.start());
      }

      return true;
    } else {
      return false;
    }
  }

  bool leave(WebSocket socket) {
    final String? playerId = webSocketToPlayerId[socket];

    if (playerId != null) {
      playerIdToWebSocket.remove(playerId);
      webSocketToPlayerId.remove(socket);

      Logger.log(socket, 'Player $playerId left room $id');

      return true;
    } else {
      return false;
    }
  }

  void _broadcast(JsonMessage json) {
    for (final WebSocket socket in webSocketToPlayerId.keys) {
      socket.send(json);
    }
  }

  void update(double dt) {
    timeSpent += dt;

    /*if (timeSpent.toInt() % 5 == 0) {
      for (final WebSocket socket in playerIdToWebSocket.values) {
        socket.send(JsonMessage(type: timeSpent.toString()));
      }
    }*/
  }
}
