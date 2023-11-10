import 'package:undervoltage/server/environment.dart';
import 'package:undervoltage/server/launcher.dart';

void main(List<String> args) {
  environment = Environment(
    matchFinishedUrl:
        'http://127.0.0.1:5001/undervoltage/europe-west6/matchFinished',
    apiKey: args[0],
    port: int.parse(args[1]),
  );

  final Launcher launcher = Launcher();
  launcher.start();
}
