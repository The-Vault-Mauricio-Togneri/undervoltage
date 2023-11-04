import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:undervoltage/domain/models/card.dart';
import 'package:undervoltage/domain/types/card_color.dart';

part 'json_card.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonCard {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'color')
  final CardColor color;

  @JsonKey(name: 'diff')
  final int diff;

  @JsonKey(name: 'value')
  final int value;

  const JsonCard({
    required this.id,
    required this.color,
    required this.diff,
    required this.value,
  });

  Card get card => Card(
        id: id,
        color: color,
        diff: diff,
        value: value,
      );

  factory JsonCard.fromString(String json) =>
      JsonCard.fromJson(jsonDecode(json));

  factory JsonCard.fromJson(Map<String, dynamic> json) =>
      _$JsonCardFromJson(json);

  Map<String, dynamic> toJson() => _$JsonCardToJson(this);
}
