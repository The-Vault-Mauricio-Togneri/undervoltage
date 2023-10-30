import 'dart:io';
import 'package:undervoltage/server/launcher.dart';

Future main(List<String> args) async {
  final int port = int.parse(args[0]);
  final String chain = Platform.script.resolve(args[1]).toFilePath();
  final String key = Platform.script.resolve(args[2]).toFilePath();

  final Launcher launcher = Launcher();
  launcher.start(
    port: port,
    chain: chain,
    key: key,
  );
}
