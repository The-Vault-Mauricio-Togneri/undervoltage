// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_match_configuration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonMatchConfiguration _$JsonMatchConfigurationFromJson(Map<String, dynamic> json) => JsonMatchConfiguration(
      lanes: json['lanes'] as int,
      matchTimeout: json['matchTimeout'] as int,
      moneyRate: json['moneyRate'] as int,
      mineCostMultiplier: json['mineCostMultiplier'] as int,
      attackCostMultiplier: json['attackCostMultiplier'] as int,
      unitCost: json['unitCost'] as int,
      unitSpeed: (json['unitSpeed'] as num).toDouble(),
      unitBaseDamage: (json['unitBaseDamage'] as num).toDouble(),
      blockMultiplier: (json['blockMultiplier'] as num).toDouble(),
    );

Map<String, dynamic> _$JsonMatchConfigurationToJson(JsonMatchConfiguration instance) => <String, dynamic>{
      'lanes': instance.lanes,
      'matchTimeout': instance.matchTimeout,
      'moneyRate': instance.moneyRate,
      'mineCostMultiplier': instance.mineCostMultiplier,
      'attackCostMultiplier': instance.attackCostMultiplier,
      'unitCost': instance.unitCost,
      'unitSpeed': instance.unitSpeed,
      'unitBaseDamage': instance.unitBaseDamage,
      'blockMultiplier': instance.blockMultiplier,
    };
