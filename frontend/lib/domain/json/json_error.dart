import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'json_error.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonError {
  @JsonKey(name: 'message')
  final String message;

  const JsonError({
    required this.message,
  });

  factory JsonError.fromString(String json) =>
      JsonError.fromJson(jsonDecode(json));

  factory JsonError.fromJson(Map<String, dynamic> json) =>
      _$JsonErrorFromJson(json);

  Map<String, dynamic> toJson() => _$JsonErrorToJson(this);
}
