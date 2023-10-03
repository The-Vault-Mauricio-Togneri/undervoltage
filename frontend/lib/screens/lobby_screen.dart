import 'dart:async';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:undervoltage/app/constants.dart';
import 'package:undervoltage/callables/create_match.dart';
import 'package:undervoltage/callables/join_match.dart';
import 'package:undervoltage/dialogs/loading_dialog.dart';
import 'package:undervoltage/json/json_match.dart';
import 'package:undervoltage/services/clipboard_text.dart';
import 'package:undervoltage/services/navigation.dart';
import 'package:undervoltage/services/palette.dart';
import 'package:undervoltage/services/platform.dart';
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
        builder: (context, state) => Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Spacer(),
                ElevatedButton(
                  onPressed: state.onCreateMatch,
                  child: const Text('CREATE MATCH'),
                ),
                const VBox(40),
                const Label(
                  text: 'or',
                  color: Palette.grey,
                  size: 14,
                ),
                const VBox(40),
                CustomFormField(
                  label: 'Match ID',
                  controller: state.matchIdController,
                  onTextChanged: state.onMatchIdInputChanged,
                ),
                const VBox(20),
                ElevatedButton(
                  onPressed:
                      state.joinMatchButtonEnabled ? state.onJoinMatch : null,
                  child: const Text('JOIN MATCH'),
                ),
                const Spacer(),
                const Label(
                  text: 'Version 1',
                  color: Palette.grey,
                  size: 14,
                ),
                const VBox(20),
              ],
            ),
          ),
        ),
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
  bool joinMatchButtonEnabled = false;

  LobbyState({required this.uri});

  void onMatchIdInputChanged(String text) {
    joinMatchButtonEnabled = text.trim().isNotEmpty;
    notify();
  }

  @override
  void onLoad() {
    super.onLoad();

    final String? matchId = uri.queryParameters['match'];

    if (matchId != null) {
      _joinMatch(matchId);
    }
  }

  Future onCreateMatch() async {
    final DialogController controller =
        LoadingDialog.loading('Creating match...');

    try {
      final HttpsCallableResult result = await const CreateMatch()(
        numberOfPlayers: 2,
        maxPoints: 100,
      );
      final String matchId = result.data['matchId'];
      final JsonMatch match = JsonMatch.fromId(matchId);
      controller.close();
      // onCopyAndShare(matchId);
      Navigation.matchScreen(match);
    } catch (e) {
      controller.close();
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
      final JsonMatch match = JsonMatch.fromId(matchId);
      Navigation.matchScreen(match);
    } catch (e) {
      controller.close();
      print(e);
    }
  }

  void onCopyAndShare(String matchId) {
    final String link = '${Constants.MATCH_URL}$matchId';

    _copyToClipboard(link);

    if (Platform.isMobile) {
      _onShare(link);
    }
  }

  void _copyToClipboard(String link) => ClipboardText().copy(link);

  void _onShare(String link) {
    try {
      Share.share(
        link,
        subject: 'Share the link for people can join the match',
      );
    } catch (e) {
      // ignore
    }
  }
}
