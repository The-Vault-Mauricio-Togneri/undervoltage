import 'package:undervoltage/models/card.dart';
import 'package:undervoltage/models/hand.dart';
import 'package:undervoltage/types/player_status.dart';

class Player {
  final String id;
  final String name;
  final PlayerStatus status;
  int points;

  Player._({
    required this.id,
    required this.name,
    required this.status,
    required this.points,
  });

  factory Player.create(String playerId, String playerName) => Player._(
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
