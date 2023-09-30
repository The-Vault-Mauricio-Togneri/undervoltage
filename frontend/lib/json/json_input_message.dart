import 'dart:convert';
import 'package:idlebattle/json/json_match_configuration.dart';
import 'package:idlebattle/json/json_match_status.dart';
import 'package:idlebattle/types/finish_state.dart';
import 'package:idlebattle/types/input_event.dart';
import 'package:json_annotation/json_annotation.dart';

part 'json_input_message.g.dart';

@JsonSerializable()
class JsonInputMessage {
  final InputEvent event;
  final String? playerName;
  final String? matchId;
  final int? laneId;
  final int? amount;
  final int? direction;
  final int? attackLevel;
  final FinishState? finishState;
  final JsonMatchStatus? matchStatus;
  final JsonMatchConfiguration? configuration;

  const JsonInputMessage({
    required this.event,
    this.playerName,
    this.matchId,
    this.laneId,
    this.amount,
    this.direction,
    this.attackLevel,
    this.finishState,
    this.matchStatus,
    this.configuration,
  });

  factory JsonInputMessage.fromString(String json) => JsonInputMessage.fromJson(jsonDecode(json));

  factory JsonInputMessage.fromJson(Map<String, dynamic> json) => _$JsonInputMessageFromJson(json);

  Map<String, dynamic> toJson() => _$JsonInputMessageToJson(this);
}
