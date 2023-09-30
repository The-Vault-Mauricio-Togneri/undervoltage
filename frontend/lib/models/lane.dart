import 'package:idlebattle/app/constants.dart';
import 'package:idlebattle/json/json_lane.dart';
import 'package:idlebattle/models/units.dart';
import 'package:idlebattle/services/audio.dart';

class Lane {
  final int id;
  final double unitSpeed;
  final List<Units> units = [];
  bool enabled = true;
  bool rewardEnabled = true;
  double wall = 0.5;
  double force = 0;
  int accumulatedUnits = 0;

  Lane({
    required this.id,
    required this.unitSpeed,
  });

  double percentage(int direction) {
    if (direction == Constants.DIRECTION_UP) {
      return wall;
    } else if (direction == Constants.DIRECTION_DOWN) {
      return 1 - wall;
    } else {
      return 0;
    }
  }

  void update(double dt) {
    if (enabled) {
      final List<Units> unitsAlive = [];

      for (final Units units in units) {
        units.update(dt);

        if (units.direction == Constants.DIRECTION_UP) {
          if (units.progress >= wall) {
            force += units.totalDamage;
            Audio.get.playSound(Audio.SOUND_WALL_CRASH);
          } else {
            unitsAlive.add(units);
          }
        } else if (units.direction == Constants.DIRECTION_DOWN) {
          if (units.progress >= (1 - wall)) {
            force -= units.totalDamage;
            Audio.get.playSound(Audio.SOUND_WALL_CRASH);
          } else {
            unitsAlive.add(units);
          }
        }
      }

      if (rewardEnabled) {
        if (wall >= 0.75) {
          rewardEnabled = false;
        } else if (wall <= 0.25) {
          rewardEnabled = false;
        }
      }

      if (wall >= 1) {
        wall = 1;
        enabled = false;
        units.clear();
      } else if (wall <= 0) {
        wall = 0;
        enabled = false;
        units.clear();
      } else {
        if (force != 0) {
          final double distance = dt * force.sign * unitSpeed;

          if (force.abs() > distance.abs()) {
            wall += distance;
            force -= distance;
          } else {
            wall += force;
            force = 0;
          }
        }

        units.clear();
        units.addAll(unitsAlive);
      }
    }
  }

  void updateLane(JsonLane json) {
    final bool updateWall = (enabled != json.enabled) || (rewardEnabled != json.rewardEnabled);

    enabled = json.enabled;
    rewardEnabled = json.rewardEnabled;

    if (updateWall) {
      wall = json.wall;
    }
  }

  void launch(Units newUnits) {
    enabled = true;
    units.add(newUnits);
  }
}
