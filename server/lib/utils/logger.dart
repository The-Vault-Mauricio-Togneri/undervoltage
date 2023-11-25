import 'dart:io';
import 'package:undervoltage/extensions/web_socket_extension.dart';
import 'package:undervoltage/utils/constants.dart';

class Logger {
  static void log(WebSocket socket, String text) {
    if (Constants.LOGS_ENABLED) {
      print('[${socket.id} ${DateTime.now()}] $text');
    }
  }

  static void info(String text) {
    if (Constants.LOGS_ENABLED) {
      print('[${DateTime.now()}] $text');
    }
  }

  static void error(String text, Object error) {
    if (Constants.LOGS_ENABLED) {
      print('$text: $error');
    }
  }
}
