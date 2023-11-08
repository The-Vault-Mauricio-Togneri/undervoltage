import 'package:undervoltage/server/launcher.dart';
import 'package:undervoltage/server/server.dart';

Future main(List<String> args) async {
  final int port = int.parse(args[0]);
  API_KEY = args[1];

  final Launcher launcher = Launcher();
  launcher.start(port: port);
}
