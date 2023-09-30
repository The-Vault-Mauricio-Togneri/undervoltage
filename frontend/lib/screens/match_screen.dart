import 'dart:async';
import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:undervoltage/dialogs/info_dialog.dart';
import 'package:undervoltage/json/json_input_message.dart';
import 'package:undervoltage/json/json_match_status.dart';
import 'package:undervoltage/json/json_output_message.dart';
import 'package:undervoltage/models/lane.dart';
import 'package:undervoltage/models/match.dart';
import 'package:undervoltage/models/units.dart';
import 'package:undervoltage/services/audio.dart';
import 'package:undervoltage/services/connection.dart';
import 'package:undervoltage/services/date_formatter.dart';
import 'package:undervoltage/services/localizations.dart';
import 'package:undervoltage/services/navigation.dart';
import 'package:undervoltage/services/palette.dart';
import 'package:undervoltage/types/finish_state.dart';
import 'package:undervoltage/types/input_event.dart';
import 'package:undervoltage/widgets/game_container.dart';

class MatchScreen extends StatelessWidget {
  final MatchState state;

  const MatchScreen._(this.state);

  factory MatchScreen.instance({required Match match}) => MatchScreen._(MatchState(match));

  @override
  Widget build(BuildContext context) {
    return GameContainer(
      child: StateProvider<MatchState>(
        state: state,
        builder: (context, state) => Content(state),
      ),
    );
  }
}

class Content extends StatelessWidget {
  final MatchState state;

  const Content(this.state);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EnemyTab(state),
        Board(state),
        PlayerTab(state),
        GameLoop(state),
      ],
    );
  }
}

class EnemyTab extends StatelessWidget {
  final MatchState state;

  const EnemyTab(this.state);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: state.match.enemy.tabColor,
      child: Column(
        children: [
          Center(
            child: CountdownIndicator(state.match.remainingTime),
          ),
          Stack(
            children: [
              Score(state.match.enemy.points),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    state.match.enemy.name,
                    style: const TextStyle(
                      color: Palette.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    '${state.match.enemyPercentage}%',
                    style: const TextStyle(
                      color: Palette.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CountdownIndicator extends StatelessWidget {
  final double remainingTime; // in seconds

  const CountdownIndicator(this.remainingTime);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: Text(
        DateFormatter.time(remainingTime.toInt()),
        style: TextStyle(
          color: (remainingTime >= 30) ? Palette.white : Palette.black,
          fontWeight: (remainingTime >= 30) ? FontWeight.normal : FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }
}

class Score extends StatelessWidget {
  final int value;

  const Score(this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        value.toString(),
        style: const TextStyle(
          color: Palette.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class Board extends StatelessWidget {
  final MatchState state;

  const Board(this.state);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: LaneContainer(
              lane: state.match.lanes[0],
              state: state,
            ),
          ),
          const VerticalLine(),
          Expanded(
            child: LaneContainer(
              lane: state.match.lanes[1],
              state: state,
            ),
          ),
          const VerticalLine(),
          Expanded(
            child: LaneContainer(
              lane: state.match.lanes[2],
              state: state,
            ),
          ),
          const VerticalLine(),
          Expanded(
            child: LaneContainer(
              lane: state.match.lanes[3],
              state: state,
            ),
          ),
          const VerticalLine(),
          Expanded(
            child: LaneContainer(
              lane: state.match.lanes[4],
              state: state,
            ),
          ),
        ],
      ),
    );
  }
}

class VerticalLine extends StatelessWidget {
  const VerticalLine();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.white,
      width: 0.1,
    );
  }
}

class LaneContainer extends StatefulWidget {
  final Lane lane;
  final MatchState state;

  const LaneContainer({required this.lane, required this.state});

  @override
  State<LaneContainer> createState() => _LaneContainerState();
}

class _LaneContainerState extends State<LaneContainer> {
  bool isPressed = false;
  Timer? timer;

  Color get color =>
      widget.state.match.canBuyUnit ? (isPressed ? widget.state.match.self.launcherColor50 : widget.state.match.self.launcherColor) : Palette.grey;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: LaneColumn(widget.lane, widget.state),
        ),
        if (widget.lane.enabled)
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Listener(
              onPointerDown: (details) => _onTapDown(),
              onPointerUp: (details) => _onTapUp(),
              onPointerCancel: (details) => _onTapCancel(),
              child: Container(
                color: color,
                width: double.infinity,
                child: const Padding(
                  padding: EdgeInsets.all(20),
                  child: Icon(
                    Icons.keyboard_arrow_up,
                    color: Palette.white,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _onTapDown() {
    setState(() {
      isPressed = true;
    });
    _checkBuyUnit();
    timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      _checkBuyUnit();
    });
  }

  void _checkBuyUnit() {
    if (widget.state.match.canBuyUnits(widget.lane.accumulatedUnits + 1)) {
      widget.lane.accumulatedUnits++;

      if (widget.lane.accumulatedUnits > 1) {
        Audio.get.playSound(Audio.SOUND_ACCUMULATE_UNITS);
      }
    }
  }

  void _onTapUp() {
    setState(() {
      timer?.cancel();
      isPressed = false;
    });

    if (widget.lane.enabled && (widget.lane.accumulatedUnits > 0)) {
      widget.state.launch(widget.lane);
    }

    widget.lane.accumulatedUnits = 0;
  }

  void _onTapCancel() {
    setState(() {
      timer?.cancel();
      isPressed = false;
    });
    widget.lane.accumulatedUnits = 0;
  }
}

class LaneColumn extends StatelessWidget {
  final Lane lane;
  final MatchState state;

  const LaneColumn(this.lane, this.state);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        LayoutBuilder(
          builder: (context, constraints) => CustomPaint(
            size: Size(constraints.maxWidth, constraints.maxHeight),
            painter: LanePainter(lane: lane, state: state),
          ),
        ),
        if (lane.enabled && (lane.accumulatedUnits > 1))
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                '${lane.accumulatedUnits}',
                style: const TextStyle(
                  color: Palette.white,
                  fontSize: 20,
                ),
              ),
            ),
          )
      ],
    );
  }
}

