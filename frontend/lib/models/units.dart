import 'package:flutter/material.dart';
import 'package:idlebattle/services/palette.dart';

class Units {
  final bool isSelf;
  final int amount;
  final double damagePerUnit;
  final int direction;
  final double unitSpeed;
  final double blockMultiplier;
  double progress = 0;
  double timeOffset;

  Units({
    required this.isSelf,
    required this.amount,
    required this.damagePerUnit,
    required this.direction,
    required this.unitSpeed,
    required this.blockMultiplier,
    required this.timeOffset,
  });

  double get totalDamage => amount * ((amount / blockMultiplier) + 1) * damagePerUnit;

  Color get unitColor => isSelf ? Palette.unitBlue : Palette.unitRed;

  void update(double dt) {
    if (timeOffset == 0) {
      progress += dt * unitSpeed;
    } else {
      progress += (dt + timeOffset) * unitSpeed;
      timeOffset = 0;
    }
  }
}
