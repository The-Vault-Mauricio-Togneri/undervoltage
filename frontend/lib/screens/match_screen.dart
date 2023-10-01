import 'dart:async';
import 'package:dafluta/dafluta.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:undervoltage/services/palette.dart';
import 'package:undervoltage/widgets/base_screen.dart';
import 'package:undervoltage/widgets/label.dart';

class MatchScreen extends StatelessWidget {
  final LobbyState state;

  const MatchScreen._(this.state);

  factory MatchScreen.instance({required String matchId}) =>
      MatchScreen._(LobbyState(matchId: matchId));

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: StateProvider<LobbyState>(
        state: state,
        builder: (context, state) => Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Label(
                  text: state.matchId,
                  color: Palette.grey,
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LobbyState extends BaseState {
  final String matchId;
  DatabaseReference? matchRef;
  StreamSubscription? subscription;

  LobbyState({required this.matchId});

  @override
  void onLoad() {
    super.onLoad();

    matchRef = FirebaseDatabase.instance.ref('matches/$matchId');
    subscription = matchRef!.onValue.listen((event) {
      final Map<Object?, Object?>? data =
          event.snapshot.value as Map<Object?, Object?>?;

      if (data != null) {
        onMatchUpdated(data);
      }
    });
  }

  /*Future onPutCard() async {
    ref?.update({
      'counter': localCounter++,
    });
  }*/

  void onMatchUpdated(Map<Object?, Object?> data) {
    print(data);
  }

  @override
  void onDestroy() {
    super.onDestroy();

    subscription?.cancel();
  }
}
