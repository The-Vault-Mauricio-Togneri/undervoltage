import 'dart:io';
import 'package:undervoltage/server/environment.dart';
import 'package:undervoltage/server/launcher.dart';

void main(List<String> args) {
  environment = Environment(
    matchFinishedUrl: 'https://matchfinished-hvlufafcya-oa.a.run.app',
    apiKey: args[0],
    port: int.parse(args[1]),
    chain: Platform.script.resolve(args[2]).toFilePath(),
    key: Platform.script.resolve(args[3]).toFilePath(),
  );

  final Launcher launcher = Launcher();
  launcher.start();
}
