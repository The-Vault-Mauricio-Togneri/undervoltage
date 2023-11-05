import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'json_increase_fault.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonIncreaseFault {
  @JsonKey(name: 'playerId')
  final String playerId;

  const JsonIncreaseFault({
    required this.playerId,
  });

  factory JsonIncreaseFault.fromString(String json) =>
      JsonIncreaseFault.fromJson(jsonDecode(json));

  factory JsonIncreaseFault.fromJson(Map<String, dynamic> json) =>
      _$JsonIncreaseFaultFromJson(json);

  Map<String, dynamic> toJson() => _$JsonIncreaseFaultToJson(this);
}
