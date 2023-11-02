import 'package:undervoltage/types/player_status.dart';

class Player {
  final String id;
  final String name;
  final int points;
  final PlayerStatus status;

  const Player({
    required this.id,
    required this.name,
    required this.points,
    required this.status,
  });
}
