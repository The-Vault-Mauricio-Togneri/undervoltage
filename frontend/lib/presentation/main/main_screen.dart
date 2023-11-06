import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:undervoltage/build/build_version.dart';
import 'package:undervoltage/domain/models/game/player.dart';
import 'package:undervoltage/domain/models/game/summary.dart';
import 'package:undervoltage/domain/state/main/main_state.dart';
import 'package:undervoltage/domain/types/player_status.dart';
import 'package:undervoltage/presentation/match/match_screen.dart';
import 'package:undervoltage/utils/palette.dart';
import 'package:undervoltage/widgets/base_screen.dart';
import 'package:undervoltage/widgets/label.dart';
import 'package:undervoltage/widgets/primary_button.dart';

class MainScreen extends StatelessWidget {
  final MainState state;

  const MainScreen._(this.state);

  factory MainScreen.instance() => MainScreen._(MainState());

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Header(state),
          const Spacer(),
          SummaryTable([
            Summary(points: {
              'p1': 12,
              'p2': 34,
              'p3': 56,
            }),
            Summary(points: {
              'p1': 11,
              'p2': 22,
              'p3': 33,
            }),
            Summary(points: {
              'p1': 44,
              'p2': 55,
              'p3': 66,
            })
          ], {
            'p1': Player(
              id: 'p1',
              name: 'Player 1',
              status: PlayerStatus.playing,
              points: 67,
            ),
            'p2': Player(
              id: 'p2',
              name: 'Player 2',
              status: PlayerStatus.playing,
              points: 111,
            ),
            'p3': Player(
              id: 'p3',
              name: 'Player 3',
              status: PlayerStatus.playing,
              points: 155,
            ),
          }, 140),
          Content(state),
          const Spacer(),
          const Footer(),
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  final MainState state;

  const Header(this.state);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: IconButton(
        onPressed: state.onSettings,
        icon: const Icon(
          Icons.settings,
          color: Palette.grey,
          size: 25,
        ),
      ),
    );
  }
}

class Content extends StatelessWidget {
  final MainState state;

  const Content(this.state);

  @override
  Widget build(BuildContext context) {
    return StateProvider<MainState>(
      state: state,
      builder: (context, state) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ToggleButtons(
              direction: Axis.horizontal,
              onPressed: state.onSelectPlayers,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              selectedBorderColor: Colors.blue[500],
              selectedColor: Colors.white,
              fillColor: Colors.blue[200],
              color: Colors.blue[400],
              isSelected: state.selectedPlayers,
              children: const [
                PlayerSelectorEntry('2 Players'),
                PlayerSelectorEntry('3 Players'),
                PlayerSelectorEntry('4 Players'),
              ],
            ),
            const VBox(20),
            PrimaryButton(
              text: 'Play',
              icon: Icons.bolt,
              onPressed: state.onMatchmaking,
            ),
          ],
        ),
      ),
    );
  }
}

class PlayerSelectorEntry extends StatelessWidget {
  final String text;

  const PlayerSelectorEntry(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 5,
        bottom: 5,
        left: 15,
        right: 15,
      ),
      child: Text(text),
    );
  }
}

class Footer extends StatelessWidget {
  const Footer();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Label(
        text: 'Version $BUILD_VERSION',
        color: Palette.grey,
        size: 14,
      ),
    );
  }
}
