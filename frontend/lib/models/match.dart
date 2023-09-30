import 'package:idlebattle/app/constants.dart';
import 'package:idlebattle/json/json_lane.dart';
import 'package:idlebattle/json/json_match_configuration.dart';
import 'package:idlebattle/json/json_match_status.dart';
import 'package:idlebattle/json/json_player_status.dart';
import 'package:idlebattle/models/lane.dart';
import 'package:idlebattle/models/player.dart';
import 'package:idlebattle/models/units.dart';
import 'package:idlebattle/services/audio.dart';

class Match {
  bool running = true;
  double money;
  int mineLevel;
  int attackLevel;
  double remainingTime;
  double latency = 0;
  bool warning30Seconds = false;
  int nextWarningCountdown = 10;

  final JsonMatchConfiguration configuration;
  final String id;
  final Player self;
  final Player enemy;
  final List<Lane> lanes = [];

  Match._({
    required this.id,
    required this.self,
    required this.enemy,
    required this.money,
    required this.mineLevel,
    required this.attackLevel,
    required this.remainingTime,
    required this.configuration,
  }) {
    for (int i = 0; i < configuration.lanes; i++) {
      lanes.add(
        Lane(
          id: i,
          unitSpeed: configuration.unitSpeed,
        ),
      );
    }
  }

  factory Match.create({
    required JsonMatchStatus matchStatus,
    required JsonMatchConfiguration configuration,
  }) {
    final JsonPlayerStatus self = matchStatus.self;
    final JsonPlayerStatus enemy = matchStatus.enemy;

    return Match._(
      id: matchStatus.id,
      self: self.player,
      enemy: enemy.player,
      money: self.money!.toDouble(),
      mineLevel: self.mineLevel!,
      attackLevel: self.attackLevel!,
      remainingTime: configuration.matchTimeout.toDouble(),
      configuration: configuration,
    );
  }

  bool get canUpgradeMine => money >= costOfUpgradingMine;

  bool get canUpgradeUnits => money >= costOfUpgradingAttack;

  bool get canBuyUnit => money >= configuration.unitCost;

  int get costOfUpgradingMine => mineLevel * configuration.mineCostMultiplier;

  int get costOfUpgradingAttack => attackLevel * configuration.attackCostMultiplier;

  int get selfPercentage => _selfPercentage;

  int get enemyPercentage => 100 - _selfPercentage;

  int get _selfPercentage {
    double sum = 0;

    for (final Lane lane in lanes) {
      sum += lane.percentage(self.direction);
    }

    return ((sum / lanes.length) * 100).round();
  }

  bool canBuyUnits(int amount) => money >= (amount * configuration.unitCost);

  double wallPosition(double wall, double height) {
    if (self.direction == Constants.DIRECTION_UP) {
      return height - (wall * height);
    } else if (self.direction == Constants.DIRECTION_DOWN) {
      return wall * height;
    } else {
      return 0;
    }
  }

  void updateMatch(JsonMatchStatus matchStatus) {
    for (int i = 0; i < matchStatus.lanes.length; i++) {
      final JsonLane jsonLane = matchStatus.lanes[i];
      final Lane lane = lanes[i];
      lane.updateLane(jsonLane);
    }

    remainingTime = matchStatus.remainingTime;

    final int selfPoints = self.points;
    final int enemyPoints = enemy.points;

    self.update(matchStatus.self);
    enemy.update(matchStatus.enemy);

    if (self.points > selfPoints) {
      Audio.get.playSound(Audio.SOUND_LANE_WON);
    }

    if (enemy.points > enemyPoints) {
      Audio.get.playSound(Audio.SOUND_LANE_LOST);
    }

    final JsonPlayerStatus jsonSelf = matchStatus.self;
    money = jsonSelf.money!.toDouble();
    mineLevel = jsonSelf.mineLevel!;
    attackLevel = jsonSelf.attackLevel!;
  }

  void update(double dt) {
    remainingTime -= dt;

    _checkWarning30Seconds();
    _checkWarningCountdown();

    for (final Lane lane in lanes) {
      lane.update(dt);
    }

    money += mineLevel * configuration.moneyRate * dt;
  }

  void _checkWarning30Seconds() {
    if (!warning30Seconds && remainingTime.toInt() == 30) {
      warning30Seconds = true;
      Audio.get.playSound(Audio.SOUND_WARNING_30_SECONDS);
    }
  }

  void _checkWarningCountdown() {
    if ((remainingTime >= 0) && (remainingTime.toInt() <= nextWarningCountdown)) {
      nextWarningCountdown--;
      Audio.get.playSound(Audio.SOUND_COUNTDOWN);
    }
  }

  void upgradeMine() {
    final int cost = costOfUpgradingMine;

    if (money >= cost) {
      money -= cost;
      mineLevel++;

      Audio.get.playSound(Audio.SOUND_INCREASE_MINE);
    }
  }

  void upgradeAttack() {
    final int cost = costOfUpgradingAttack;

    if (money >= cost) {
      money -= cost;
      attackLevel++;

      Audio.get.playSound(Audio.SOUND_INCREASE_ATTACK);
    }
  }

  void buyUnits(int amount) {
    final int totalCost = configuration.unitCost * amount;

    if (money >= totalCost) {
      money -= totalCost;
    }
  }

  void launch({
    required int laneId,
    required int amount,
    required int direction,
    required int attackLevel,
    required double timeOffset,
  }) {
    final Lane lane = lanes[laneId];

    lane.launch(Units(
      isSelf: direction == self.direction,
      amount: amount,
      damagePerUnit: configuration.unitBaseDamage * attackLevel,
      direction: direction,
      unitSpeed: configuration.unitSpeed,
      blockMultiplier: configuration.blockMultiplier,
      timeOffset: timeOffset,
    ));

    Audio.get.playSound(Audio.SOUND_UNITS_LAUNCHED);
  }
}
