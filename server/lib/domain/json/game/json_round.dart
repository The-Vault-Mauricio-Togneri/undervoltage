import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:undervoltage/domain/json/game/json_card.dart';
import 'package:undervoltage/domain/json/game/json_hand.dart';

part 'json_round.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonRound {
  @JsonKey(name: 'discardPile')
  final List<JsonCard> discardPile;

  @JsonKey(name: 'playersHand')
  final Map<String, JsonHand> playersHand;

  const JsonRound({
    required this.discardPile,
    required this.playersHand,
  });

  factory JsonRound.fromString(String json) =>
      JsonRound.fromJson(jsonDecode(json));

  factory JsonRound.fromJson(Map<String, dynamic> json) =>
      _$JsonRoundFromJson(json);

  Map<String, dynamic> toJson() => _$JsonRoundToJson(this);
}
