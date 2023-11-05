import 'package:undervoltage/domain/json/game/json_player.dart';
import 'package:undervoltage/domain/models/hand.dart';
import 'package:undervoltage/domain/types/player_status.dart';

class Player {
  final String id;
  final String name;
  PlayerStatus status;
  int points;

  Player({
    required this.id,
    required this.name,
    required this.status,
    required this.points,
  });

  factory Player.create(String playerId, String playerName) => Player(
        id: playerId,
        name: playerName,
        status: PlayerStatus.playing,
        points: 0,
      );

  JsonPlayer get json => JsonPlayer(
        id: id,
        name: name,
        status: status,
        points: points,
      );

  void updateStatus(PlayerStatus newStatus) {
    status = newStatus;
  }

  void updatePoints(Hand hand) {
    points += hand.points + hand.faults;
  }
}
