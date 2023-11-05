import 'package:dafluta/dafluta.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:undervoltage/domain/json/messages/json_message.dart';
import 'package:undervoltage/domain/json/messages/server_client/json_update.dart';
import 'package:undervoltage/domain/json/messages/server_client/json_welcome.dart';
import 'package:undervoltage/domain/models/game/card.dart';
import 'package:undervoltage/domain/models/game/hand.dart';
import 'package:undervoltage/domain/models/game/match.dart';
import 'package:undervoltage/domain/models/room.dart';
import 'package:undervoltage/domain/models/user_logged.dart';
import 'package:undervoltage/domain/types/match_status.dart';
import 'package:undervoltage/domain/types/tts_state.dart';
import 'package:undervoltage/presentation/dialogs/info_dialog.dart';
import 'package:undervoltage/utils/connection.dart';
import 'package:undervoltage/utils/navigation.dart';

class MatchState extends BaseState {
  final Room room;
  late final Connection connection;
  final FlutterTts tts = FlutterTts();
  final List<String> ttsPlayQueue = [];

  Match? _match;
  String lastCard = '';
  TextToSpeechState ttsState = TextToSpeechState.idle;

  MatchState(this.room) {
    connection = Connection(
      onMessage: _onMessage,
      onDisconnected: _onDisconnected,
      onError: _onError,
    );
  }

  bool get isLoading => _match == null;

  bool get isPlaying => _match?.status == MatchStatus.playing;

  bool get isSummary => _match?.status == MatchStatus.summary;

  bool get isFinished => _match?.status == MatchStatus.finished;

  String get playerId => LoggedUser.get.id;

  Match get match => _match!;

  Hand get hand => _match!.hand(playerId);

  @override
  void onLoad() {
    connection.connect();

    tts.setStartHandler(() {
      ttsState = TextToSpeechState.playing;
    });

    tts.setCompletionHandler(() {
      ttsState = TextToSpeechState.idle;

      if (ttsPlayQueue.isNotEmpty) {
        _speak(ttsPlayQueue.removeAt(0));
      }
    });
  }

  void _speak(String value) {
    if (ttsState == TextToSpeechState.idle) {
      tts.speak(value);
    } else {
      ttsPlayQueue.add(value);
    }
  }

  void _onMessage(dynamic json) {
    if (json is JsonWelcome) {
      connection.send(JsonMessage.joinRoom(
        roomId: room.id,
        playerId: playerId,
      ));
    } else if (json is JsonUpdate) {
      _match = Match.fromJson(json.match);
      onMatchUpdate(_match!);
    }

    notify();
  }

  void onMatchUpdate(Match match) {
    final bool shouldSpeak = lastCard.isNotEmpty;

    if (match.round.discardPile.isNotEmpty) {
      final String newCard = match.round.discardPile.last.value.toString();

      if (lastCard != newCard) {
        lastCard = newCard;

        if (shouldSpeak) {
          _speak(lastCard);
        }
      }
    }
  }

  void _onDisconnected() => InfoDialog.error(
        text: 'Server disconnection',
        onAccept: Navigation.pop,
      );

  void _onError(dynamic error) {
    print(error);
  }

  void onPlayCard(Card card) {
    final Card topCard = match.round.discardPile.last;

    if (topCard.canAccept(card)) {
      connection.send(JsonMessage.playCard(
        cardId: card.id,
        playerId: playerId,
      ));
    } else {
      connection.send(JsonMessage.increaseFault(playerId));
    }
  }

  void onDiscardCard() => connection.send(JsonMessage.discardCard(playerId));

  void onFinishTurn() => connection.send(JsonMessage.summaryAccepted(playerId));
}
