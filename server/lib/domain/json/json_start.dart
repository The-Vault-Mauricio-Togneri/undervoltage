import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'json_start.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonStart {
  const JsonStart();

  factory JsonStart.fromString(String json) =>
      JsonStart.fromJson(jsonDecode(json));

  factory JsonStart.fromJson(Map<String, dynamic> json) =>
      _$JsonStartFromJson(json);

  Map<String, dynamic> toJson() => _$JsonStartToJson(this);
}
