import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'json_discard_card.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonDiscardCard {
  @JsonKey(name: 'roomId')
  final String roomId;

  @JsonKey(name: 'playerId')
  final String playerId;

  const JsonDiscardCard({
    required this.roomId,
    required this.playerId,
  });

  factory JsonDiscardCard.fromString(String json) =>
      JsonDiscardCard.fromJson(jsonDecode(json));

  factory JsonDiscardCard.fromJson(Map<String, dynamic> json) =>
      _$JsonDiscardCardFromJson(json);

  Map<String, dynamic> toJson() => _$JsonDiscardCardToJson(this);
}
