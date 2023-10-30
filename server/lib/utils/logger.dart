import 'dart:io';
import 'package:tensionpath/utils/constants.dart';

class Logger {
  static void log(WebSocket socket, String text) {
    if (Constants.LOGS_ENABLED) {
      print('[${socket.hashCode} ${DateTime.now()}] $text');
    }
  }
}
