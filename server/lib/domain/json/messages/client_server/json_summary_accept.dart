import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'json_summary_accept.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonSummaryAccept {
  @JsonKey(name: 'playerId')
  final String playerId;

  const JsonSummaryAccept({
    required this.playerId,
  });

  factory JsonSummaryAccept.fromString(String json) =>
      JsonSummaryAccept.fromJson(jsonDecode(json));

  factory JsonSummaryAccept.fromJson(Map<String, dynamic> json) =>
      _$JsonSummaryAcceptFromJson(json);

  Map<String, dynamic> toJson() => _$JsonSummaryAcceptToJson(this);
}
