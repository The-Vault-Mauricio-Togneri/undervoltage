import 'package:dafluta/dafluta.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:undervoltage/domain/json/game/json_card.dart';
import 'package:undervoltage/domain/json/game/json_hand.dart';
import 'package:undervoltage/domain/json/game/json_match.dart';
import 'package:undervoltage/domain/json/messages/json_message.dart';
import 'package:undervoltage/domain/json/messages/json_start.dart';
import 'package:undervoltage/domain/json/messages/json_welcome.dart';
import 'package:undervoltage/domain/model/room.dart';
import 'package:undervoltage/domain/model/user_logged.dart';
import 'package:undervoltage/domain/types/match_status.dart';
import 'package:undervoltage/domain/types/tts_state.dart';
import 'package:undervoltage/utils/connection.dart';

class MatchState extends BaseState {
  final Room room;
  late final Connection connection;
  final FlutterTts tts = FlutterTts();
  final List<String> ttsPlayQueue = [];

  JsonMatch? _match;
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

  JsonMatch get match => _match!;

  String get playerId => LoggedUser.get.id;

  JsonHand get hand =>
      match.round.playersHand[playerId] ??
      const JsonHand(
        hiddenPile: [],
        revealedPile: [],
        faults: 0,
      );

  @override
  void onLoad() {
    connection.connect();
  }

  void _onMessage(dynamic json) {
    if (json is JsonWelcome) {
      connection.send(JsonMessage.joinRoom(
        roomId: room.id,
        playerId: LoggedUser.get.id,
      ));
    } else if (json is JsonStart) {
      _match = json.match;
    }

    notify();
  }

  void _onDisconnected() {
    // TODO(momo): implement
  }

  void _onError(dynamic error) {
    // TODO(momo): implement
  }

  void onPlayCard(JsonCard card) {
    // TODO(momo): implement
  }

  void onDiscardCard() {
    // TODO(momo): implement
  }

  void onIncreaseFault() {
    // TODO(momo): implement
  }

  void onFinishTurn() {
    // TODO(momo): implement
  }
}
