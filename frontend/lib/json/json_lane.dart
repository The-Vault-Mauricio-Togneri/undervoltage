import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'json_lane.g.dart';

@JsonSerializable()
class JsonLane {
  final bool enabled;
  final bool rewardEnabled;
  final double wall;

  const JsonLane({
    required this.enabled,
    required this.rewardEnabled,
    required this.wall,
  });

  factory JsonLane.fromString(String json) => JsonLane.fromJson(jsonDecode(json));

  factory JsonLane.fromJson(Map<String, dynamic> json) => _$JsonLaneFromJson(json);

  Map<String, dynamic> toJson() => _$JsonLaneToJson(this);
}
