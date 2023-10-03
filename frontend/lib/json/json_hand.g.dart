// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_hand.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonHand _$JsonHandFromJson(Map<String, dynamic> json) => JsonHand(
      hiddenPile: (json['hiddenPile'] as List<dynamic>?)
              ?.map((e) => JsonCard.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      revealedPile: (json['revealedPile'] as List<dynamic>?)
              ?.map((e) => JsonCard.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      faults: json['faults'] as int? ?? 0,
    );

Map<String, dynamic> _$JsonHandToJson(JsonHand instance) => <String, dynamic>{
      'hiddenPile': instance.hiddenPile,
      'revealedPile': instance.revealedPile,
      'faults': instance.faults,
    };
