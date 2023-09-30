import 'dart:async';
import 'dart:convert';
import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:undervoltage/app/constants.dart';
import 'package:undervoltage/json/json_input_message.dart';
import 'package:undervoltage/json/json_match_configuration.dart';
import 'package:undervoltage/json/json_match_status.dart';
import 'package:undervoltage/json/json_output_message.dart';
import 'package:undervoltage/models/echo.dart';
import 'package:undervoltage/models/match.dart';
import 'package:undervoltage/services/audio.dart';
import 'package:undervoltage/services/clipboard_text.dart';
import 'package:undervoltage/services/connection.dart';
import 'package:undervoltage/services/localizations.dart';
import 'package:undervoltage/services/logged_user.dart';
import 'package:undervoltage/services/navigation.dart';
import 'package:undervoltage/services/platform.dart';
import 'package:undervoltage/types/input_event.dart';
import 'package:undervoltage/types/lobby_status.dart';
import 'package:undervoltage/types/match_type.dart';
import 'package:undervoltage/widgets/game_container.dart';

class LobbyScreen extends StatelessWidget {
  final LobbyState state;

  const LobbyScreen._(this.state);

  factory LobbyScreen.instance({
    required MatchType matchType,
    String? matchId,
  }) =>
      LobbyScreen._(
        LobbyState(
          matchType: matchType,
          matchId: matchId,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: GameContainer(
        child: StateProvider<LobbyState>(
          state: state,
          builder: (context, state) {
            switch (state.status) {
              case LobbyStatus.EMPTY:
                return Empty(state);
              case LobbyStatus.WAITING_PUBLIC:
                return WaitingPublic(state);
              case LobbyStatus.WAITING_PRIVATE:
                return WaitingPrivate(state);
              case LobbyStatus.READY:
                return Ready(state);
            }
          },
        ),
      ),
    );
  }
}

class Empty extends StatelessWidget {
  final LobbyState state;

  const Empty(this.state);

  @override
  Widget build(BuildContext context) {
    return Loading(
      state: state,
      message: Localized.get.messageLoading,
      canCancel: false,
    );
  }
}

class WaitingPublic extends StatelessWidget {
  final LobbyState state;

  const WaitingPublic(this.state);

  @override
  Widget build(BuildContext context) {
    return Loading(
      state: state,
      message: Localized.get.messageWaiting,
      canCancel: true,
    );
  }
}

class WaitingPrivate extends StatelessWidget {
  final LobbyState state;

  const WaitingPrivate(this.state);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) => Padding(
          padding: EdgeInsets.fromLTRB(constraints.maxWidth * 0.2, 0, constraints.maxWidth * 0.2, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const VBox(20),
              Text(
                Localized.get.messageShareWaiting,
                textAlign: TextAlign.center,
              ),
              const VBox(20),
              ElevatedButton(
                onPressed: state.onCopyAndShare,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(Platform.isMobile ? Localized.get.buttonShareLink.toUpperCase() : Localized.get.buttonCopyLink.toUpperCase()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Ready extends StatelessWidget {
  final LobbyState state;

  const Ready(this.state);

  @override
  Widget build(BuildContext context) {
    return Loading(
      state: state,
      message: Localized.get.messageGetReady,
      canCancel: false,
    );
  }
}

class Loading extends StatelessWidget {
  final LobbyState state;
  final String message;
  final bool canCancel;

  const Loading({
    required this.state,
    required this.message,
    required this.canCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) => Padding(
          padding: EdgeInsets.fromLTRB(constraints.maxWidth * 0.2, 0, constraints.maxWidth * 0.2, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const VBox(20),
              Text(
                message,
                textAlign: TextAlign.center,
              ),
              const VBox(20),
              if (canCancel)
                ElevatedButton(
                  onPressed: state.onCancel,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(Localized.get.buttonCancel.toUpperCase()),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class LobbyState extends BaseState {
  MatchType matchType;
  String? matchId;

  Match? match;
  Echo? echo;

  LobbyStatus status = LobbyStatus.EMPTY;

  late final Connection connection;
  late final StreamSubscription streamSubscription;

  LobbyState({
    required this.matchType,
    required this.matchId,
  });

  @override
  Future onLoad() async {
    connection = Connection.get;
    streamSubscription = connection.listenMessage(_processMessage);

    switch (matchType) {
      case MatchType.PUBLIC:
        _onJoinPublic();
        break;
      case MatchType.PRIVATE:
        if (matchId == null) {
          _onCreatePrivate();
        } else {
          _onJoinPrivate(matchId!);
        }
        break;
    }
  }

  void _processMessage(JsonInputMessage message) {
    print('<<< ${jsonEncode(message.toJson())}');

    switch (message.event) {
      case InputEvent.WAITING_PUBLIC:
        _onWaitingPublic();
        break;
      case InputEvent.ECHO:
        _onEcho();
        break;
      case InputEvent.WAITING_PRIVATE:
        _onWaitingPrivate(message.matchId!);
        break;
      case InputEvent.MATCH_READY:
        _onMatchReady(message.matchStatus!, message.configuration!);
        break;
      case InputEvent.MATCH_STARTED:
        _onMatchStarted();
        break;
      default:
    }
  }

  void _onEcho() {
    echo?.received();
    echo?.send();
  }

  void _onJoinPublic() => connection.send(JsonOutputMessage.joinPublic(LoggedUser.get.name));

  void _onWaitingPublic() {
    status = LobbyStatus.WAITING_PUBLIC;
    notify();
  }

  void _onCreatePrivate() => connection.send(JsonOutputMessage.createPrivate(LoggedUser.get.name));

  void _onWaitingPrivate(String newMatchId) {
    status = LobbyStatus.WAITING_PRIVATE;
    matchId = newMatchId;
    notify();
  }

  void _onJoinPrivate(String matchId) => connection.send(JsonOutputMessage.joinPrivate(LoggedUser.get.name, matchId));

  void _onMatchReady(
    JsonMatchStatus matchStatus,
    JsonMatchConfiguration configuration,
  ) {
    Audio.get.playSound(Audio.SOUND_READY);

    echo = Echo(matchStatus.id, connection);
    echo?.send();

    match = Match.create(
      matchStatus: matchStatus,
      configuration: configuration,
    );

    status = LobbyStatus.READY;
    notify();
  }

  Future _onMatchStarted() async {
    match!.latency = echo!.average();
    Navigation.matchScreen(match!);
  }

  void onCancel() {
    connection.send(JsonOutputMessage.disconnect());
    Navigation.pop();
  }

  void onCopyAndShare() {
    final String link = '${Constants.PRIVATE_MATCH_LINK}$matchId';

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
    streamSubscription.cancel();

    super.onDestroy();
  }
}
