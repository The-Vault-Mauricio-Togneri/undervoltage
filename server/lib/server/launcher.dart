import 'package:undervoltage/rooms/rooms_manager.dart';
import 'package:undervoltage/server/handler.dart';
import 'package:undervoltage/server/server.dart';

class Launcher {
  Future start() async {
    final RoomsManager roomsManager = RoomsManager();
    final Handler handler = Handler(roomsManager);
    final Server server = Server(roomsManager, handler);
    await server.start();
  }
}
