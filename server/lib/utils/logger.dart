import 'dart:io';
import 'package:undervoltage/utils/constants.dart';

class Logger {
  static void log(WebSocket socket, String text) {
    if (Constants.LOGS_ENABLED) {
      print('[${socket.hashCode} ${DateTime.now()}] $text');
    }
  }
}
