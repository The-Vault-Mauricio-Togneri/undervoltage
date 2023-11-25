import 'dart:convert';
import 'dart:io';
import 'package:undervoltage/domain/json/api/json_create_room.dart';
import 'package:undervoltage/domain/json/messages/json_message.dart';
import 'package:undervoltage/rooms/rooms_manager.dart';
import 'package:undervoltage/server/environment.dart';
import 'package:undervoltage/server/handler.dart';
import 'package:undervoltage/utils/logger.dart';

const String X_API_KEY_HEADER = 'x-api-key';

class Server {
  final Handler handler;
  final RoomsManager roomsManager;

  const Server(this.roomsManager, this.handler);

  Future start() async {
    final HttpServer server = await _server(
      port: environment.port,
      chain: environment.chain,
      key: environment.key,
    );
    Logger.info('Server running on ${server.port}');

    while (true) {
      try {
        await server.forEach(_handleRequest);
      } catch (e) {
        Logger.error('Error listening for requests', e);
      }
    }
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
    try {
      Logger.info('HTTP Request: ${request.method} ${request.requestedUri}');

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
        Logger.info('Request cannot be upgraded');

        request.response.statusCode = HttpStatus.forbidden;
        request.response.close();
      }
    } catch (e) {
      Logger.error('Error handling request', e);
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
    final String? apiKey = request.headers[X_API_KEY_HEADER]?[0];

    if (apiKey == environment.apiKey) {
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
