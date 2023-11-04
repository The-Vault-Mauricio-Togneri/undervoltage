import 'package:undervoltage/domain/json/game/json_round.dart';
import 'package:undervoltage/domain/models/game/card.dart';
import 'package:undervoltage/domain/models/game/hand.dart';

class Round {
  final List<Card> discardPile;
  final Map<String, Hand> playersHand;

  const Round({
    required this.discardPile,
    required this.playersHand,
  });

  factory Round.fromJson(JsonRound json) => Round(
        discardPile: json.discardPile.map(Card.fromJson).toList(),
        playersHand: json.playersHand
            .map((key, value) => MapEntry(key, Hand.fromJson(value))),
      );
}
