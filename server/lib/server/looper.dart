import 'package:tensionpath/rooms/rooms_manager.dart';

class Looper {
  final RoomsManager roomsManager;
  final DateTime initialTime = DateTime.now();
  double previous = 0;

  Looper(this.roomsManager) {
    previous = currentTime;
  }

  double get currentTime =>
      DateTime.now().difference(initialTime).inMilliseconds / 1000;

  Future start() async {
    while (true) {
      final double current = currentTime;
      final double dt = current - previous;
      previous = current;

      roomsManager.update(dt);

      await Future.delayed(const Duration(milliseconds: 16));
    }
  }
}
