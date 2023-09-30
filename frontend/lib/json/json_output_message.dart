import 'dart:convert';
import 'package:idlebattle/types/output_event.dart';
import 'package:json_annotation/json_annotation.dart';

part 'json_output_message.g.dart';

@JsonSerializable()
class JsonOutputMessage {
  final OutputEvent event;
  final String? playerName;
  final String? matchId;
  final int? laneId;
  final int? amount;

  const JsonOutputMessage({
    required this.event,
    this.playerName,
    this.matchId,
    this.laneId,
    this.amount,
  });

  factory JsonOutputMessage.joinPublic(String playerName) => JsonOutputMessage(
        event: OutputEvent.JOIN_PUBLIC,
        playerName: playerName,
      );

  factory JsonOutputMessage.createPrivate(String playerName) => JsonOutputMessage(
        event: OutputEvent.CREATE_PRIVATE,
        playerName: playerName,
      );

  factory JsonOutputMessage.joinPrivate(String playerName, String matchId) => JsonOutputMessage(
        event: OutputEvent.JOIN_PRIVATE,
        playerName: playerName,
        matchId: matchId,
      );

  factory JsonOutputMessage.increaseMine(String matchId) => JsonOutputMessage(
        event: OutputEvent.INCREASE_MINE,
        matchId: matchId,
      );

  factory JsonOutputMessage.increaseAttack(String matchId) => JsonOutputMessage(
        event: OutputEvent.INCREASE_ATTACK,
        matchId: matchId,
      );

  factory JsonOutputMessage.launchUnits(String matchId, int laneId, int amount) => JsonOutputMessage(
        event: OutputEvent.LAUNCH_UNITS,
        matchId: matchId,
        laneId: laneId,
        amount: amount,
      );

  factory JsonOutputMessage.echo(String matchId) => JsonOutputMessage(
        event: OutputEvent.ECHO,
        matchId: matchId,
      );

  factory JsonOutputMessage.disconnect() => const JsonOutputMessage(event: OutputEvent.DISCONNECT);

  factory JsonOutputMessage.fromString(String json) => JsonOutputMessage.fromJson(jsonDecode(json));

  factory JsonOutputMessage.fromJson(Map<String, dynamic> json) => _$JsonOutputMessageFromJson(json);

  Map<String, dynamic> toJson() => _$JsonOutputMessageToJson(this);
}
