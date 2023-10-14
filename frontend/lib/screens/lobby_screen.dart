import 'dart:async';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:undervoltage/build/build_version.dart';
import 'package:undervoltage/callables/create_match.dart';
import 'package:undervoltage/callables/join_match.dart';
import 'package:undervoltage/dialogs/info_dialog.dart';
import 'package:undervoltage/dialogs/loading_dialog.dart';
import 'package:undervoltage/json/json_match.dart';
import 'package:undervoltage/services/navigation.dart';
import 'package:undervoltage/services/palette.dart';
import 'package:undervoltage/types/match_status.dart';
import 'package:undervoltage/widgets/base_screen.dart';
import 'package:undervoltage/widgets/custom_form_field.dart';
import 'package:undervoltage/widgets/label.dart';

class LobbyScreen extends StatelessWidget {
  final LobbyState state;

  const LobbyScreen._(this.state);

  factory LobbyScreen.instance({required Uri uri}) =>
      LobbyScreen._(LobbyState(uri: uri));

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: StateProvider<LobbyState>(
        state: state,
        builder: (context, state) => Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Header(state),
            const Spacer(),
            CreateMatchSection(state),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Label(
                text: 'or',
                color: Palette.grey,
                size: 14,
              ),
            ),
            JoinMatchSection(state),
            const Spacer(),
            const Footer(),
          ],
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  final LobbyState state;

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

class CreateMatchSection extends StatelessWidget {
  final LobbyState state;

  const CreateMatchSection(this.state);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 120,
          child: CustomFormField(
            label: 'Players',
            controller: state.numberOfPlayersController,
            inputType: TextInputType.number,
            onTextChanged: state.onCreateMatchInputChanged,
          ),
        ),
        /*const VBox(20),
        SizedBox(
          width: 120,
          child: CustomFormField(
            label: 'Max points',
            controller: state.maxPointsController,
            inputType: TextInputType.number,
            onTextChanged: state.onCreateMatchInputChanged,
          ),
        ),*/
        const VBox(20),
        ElevatedButton(
          onPressed:
              state.createMatchButtonEnabled ? state.onCreateMatch : null,
          child: const Text('CREATE MATCH'),
        ),
      ],
    );
  }
}

class JoinMatchSection extends StatelessWidget {
  final LobbyState state;

  const JoinMatchSection(this.state);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 250,
          child: CustomFormField(
            label: 'Match ID',
            controller: state.matchIdController,
            onTextChanged: state.onJoinMatchInputChanged,
          ),
        ),
        const VBox(20),
        ElevatedButton(
          onPressed: state.joinMatchButtonEnabled ? state.onJoinMatch : null,
          child: const Text('JOIN MATCH'),
        ),
      ],
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

class LobbyState extends BaseState {
  final Uri uri;
  final TextEditingController numberOfPlayersController =
      TextEditingController();
  final TextEditingController maxPointsController = TextEditingController();
  final TextEditingController matchIdController = TextEditingController();
  bool createMatchButtonEnabled = false;
  bool joinMatchButtonEnabled = false;

  LobbyState({required this.uri});

  @override
  void onLoad() {
    super.onLoad();

    final String? matchId = uri.queryParameters['match'];

    if (matchId != null) {
      _joinMatch(matchId);
    }
  }

  void onCreateMatchInputChanged(String text) {
    createMatchButtonEnabled = numberOfPlayersController.text
        .trim()
        .isNotEmpty; // && maxPointsController.text.trim().isNotEmpty;
    notify();
  }

  void onJoinMatchInputChanged(String text) {
    joinMatchButtonEnabled = text.trim().isNotEmpty;
    notify();
  }

  void _clearFields() {
    numberOfPlayersController.text = '';
    maxPointsController.text = '';
    matchIdController.text = '';
    createMatchButtonEnabled = false;
    joinMatchButtonEnabled = false;
    notify();
  }

  Future onCreateMatch() async {
    final DialogController controller =
        LoadingDialog.loading('Creating match...');

    try {
      final HttpsCallableResult result = await const CreateMatch()(
        numberOfPlayers: int.parse(numberOfPlayersController.text),
        maxPoints: 100, // int.parse(maxPointsController.text),
      );
      final String matchId = result.data['matchId'];
      final JsonMatch match =
          JsonMatch.fromId(matchId, MatchStatus.waitingForPlayers);
      controller.close();
      _clearFields();
      Navigation.matchScreen(match);
    } catch (e) {
      controller.close();
      InfoDialog.error(text: e.toString());
      print(e);
    }
  }

  void onJoinMatch() => _joinMatch(matchIdController.text.trim());

  Future _joinMatch(String matchId) async {
    final DialogController controller =
        LoadingDialog.loading('Joining match...');

    try {
      await const JoinMatch()(
        matchId: matchId,
      );
      controller.close();
      final JsonMatch match = JsonMatch.fromId(matchId, MatchStatus.loading);

      _clearFields();
      Navigation.matchScreen(match);
    } catch (e) {
      controller.close();

      if (e is FirebaseFunctionsException) {
        InfoDialog.error(text: e.message!);
      } else {
        InfoDialog.error(text: e.toString());
      }

      print(e);
    }
  }

  void onSettings() => Navigation.setNameScreen(Uri(), false);
}
