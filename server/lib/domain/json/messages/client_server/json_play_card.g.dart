// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_play_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonPlayCard _$JsonPlayCardFromJson(Map<String, dynamic> json) => JsonPlayCard(
      roomId: json['roomId'] as String,
      cardId: json['cardId'] as String,
      playerId: json['playerId'] as String,
    );

Map<String, dynamic> _$JsonPlayCardToJson(JsonPlayCard instance) =>
    <String, dynamic>{
      'roomId': instance.roomId,
      'cardId': instance.cardId,
      'playerId': instance.playerId,
    };
