import 'package:undervoltage/rooms/rooms_manager.dart';
import 'package:undervoltage/server/handler.dart';
import 'package:undervoltage/server/server.dart';

class Launcher {
  Future start({
    required int port,
    String? chain,
    String? key,
  }) async {
    final RoomsManager roomsManager = RoomsManager();
    final Handler handler = Handler(roomsManager);
    // final Looper looper = Looper(roomsManager);

    final Server server = Server(roomsManager, handler);
    await server.start(
      port: port,
      chain: chain,
      key: key,
    );

    // looper.start();
  }
}
