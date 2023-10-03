import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:undervoltage/json/json_card.dart';

part 'json_hand.g.dart';

@JsonSerializable()
class JsonHand {
  final List<JsonCard> hiddenPile;
  final List<JsonCard> revealedPile;
  final int faults;

  const JsonHand({
    this.hiddenPile = const [],
    this.revealedPile = const [],
    this.faults = 0,
  });

  void revealCard() {
    if (hiddenPile.isNotEmpty) {
      final JsonCard topCard = hiddenPile.removeLast();
      revealedPile.add(topCard);
    }
  }

  void playCard(JsonCard card) {
    revealedPile.remove(card);

    if (revealedPile.isEmpty) {
      revealCard();
    }
  }

  factory JsonHand.fromString(String json) =>
      JsonHand.fromJson(jsonDecode(json));

  factory JsonHand.fromJson(Map<String, dynamic> json) =>
      _$JsonHandFromJson(json);

  Map<String, dynamic> toJson() => _$JsonHandToJson(this);
}
