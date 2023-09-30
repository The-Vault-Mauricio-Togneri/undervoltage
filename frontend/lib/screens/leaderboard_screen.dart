import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:undervoltage/widgets/game_container.dart';

class LeaderboardScreen extends StatelessWidget {
  final LeaderboardState state = LeaderboardState();

  @override
  Widget build(BuildContext context) {
    return GameContainer(
      child: StateProvider<LeaderboardState>(
        state: state,
        builder: (context, state) => Content(state),
      ),
    );
  }
}

class Content extends StatelessWidget {
  final LeaderboardState state;

  const Content(this.state);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('TODO'),
    );
  }
}

class LeaderboardState extends BaseState {}
