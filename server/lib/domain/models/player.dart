import 'package:undervoltage/domain/models/card.dart';
import 'package:undervoltage/domain/models/hand.dart';
import 'package:undervoltage/domain/types/player_status.dart';

class Player {
  final String id;
  final String name;
  final PlayerStatus status;
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

  void updatePoints(Hand hand) {
    final hiddenPoints = hand.hiddenPile.length;
    int revealedPoints = 0;

    for (final Card card in hand.revealedPile) {
      revealedPoints += card.value;
    }

    points += hiddenPoints + revealedPoints + hand.faults;
  }
}
