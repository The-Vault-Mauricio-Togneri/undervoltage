import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:undervoltage/app/constants.dart';
import 'package:undervoltage/callables/create_match.dart';
import 'package:undervoltage/services/clipboard_text.dart';
import 'package:undervoltage/services/localizations.dart';
import 'package:undervoltage/services/platform.dart';
import 'package:undervoltage/widgets/game_container.dart';

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
      child: GameContainer(
        child: StateProvider<LobbyState>(
          state: state,
          builder: (context, state) => const Empty(),
        ),
      ),
    );
  }
}

class LobbyState extends BaseState {
  final Uri uri;

  LobbyState({required this.uri});

  String? getMatchId() => uri.queryParameters['match'];

  @override
  void onLoad() {
    super.onLoad();

    const CreateMatch()(text: 'YES!');
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

  /*@override
  void onDestroy() {
    super.onDestroy();
  }*/
}
