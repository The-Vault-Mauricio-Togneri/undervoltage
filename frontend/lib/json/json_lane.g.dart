// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_lane.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonLane _$JsonLaneFromJson(Map<String, dynamic> json) => JsonLane(
      enabled: json['enabled'] as bool,
      rewardEnabled: json['rewardEnabled'] as bool,
      wall: (json['wall'] as num).toDouble(),
    );

Map<String, dynamic> _$JsonLaneToJson(JsonLane instance) => <String, dynamic>{
      'enabled': instance.enabled,
      'rewardEnabled': instance.rewardEnabled,
      'wall': instance.wall,
    };
