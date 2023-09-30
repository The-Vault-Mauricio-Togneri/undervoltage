import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'json_match_configuration.g.dart';

@JsonSerializable()
class JsonMatchConfiguration {
  final int lanes;
  final int matchTimeout; // in seconds
  final int moneyRate;
  final int mineCostMultiplier;
  final int attackCostMultiplier;
  final int unitCost;
  final double unitSpeed;
  final double unitBaseDamage;
  final double blockMultiplier;

  const JsonMatchConfiguration({
    required this.lanes,
    required this.matchTimeout,
    required this.moneyRate,
    required this.mineCostMultiplier,
    required this.attackCostMultiplier,
    required this.unitCost,
    required this.unitSpeed,
    required this.unitBaseDamage,
    required this.blockMultiplier,
  });

  factory JsonMatchConfiguration.fromString(String json) => JsonMatchConfiguration.fromJson(jsonDecode(json));

  factory JsonMatchConfiguration.fromJson(Map<String, dynamic> json) => _$JsonMatchConfigurationFromJson(json);

  Map<String, dynamic> toJson() => _$JsonMatchConfigurationToJson(this);
}
