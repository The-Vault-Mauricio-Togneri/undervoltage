import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'json_summary.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonSummary {
  @JsonKey(name: 'points')
  final Map<String, int> points;

  const JsonSummary({
    required this.points,
  });

  factory JsonSummary.fromString(String json) =>
      JsonSummary.fromJson(jsonDecode(json));

  factory JsonSummary.fromJson(Map<String, dynamic> json) =>
      _$JsonSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$JsonSummaryToJson(this);
}
