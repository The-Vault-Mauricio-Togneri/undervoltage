import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:undervoltage/domain/state/lobby/lobby_state.dart';
import 'package:undervoltage/utils/palette.dart';
import 'package:undervoltage/widgets/base_screen.dart';
import 'package:undervoltage/widgets/label.dart';
import 'package:undervoltage/widgets/primary_button.dart';

class LobbyScreen extends StatelessWidget {
  final LobbyState state;

  const LobbyScreen._(this.state);

  factory LobbyScreen.instance({
    required String matchType,
    required int numberOfPlayers,
  }) =>
      LobbyScreen._(LobbyState(matchType, numberOfPlayers));

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: BaseScreen(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const VBox(20),
              const Label(
                text: 'Waiting for players…',
                color: Palette.black,
                size: 14,
              ),
              const VBox(50),
              PrimaryButton(
                text: 'CANCEL',
                icon: Icons.close,
                backgroundColor: Palette.red,
                onPressed: state.onLeave,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
