import 'dart:io';
import 'package:undervoltage/domain/json/json_message.dart';
import 'package:undervoltage/utils/logger.dart';

extension WebSocketExtension on WebSocket {
  void send(JsonMessage json) {
    add(json.toString());
    Logger.log(this, '>>> $json');
  }
}
