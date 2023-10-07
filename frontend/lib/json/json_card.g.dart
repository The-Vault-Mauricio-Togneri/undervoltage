// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonCard _$JsonCardFromJson(Map<String, dynamic> json) => JsonCard(
      id: json['id'] as String,
      color: json['color'] as String,
      diff: json['diff'] as int,
      value: json['value'] as int,
    );

Map<String, dynamic> _$JsonCardToJson(JsonCard instance) => <String, dynamic>{
      'id': instance.id,
      'color': instance.color,
      'diff': instance.diff,
      'value': instance.value,
    };
