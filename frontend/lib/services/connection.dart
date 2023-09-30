import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:undervoltage/app/constants.dart';
import 'package:undervoltage/extensions/web_socket_channel_extension.dart';
import 'package:undervoltage/json/json_input_message.dart';
import 'package:undervoltage/json/json_output_message.dart';
import 'package:undervoltage/services/initializer.dart';
import 'package:undervoltage/services/platform.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Connection {
  late final WebSocketChannel channel;
  late final Stream stream;

  static Connection get get => getIt<Connection>();

  void connect({
    required VoidCallback onConnect,
    required VoidCallback onError,
  }) {
    channel = WebSocketChannel.connect(Uri.parse('${_host()}/undervoltage'));
    stream = channel.stream.asBroadcastStream();

    StreamSubscription? streamSubscription;
    streamSubscription = stream.listen((message) {
      onConnect();
      streamSubscription?.cancel();
    }, onError: (error) {
      onError();
      streamSubscription?.cancel();
    });
  }

  StreamSubscription listenMessage(Function(JsonInputMessage) handler) => stream.listen((message) {
        final JsonInputMessage inputMessage = JsonInputMessage.fromString(message);
        handler(inputMessage);
      });

  void send(JsonOutputMessage message) => channel.send(message);

  String _host() {
    if (Platform.isDebug) {
      if (Platform.isMobileNative) {
        return Constants.HOST_DEBUG_MOBILE;
      } else {
        return Constants.HOST_DEBUG_WEB;
      }
    } else {
      return Constants.HOST_PROD;
    }
  }
}
