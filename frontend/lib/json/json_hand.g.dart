// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_hand.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonHand _$JsonHandFromJson(Map<String, dynamic> json) => JsonHand(
      hiddenPile: (json['hiddenPile'] as List<dynamic>)
          .map((e) => JsonCard.fromJson(e as Map<String, dynamic>))
          .toList(),
      revealedPile: (json['revealedPile'] as List<dynamic>)
          .map((e) => JsonCard.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$JsonHandToJson(JsonHand instance) => <String, dynamic>{
      'hiddenPile': instance.hiddenPile,
      'revealedPile': instance.revealedPile,
    };
