import 'package:undervoltage/domain/json/game/json_player.dart';
import 'package:undervoltage/domain/types/player_status.dart';

class Player {
  final String id;
  final String name;
  final PlayerStatus status;
  final int points;

  Player({
    required this.id,
    required this.name,
    required this.status,
    required this.points,
  });

  factory Player.fromJson(JsonPlayer json) => Player(
        id: json.id,
        name: json.name,
        status: json.status,
        points: json.points,
      );

  bool get isFinished => status == PlayerStatus.finished;
}