class LanePainter extends CustomPainter {
  final Lane lane;
  final MatchState state;

  const LanePainter({
    required this.lane,
    required this.state,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double wallPosition = state.match.wallPosition(lane.wall, size.height);

    _background(
      color: (lane.enabled) ? state.match.enemy.laneColorActive : state.match.enemy.laneColorInactive,
      top: 0,
      height: wallPosition,
      width: size.width,
      canvas: canvas,
    );

    _background(
      color: (lane.enabled) ? state.match.self.laneColorActive : state.match.self.laneColorInactive,
      top: wallPosition,
      height: size.height - wallPosition,
      width: size.width,
      canvas: canvas,
    );

    if (lane.enabled) {
      if (lane.rewardEnabled) {
        _dottedLine(
          height: size.height * 1 / 4,
          width: size.width,
          canvas: canvas,
        );

        _dottedLine(
          height: size.height * 3 / 4,
          width: size.width,
          canvas: canvas,
        );
      }

      _wall(
        top: wallPosition,
        height: 2,
        width: size.width,
        canvas: canvas,
      );

      for (final Units units in lane.units) {
        final double distance = size.height * units.progress;
        final double position = units.isSelf ? size.height - distance : distance;

        _units(
          amount: units.amount,
          color: units.unitColor,
          top: position,
          width: size.width,
          canvas: canvas,
        );
      }
    }
  }

  void _dottedLine({
    required double height,
    required double width,
    required Canvas canvas,
  }) {
    final Paint paint = Paint();
    paint.color = Palette.white50;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 0.5;

    const int parts = 20;
    final double lineWidth = width / parts;

    for (int i = 0; i < parts; i += 2) {
      final Rect rect = Rect.fromLTWH(
        lineWidth * i,
        height,
        lineWidth,
        0,
      );
      canvas.drawRect(rect, paint);
    }
  }

  void _background({
    required Color color,
    required double top,
    required double height,
    required double width,
    required Canvas canvas,
  }) {
    final Paint paint = Paint();
    paint.color = color;
    paint.style = PaintingStyle.fill;

    final Rect rect = Rect.fromLTWH(
      0,
      top,
      width,
      height,
    );
    canvas.drawRect(rect, paint);
  }

  void _wall({
    required double top,
    required double width,
    required double height,
    required Canvas canvas,
  }) =>
      _background(
        color: Palette.white,
        top: top,
        height: height,
        width: width,
        canvas: canvas,
      );

  void _units({
    required int amount,
    required Color color,
    required double top,
    required double width,
    required Canvas canvas,
  }) {
    final double height = amount * 2;

    _background(
      color: color,
      top: top,
      height: height,
      width: width,
      canvas: canvas,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PlayerTab extends StatelessWidget {
  final MatchState state;

  const PlayerTab(this.state);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: state.match.self.tabColor,
      child: Column(
        children: [
          Stack(
            children: [
              Score(state.match.self.points),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    '\$${state.match.money.toInt()}',
                    style: const TextStyle(
                      color: Palette.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    '${state.match.selfPercentage}%',
                    style: const TextStyle(
                      color: Palette.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TabButton(
                  icon: Icons.attach_money,
                  value: state.match.mineLevel,
                  enabled: state.match.canUpgradeMine,
                  onTap: state.upgradeMine,
                ),
              ),
              Expanded(
                child: TabButton(
                  icon: Icons.add,
                  value: state.match.attackLevel,
                  onTap: state.upgradeAttack,
                  enabled: state.match.canUpgradeUnits,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TabButton extends StatelessWidget {
  final IconData icon;
  final int value;
  final bool enabled;
  final VoidCallback onTap;

  const TabButton({
    required this.icon,
    required this.value,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: enabled ? Palette.transparent : Palette.grey,
      child: Material(
        color: Palette.transparent,
        child: InkWell(
          onTap: enabled ? onTap : null,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Icon(
                  icon,
                  color: Palette.white,
                ),
                const VBox(5),
                Text(
                  '$value',
                  style: const TextStyle(
                    color: Palette.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GameLoop extends StatefulWidget {
  final MatchState state;

  const GameLoop(this.state);

  @override
  State<GameLoop> createState() => _GameLoopState();
}

class _GameLoopState extends State<GameLoop> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final DateTime _initialTime = DateTime.now();
  double previous = 0;
  double get currentTime => DateTime.now().difference(_initialTime).inMilliseconds / 1000.0;

  @override
  void initState() {
    super.initState();
    previous = currentTime;
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat();
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final double current = currentTime;
        final double dt = current - previous;
        widget.state.update(dt);
        previous = current;

        return const Empty();
      },
    );
  }
}

class MatchState extends BaseState {
  final Match match;
  late final Connection connection;
  late final StreamSubscription streamSubscription;

  MatchState(this.match);

  @override
  void onLoad() {
    connection = Connection.get;
    streamSubscription = connection.listenMessage(_processMessage);

    Audio.get.playMusic(Audio.MUSIC_MATCH);
  }

  void _processMessage(JsonInputMessage message) {
    switch (message.event) {
      case InputEvent.MATCH_UPDATE:
        _onMatchUpdate(message.matchStatus!);
        break;
      case InputEvent.UNITS_LAUNCHED:
        _onUnitsLaunched(message.laneId!, message.amount!, message.direction!, message.attackLevel!);
        break;
      case InputEvent.MATCH_FINISHED:
        _onMatchFinished(message.finishState!);
        break;
      case InputEvent.PLAYER_DISCONNECTED:
        _onPlayerDisconnected(message.playerName!);
        break;
      case InputEvent.LANE_REWARD_WON:
        Audio.get.playSound(Audio.SOUND_LANE_REWARD_WON);
        break;
      case InputEvent.LANE_REWARD_LOST:
        Audio.get.playSound(Audio.SOUND_LANE_REWARD_LOST);
        break;
      case InputEvent.LANE_WON:
        Audio.get.playSound(Audio.SOUND_LANE_WON);
        break;
      case InputEvent.LANE_LOST:
        Audio.get.playSound(Audio.SOUND_LANE_LOST);
        break;
      default:
    }
  }

  void _onMatchUpdate(JsonMatchStatus matchStatus) {
    match.updateMatch(matchStatus);
    notify();
  }

  void _onUnitsLaunched(int laneId, int amount, int direction, int attackLevel) => match.launch(
        laneId: laneId,
        amount: amount,
        direction: direction,
        attackLevel: attackLevel,
        timeOffset: match.latency,
      );

  void _onMatchFinished(FinishState finishState) {
    match.running = false;

    Audio.get.stopMusic();

    switch (finishState) {
      case FinishState.WON:
        Audio.get.playSound(Audio.SOUND_MATCH_WON);
        InfoDialog.show(text: Localized.get.dialogWon, onAccept: Navigation.pop);
        break;
      case FinishState.LOST:
        Audio.get.playSound(Audio.SOUND_MATCH_LOST);
        InfoDialog.show(text: Localized.get.dialogLost, onAccept: Navigation.pop);
        break;
      case FinishState.TIE:
        Audio.get.playSound(Audio.SOUND_MATCH_TIE);
        InfoDialog.show(text: Localized.get.dialogTie, onAccept: Navigation.pop);
        break;
    }
  }

  void _onPlayerDisconnected(String playerName) {
    if (match.running) {
      match.running = false;
      Audio.get.stopMusic();
      Audio.get.playSound(Audio.SOUND_PLAYER_DISCONNECTED);

      Delayed.post(
        () => InfoDialog.show(
          text: Localized.get.dialogDisconnected(playerName),
          onAccept: Navigation.pop,
        ),
      );
    }
  }

  void update(double dt) {
    if (match.running) {
      match.update(dt);
      Delayed.post(notify);
    }
  }

  void upgradeMine() {
    connection.send(JsonOutputMessage.increaseMine(match.id));
    match.upgradeMine();
    notify();
  }

  void upgradeAttack() {
    connection.send(JsonOutputMessage.increaseAttack(match.id));
    match.upgradeAttack();
    notify();
  }

  void launch(Lane lane) {
    match.buyUnits(lane.accumulatedUnits);
    connection.send(JsonOutputMessage.launchUnits(
      match.id,
      lane.id,
      lane.accumulatedUnits,
    ));
  }

  @override
  void onDestroy() {
    Audio.get.stopMusic();
    connection.send(JsonOutputMessage.disconnect());
    streamSubscription.cancel();

    super.onDestroy();
  }
}
