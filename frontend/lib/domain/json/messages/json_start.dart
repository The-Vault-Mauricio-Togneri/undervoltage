import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:undervoltage/domain/json/game/json_match.dart';

part 'json_start.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonStart {
  @JsonKey(name: 'match')
  final JsonMatch match;

  const JsonStart({
    required this.match,
  });

  factory JsonStart.fromString(String json) =>
      JsonStart.fromJson(jsonDecode(json));

  factory JsonStart.fromJson(Map<String, dynamic> json) =>
      _$JsonStartFromJson(json);

  Map<String, dynamic> toJson() => _$JsonStartToJson(this);
}
