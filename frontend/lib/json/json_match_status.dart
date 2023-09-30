import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:undervoltage/json/json_lane.dart';
import 'package:undervoltage/json/json_player_status.dart';

part 'json_match_status.g.dart';

@JsonSerializable()
class JsonMatchStatus {
  final String id;
  final double remainingTime;
  final List<JsonPlayerStatus> players;
  final List<JsonLane> lanes;

  const JsonMatchStatus({
    required this.id,
    required this.remainingTime,
    required this.players,
    required this.lanes,
  });

  JsonPlayerStatus get self {
    for (final JsonPlayerStatus player in players) {
      if (player.isSelf) {
        return player;
      }
    }

    throw Error();
  }

  JsonPlayerStatus get enemy {
    for (final JsonPlayerStatus player in players) {
      if (!player.isSelf) {
        return player;
      }
    }

    throw Error();
  }

  factory JsonMatchStatus.fromString(String json) => JsonMatchStatus.fromJson(jsonDecode(json));

  factory JsonMatchStatus.fromJson(Map<String, dynamic> json) => _$JsonMatchStatusFromJson(json);

  Map<String, dynamic> toJson() => _$JsonMatchStatusToJson(this);
}
