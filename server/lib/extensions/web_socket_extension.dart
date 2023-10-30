import 'dart:io';
import 'package:tensionpath/domain/json/json_message.dart';
import 'package:tensionpath/utils/logger.dart';

extension WebSocketExtension on WebSocket {
  void send(JsonMessage json) {
    add(json.toString());
    Logger.log(this, '>>> $json');
  }
}
