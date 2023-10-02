import 'dart:async';
import 'dart:convert';
import 'package:dafluta/dafluta.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:undervoltage/json/json_match.dart';
import 'package:undervoltage/services/palette.dart';
import 'package:undervoltage/types/match_status.dart';
import 'package:undervoltage/widgets/base_screen.dart';
import 'package:undervoltage/widgets/label.dart';

class MatchScreen extends StatelessWidget {
  final MatchState state;

  const MatchScreen._(this.state);

  factory MatchScreen.instance({required JsonMatch match}) =>
      MatchScreen._(MatchState(match: match));

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: StateProvider<MatchState>(
        state: state,
        builder: (context, state) => _child(state),
      ),
    );
  }

  Widget _child(MatchState state) {
    if (state.isWaitingForPlayers) {
      return WaitingForPlayers(state);
    } else if (state.isPlaying) {
      return Started(state);
    } else {
      return const Empty();
    }
  }
}

class WaitingForPlayers extends StatelessWidget {
  final MatchState state;

  const WaitingForPlayers(this.state);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Label(
        text:
            'Waiting for players: ${state.playersJoined}/${state.numberOfPlayers}',
        color: Palette.grey,
        size: 14,
      ),
    );
  }
}

class Started extends StatelessWidget {
  final MatchState state;

  const Started(this.state);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Label(
        text: 'Playing',
        color: Palette.grey,
        size: 14,
      ),
    );
  }
}

class MatchState extends BaseState {
  late final DatabaseReference matchRef;
  late final StreamSubscription subscription;
  JsonMatch match;

  MatchState({required this.match});

  bool get isWaitingForPlayers => match.status == MatchStatus.waitingForPlayers;

  bool get isPlaying => match.status == MatchStatus.playing;

  int get numberOfPlayers => match.numberOfPlayers;

  int get playersJoined => match.playersJoined;

  @override
  void onLoad() {
    super.onLoad();

    matchRef = FirebaseDatabase.instance.ref('matches/${match.id}');
    subscription = matchRef.onValue.listen((event) {
      final json = jsonEncode(event.snapshot.value);
      match = JsonMatch.fromJson(jsonDecode(json));
      onMatchUpdated(match);
    });
  }

  /*Future onPutCard() async {
    ref?.update({
      'counter': localCounter++,
    });
  }*/

  void onMatchUpdated(JsonMatch match) {
    print(match);
    notify();
  }

  @override
  void onDestroy() {
    super.onDestroy();

    subscription.cancel();
  }
}
