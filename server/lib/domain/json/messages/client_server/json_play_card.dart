import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'json_play_card.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonPlayCard {
  @JsonKey(name: 'cardId')
  final String cardId;

  @JsonKey(name: 'playerId')
  final String playerId;

  const JsonPlayCard({
    required this.cardId,
    required this.playerId,
  });

  factory JsonPlayCard.fromString(String json) =>
      JsonPlayCard.fromJson(jsonDecode(json));

  factory JsonPlayCard.fromJson(Map<String, dynamic> json) =>
      _$JsonPlayCardFromJson(json);

  Map<String, dynamic> toJson() => _$JsonPlayCardToJson(this);
}
