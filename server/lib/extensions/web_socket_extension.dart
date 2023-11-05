import 'dart:io';
import 'package:undervoltage/domain/json/messages/json_message.dart';
import 'package:undervoltage/utils/logger.dart';

extension WebSocketExtension on WebSocket {
  String get id => hashCode.toString();

  void send(JsonMessage json) {
    add(json.toString());
    Logger.log(this, '>>> $json');
  }
}
