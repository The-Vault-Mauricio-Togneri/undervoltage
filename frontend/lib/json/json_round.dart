import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:undervoltage/json/json_card.dart';
import 'package:undervoltage/json/json_hand.dart';

part 'json_round.g.dart';

@JsonSerializable()
class JsonRound {
  final List<JsonCard> discardPile;
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
