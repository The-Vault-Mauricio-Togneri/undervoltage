import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'json_card.g.dart';

@JsonSerializable()
class JsonCard {
  final String color;
  final int diff;
  final int value;

  const JsonCard({
    required this.color,
    required this.diff,
    required this.value,
  });

  factory JsonCard.fromString(String json) =>
      JsonCard.fromJson(jsonDecode(json));

  factory JsonCard.fromJson(Map<String, dynamic> json) =>
      _$JsonCardFromJson(json);

  Map<String, dynamic> toJson() => _$JsonCardToJson(this);
}
