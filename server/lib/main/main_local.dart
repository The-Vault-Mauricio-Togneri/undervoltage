import 'package:tensionpath/server/launcher.dart';

Future main(List<String> args) async {
  final int port = int.parse(args[0]);

  final Launcher launcher = Launcher();
  launcher.start(port: port);
}
