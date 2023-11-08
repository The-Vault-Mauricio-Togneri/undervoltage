import 'dart:convert';
import 'dart:io';
import 'package:undervoltage/domain/json/api/json_create_room.dart';
import 'package:undervoltage/domain/json/messages/json_message.dart';
import 'package:undervoltage/rooms/rooms_manager.dart';
import 'package:undervoltage/server/handler.dart';
import 'package:undervoltage/utils/logger.dart';

class Server {
  final Handler handler;
  final RoomsManager roomsManager;

  static const String X_API_KEY_HEADER = 'x-api-key';
  static const String API_KEY = '73b450b8-aba8-452f-b484-50142f69fe69';

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
    try {
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
    } catch (e) {
      Logger.error(e);
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

    if (apiKey == API_KEY) {
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
