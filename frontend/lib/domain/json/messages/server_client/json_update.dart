import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:undervoltage/domain/json/game/json_match.dart';

part 'json_update.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonUpdate {
  @JsonKey(name: 'match')
  final JsonMatch match;

  const JsonUpdate({
    required this.match,
  });

  factory JsonUpdate.fromString(String json) =>
      JsonUpdate.fromJson(jsonDecode(json));

  factory JsonUpdate.fromJson(Map<String, dynamic> json) =>
      _$JsonUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$JsonUpdateToJson(this);
}
