import 'dart:async';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:dafluta/dafluta.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:undervoltage/app/constants.dart';
import 'package:undervoltage/callables/create_match.dart';
import 'package:undervoltage/dialogs/loading_dialog.dart';
import 'package:undervoltage/services/clipboard_text.dart';
import 'package:undervoltage/services/localizations.dart';
import 'package:undervoltage/services/palette.dart';
import 'package:undervoltage/services/platform.dart';
import 'package:undervoltage/widgets/base_screen.dart';
import 'package:undervoltage/widgets/custom_form_field.dart';
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
  final TextEditingController matchIdController = TextEditingController();
  bool joinMatchButtonEnabled = false;
  DatabaseReference? ref;
  int localCounter = 1;
  String remoteCounter = '';
  StreamSubscription? subscription;

  LobbyState({required this.matchId});

  void onMatchIdInputChanged(String text) {
    joinMatchButtonEnabled = text.trim().isNotEmpty;
    notify();
  }

  Future onCreateMatch() async {
    final DialogController controller = LoadingDialog.loading('Creating match');

    try {
      final HttpsCallableResult result =
          await const CreateMatch()(text: 'YES!');
      final String matchId = result.data['id'];

      ref = FirebaseDatabase.instance.ref('matches/$matchId');
      subscription = ref!.onValue.listen((event) {
        final Map<Object?, Object?>? data =
            event.snapshot.value as Map<Object?, Object?>?;

        if (data != null) {
          onMatchUpdated(data);
        }
      });
      controller.close();
    } catch (e) {
      controller.close();
    }
  }

  Future onJoinMatch() async {}

  /*Future onPutCard() async {
    ref?.update({
      'counter': localCounter++,
    });
  }*/

  void onMatchUpdated(Map<Object?, Object?> data) {
    remoteCounter = data['counter']?.toString() ?? '';
    notify();
  }

  void onCopyAndShare() {
    const String link = Constants.MATCH_URL;

    _copyToClipboard(link);

    if (Platform.isMobile) {
      _onShare(link);
    }
  }

  void _copyToClipboard(String link) => ClipboardText().copy(link);

  void _onShare(String link) {
    try {
      Share.share(link, subject: Localized.get.shareSubject);
    } catch (e) {
      // ignore
    }
  }

  @override
  void onDestroy() {
    super.onDestroy();

    subscription?.cancel();
  }
}
