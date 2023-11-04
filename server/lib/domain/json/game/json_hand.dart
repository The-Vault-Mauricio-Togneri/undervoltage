import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:undervoltage/domain/json/game/json_card.dart';
import 'package:undervoltage/domain/models/hand.dart';

part 'json_hand.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonHand {
  @JsonKey(name: 'hiddenPile')
  final List<JsonCard> hiddenPile;

  @JsonKey(name: 'revealedPile')
  final List<JsonCard> revealedPile;

  @JsonKey(name: 'faults')
  final int faults;

  const JsonHand({
    required this.hiddenPile,
    required this.revealedPile,
    required this.faults,
  });

  Hand get hand => Hand(
        hiddenPile: hiddenPile.map((e) => e.card).toList(),
        revealedPile: revealedPile.map((e) => e.card).toList(),
        faults: faults,
      );

  factory JsonHand.fromString(String json) =>
      JsonHand.fromJson(jsonDecode(json));

  factory JsonHand.fromJson(Map<String, dynamic> json) =>
      _$JsonHandFromJson(json);

  Map<String, dynamic> toJson() => _$JsonHandToJson(this);
}
