import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:undervoltage/json/json_card.dart';

part 'json_hand.g.dart';

@JsonSerializable()
class JsonHand {
  final List<JsonCard> hiddenPile;
  final List<JsonCard> revealedPile;

  const JsonHand({
    required this.hiddenPile,
    required this.revealedPile,
  });

  factory JsonHand.fromString(String json) =>
      JsonHand.fromJson(jsonDecode(json));

  factory JsonHand.fromJson(Map<String, dynamic> json) =>
      _$JsonHandFromJson(json);

  Map<String, dynamic> toJson() => _$JsonHandToJson(this);
}
