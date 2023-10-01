import 'dart:async';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:dafluta/dafluta.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:undervoltage/app/constants.dart';
import 'package:undervoltage/callables/create_match.dart';
import 'package:undervoltage/services/clipboard_text.dart';
import 'package:undervoltage/services/localizations.dart';
import 'package:undervoltage/services/platform.dart';
import 'package:undervoltage/widgets/base_screen.dart';

class LobbyScreen extends StatelessWidget {
  final LobbyState state;

  const LobbyScreen._(this.state);

  factory LobbyScreen.instance({required Uri uri}) =>
      LobbyScreen._(LobbyState(uri: uri));

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: BaseScreen(
        child: StateProvider<LobbyState>(
          state: state,
          builder: (context, state) => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: state.onCreateMatch,
                child: const Text('CREATE MATCH'),
              ),
              const VBox(20),
              ElevatedButton(
                onPressed: state.onPutCard,
                child: const Text('PUT CARD'),
              ),
              const VBox(20),
              Text(state.remoteCounter),
            ],
          ),
        ),
      ),
    );
  }
}

class LobbyState extends BaseState {
  final Uri uri;
  DatabaseReference? ref;
  int localCounter = 1;
  String remoteCounter = '';
  StreamSubscription? subscription;

  LobbyState({required this.uri});

  String? getMatchId() => uri.queryParameters['match'];

  Future onCreateMatch() async {
    final HttpsCallableResult result = await const CreateMatch()(text: 'YES!');
    final String matchId = result.data['id'];

    ref = FirebaseDatabase.instance.ref('matches/$matchId');
    subscription = ref!.onValue.listen((event) {
      final Map<Object?, Object?>? data =
          event.snapshot.value as Map<Object?, Object?>?;

      if (data != null) {
        onMatchUpdated(data);
      }
    });
  }

  Future onPutCard() async {
    ref?.update({
      'counter': localCounter++,
    });
  }

  void onMatchUpdated(Map<Object?, Object?> data) {
    remoteCounter = data['counter']?.toString() ?? '';
    notify();
  }

  void onCopyAndShare() {
    const String link = Constants.PRIVATE_MATCH_LINK;

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
