// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_round.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonRound _$JsonRoundFromJson(Map<String, dynamic> json) => JsonRound(
      playersHand: (json['playersHand'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, JsonHand.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
      discardPile: (json['discardPile'] as List<dynamic>?)
              ?.map((e) => JsonCard.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$JsonRoundToJson(JsonRound instance) => <String, dynamic>{
      'discardPile': instance.discardPile,
      'playersHand': instance.playersHand,
    };
