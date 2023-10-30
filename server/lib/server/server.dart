import 'dart:convert';
import 'dart:io';
import 'package:tensionpath/domain/json/json_create_room.dart';
import 'package:tensionpath/domain/json/json_message.dart';
import 'package:tensionpath/rooms/rooms_manager.dart';
import 'package:tensionpath/server/handler.dart';
import 'package:tensionpath/utils/logger.dart';

class Server {
  final Handler handler;
  final RoomsManager roomsManager;

  const Server(this.roomsManager, this.handler);

  Future start({
    required int port,
    String? chain,
    String? key,
  }) async {
    final HttpServer server = await _server(
      port: port,
      chain: chain,
      key: key,
    );
    server.listen(_handleRequest);
    print('Server running on ${server.port}');
  }

  Future<HttpServer> _server({
    required int port,
    required String? chain,
    required String? key,
  }) async {
    if ((chain != null) && (key != null)) {
      final SecurityContext context = SecurityContext()
        ..useCertificateChain(chain)
        ..usePrivateKey(
          key,
          password: '',
        );

      return HttpServer.bindSecure(
        InternetAddress.anyIPv4,
        port,
        context,
      );
    } else {
      return HttpServer.bind(
        InternetAddress.anyIPv4,
        port,
      );
    }
  }

  Future _handleRequest(HttpRequest request) async {
    if ((request.method == 'POST') && (request.uri.toString() == '/rooms')) {
      _handleRoomCreation(request);
    } else if (WebSocketTransformer.isUpgradeRequest(request)) {
      final WebSocket socket = await WebSocketTransformer.upgrade(request);
      socket.listen(
        (message) => _onMessage(socket, message),
        onDone: () => handler.onDisconnect(socket),
        onError: (error) => handler.onError(socket, error),
      );
      handler.onConnect(socket);
    } else {
      print('Request cannot be upgraded');

      request.response.statusCode = HttpStatus.forbidden;
      request.response.close();
    }
  }

  void _onMessage(WebSocket socket, String message) {
    try {
      handler.onMessage(socket, JsonMessage.fromString(message));
    } catch (e) {
      Logger.log(socket, 'Exception: $e');
    }
  }

  Future _handleRoomCreation(HttpRequest request) async {
    final String? apiKey = request.headers['X-API-Key']?[0];

    // TODO(momo): externalize
    if (apiKey == 'API_KEY') {
      final String content = await utf8.decodeStream(request);
      final JsonCreateRoom json = JsonCreateRoom.fromString(content);

      roomsManager.create(json);

      request.response.statusCode = HttpStatus.created;
    } else {
      request.response.statusCode = HttpStatus.unauthorized;
    }

    request.response.close();
  }
}
