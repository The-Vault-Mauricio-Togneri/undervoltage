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

  bool canAccept(JsonCard card) {
    final num value1 = _normalize(value + diff);
    final num value2 = _normalize(value - diff);

    return (card.value == value1) || (card.value == value2);
  }

  num _normalize(int value) {
    if (value > 10) {
      return value - 10;
    } else if (value < 1) {
      return value + 10;
    } else {
      return value;
    }
  }

  factory JsonCard.fromString(String json) =>
      JsonCard.fromJson(jsonDecode(json));

  factory JsonCard.fromJson(Map<String, dynamic> json) =>
      _$JsonCardFromJson(json);

  Map<String, dynamic> toJson() => _$JsonCardToJson(this);

  Map<Object?, Object?> toMap() => {
        'color': color,
        'diff': diff,
        'value': value,
      };
}
