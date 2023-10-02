import 'dart:async';
import 'dart:convert';
import 'package:dafluta/dafluta.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:undervoltage/json/json_card.dart';
import 'package:undervoltage/json/json_hand.dart';
import 'package:undervoltage/json/json_match.dart';
import 'package:undervoltage/services/logged_user.dart';
import 'package:undervoltage/services/palette.dart';
import 'package:undervoltage/types/match_status.dart';
import 'package:undervoltage/widgets/base_screen.dart';
import 'package:undervoltage/widgets/face_down_pile.dart';
import 'package:undervoltage/widgets/face_up_card.dart';
import 'package:undervoltage/widgets/label.dart';

class MatchScreen extends StatelessWidget {
  final MatchState state;

  const MatchScreen._(this.state);

  factory MatchScreen.instance({required JsonMatch match}) =>
      MatchScreen._(MatchState(match: match));

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: StateProvider<MatchState>(
        state: state,
        builder: (context, state) => _child(state),
      ),
    );
  }

  Widget _child(MatchState state) {
    if (state.isWaitingForPlayers) {
      return WaitingForPlayers(state);
    } else if (state.isPlaying) {
      return Started(state);
    } else {
      return const Empty();
    }
  }
}

class WaitingForPlayers extends StatelessWidget {
  final MatchState state;

  const WaitingForPlayers(this.state);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Label(
        text:
            'Waiting for players: ${state.playersJoined}/${state.numberOfPlayers}',
        color: Palette.grey,
        size: 14,
      ),
    );
  }
}

class Started extends StatelessWidget {
  final MatchState state;

  const Started(this.state);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const VBox(50),
        Label(
          text: 'Other players: ${state.match.numberOfPlayers - 1}',
          color: Palette.black,
          size: 14,
        ),
        const Spacer(),
        DiscardPile(state),
        const Spacer(),
        PlayerHand(state),
        const VBox(50),
      ],
    );
  }
}

class DiscardPile extends StatelessWidget {
  final MatchState state;

  const DiscardPile(this.state);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 50,
        bottom: 50,
      ),
      child: FaceUpCard(
        card: state.match.round.discardPile.last,
        onPressed: null,
      ),
    );
  }
}

class PlayerHand extends StatelessWidget {
  final MatchState state;

  const PlayerHand(this.state);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (state.hand.hiddenPile.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: FaceDownPile(
                  cards: state.hand.hiddenPile,
                  onPressed: state.onDiscardPilePressed,
                ),
              ),
            PlayerHandRevealed(
              cards: state.hand.revealedPile,
              onPressed: state.onPlayCard,
            ),
          ],
        ),
      ),
    );
  }
}

class PlayerHandRevealed extends StatelessWidget {
  final List<JsonCard> cards;
  final Function(JsonCard) onPressed;

  const PlayerHandRevealed({
    required this.cards,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          for (final JsonCard card in cards)
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                bottom: 20,
              ),
              child: FaceUpCard(
                card: card,
                onPressed: onPressed,
              ),
            ),
        ],
      ),
    );
  }
}

class MatchState extends BaseState {
  late final String playerId;
  late final DatabaseReference matchRef;
  late final StreamSubscription subscription;
  JsonMatch match;

  MatchState({required this.match});

  bool get isWaitingForPlayers => match.status == MatchStatus.waitingForPlayers;

  bool get isPlaying => match.status == MatchStatus.playing;

  int get numberOfPlayers => match.numberOfPlayers;

  int get playersJoined => match.playersJoined;

  JsonHand get hand =>
      match.round.playersHand[playerId] ??
      const JsonHand(
        hiddenPile: [],
        revealedPile: [],
      );

  @override
  void onLoad() {
    super.onLoad();

    playerId = LoggedUser.get.id;

    matchRef = FirebaseDatabase.instance.ref('matches/${match.id}');
    subscription = matchRef.onValue.listen((event) {
      final json = jsonEncode(event.snapshot.value);
      match = JsonMatch.fromJson(jsonDecode(json));
      onMatchUpdated(match);
    });
  }

  Future updateHand(JsonHand hand) async {
    final handRef = FirebaseDatabase.instance
        .ref('matches/${match.id}/round/playersHand/$playerId');
    final TransactionResult result = await handRef.runTransaction(
      (Object? post) {
        if (post == null) {
          return Transaction.abort();
        } else {
          final Map<String, dynamic> newHand =
              Map<String, dynamic>.from(post as Map);
          newHand['hiddenPile'] = hand.hiddenPile.map((e) => e.toJson());
          newHand['revealedPile'] = hand.revealedPile.map((e) => e.toJson());

          return Transaction.success(newHand);
        }
      },
      applyLocally: false,
    );
    print(result.committed);
  }

  void onDiscardPilePressed() {
    final JsonHand currentHand = hand;
    currentHand.revealCard();
    updateHand(currentHand);
  }

  void onPlayCard(JsonCard card) {
    final JsonHand currentHand = hand;
    currentHand.playCard(card);
    updateHand(currentHand);
  }

  void onMatchUpdated(JsonMatch match) {
    print(match);
    notify();
  }

  @override
  void onDestroy() {
    super.onDestroy();

    subscription.cancel();
  }
}
