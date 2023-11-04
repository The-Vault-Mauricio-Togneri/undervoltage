import 'package:undervoltage/domain/json/messages/json_message.dart';
import 'package:undervoltage/environments/environment.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Connection {
  late final WebSocketChannel channel;
  final Function(dynamic) onMessage;
  final Function() onDisconnected;
  final Function(dynamic) onError;

  Connection({
    required this.onMessage,
    required this.onDisconnected,
    required this.onError,
  });

  void connect() {
    final Uri uri = Uri.parse(Environment.get.matchServerUrl);
    channel = WebSocketChannel.connect(uri);
    channel.stream.listen(
      _onMessageReceived,
      onDone: onDisconnected,
      onError: onError,
    );
  }

  void send(JsonMessage message) {
    channel.sink.add(message.toString());
  }

  void _onMessageReceived(dynamic message) {
    final JsonMessage json = JsonMessage.fromString(message);
    onMessage(json.message);
  }
}
