import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'json_welcome.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonWelcome {
  const JsonWelcome();

  factory JsonWelcome.fromString(String json) =>
      JsonWelcome.fromJson(jsonDecode(json));

  factory JsonWelcome.fromJson(Map<String, dynamic> json) =>
      _$JsonWelcomeFromJson(json);

  Map<String, dynamic> toJson() => _$JsonWelcomeToJson(this);
}
