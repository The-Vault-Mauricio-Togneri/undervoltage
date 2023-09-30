import 'dart:convert';
import 'package:idlebattle/json/json_output_message.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

extension WebSocketChannelExtension on WebSocketChannel {
  void send(JsonOutputMessage message) {
    sink.add(jsonEncode(message.toJson()));
    print('>>> ${jsonEncode(message.toJson())}');
  }
}
