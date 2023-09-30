import 'package:flutter/material.dart';
import 'package:idlebattle/json/json_player_status.dart';
import 'package:idlebattle/services/palette.dart';

class Player {
  final String name;
  final int direction;
  final bool isSelf;
  int points = 0;

  Player({
    required this.name,
    required this.direction,
    required this.isSelf,
  });

  void update(JsonPlayerStatus playerStatus) {
    points = playerStatus.points;
  }

  Color get laneColorActive => isSelf ? Palette.laneActiveBlue : Palette.laneActiveRed;

  Color get laneColorInactive => isSelf ? Palette.laneInactiveBlue : Palette.laneInactiveRed;

  Color get tabColor => isSelf ? Palette.tabBlue : Palette.tabRed;

  Color get launcherColor => isSelf ? Palette.launcherBlue : Palette.launcherRed;

  Color get launcherColor50 => launcherColor.withAlpha(128);
}
