import 'dart:async';
import 'dart:convert';
import 'package:dafluta/dafluta.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:undervoltage/app/constants.dart';
import 'package:undervoltage/json/json_card.dart';
import 'package:undervoltage/json/json_hand.dart';
import 'package:undervoltage/json/json_match.dart';
import 'package:undervoltage/services/logged_user.dart';
import 'package:undervoltage/services/palette.dart';
import 'package:undervoltage/types/match_status.dart';
import 'package:undervoltage/widgets/base_screen.dart';
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
      child: FaceDownPile(
        cards: state.match.round.discardPile,
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
            FaceDownPile(
              cards: state.hand.hiddenPile,
              onPressed: state.onDiscardPilePressed,
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

class FaceUpCard extends StatelessWidget {
  final JsonCard card;
  final Function(JsonCard) onPressed;

  const FaceUpCard({
    required this.card,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final double cardWidth = (MediaQuery.of(context).size.width - 104) / 4;

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          width: 0.5,
          color: Palette.grey,
        ),
      ),
      child: Container(
        width: cardWidth,
        height: cardWidth * 1.56,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            width: cardWidth / 15,
            color: Palette.white,
          ),
          color: Palette.fromCard(card),
        ),
        child: Padding(
          padding: EdgeInsets.all(cardWidth / 20),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Label(
                  text: '±${card.diff}',
                  color: Palette.white,
                  size: cardWidth / 3,
                  weight: FontWeight.bold,
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Label(
                  text: card.value.toString(),
                  color: Palette.white,
                  size: cardWidth / 3.5,
                  weight: FontWeight.bold,
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Label(
                  text: card.value.toString(),
                  color: Palette.white,
                  size: cardWidth / 3.5,
                  weight: FontWeight.bold,
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Label(
                  text: card.value.toString(),
                  color: Palette.white,
                  size: cardWidth / 3.5,
                  weight: FontWeight.bold,
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Label(
                  text: card.value.toString(),
                  color: Palette.white,
                  size: cardWidth / 3.5,
                  weight: FontWeight.bold,
                ),
              ),
              Material(
                color: Palette.transparent,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  onTap: () => onPressed(card),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FaceDownPile extends StatelessWidget {
  final List<JsonCard> cards;
  final VoidCallback? onPressed;

  const FaceDownPile({
    required this.cards,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final double cardWidth = (MediaQuery.of(context).size.width - 104) / 4;

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          width: 0.5,
          color: Palette.grey,
        ),
      ),
      child: Container(
        width: cardWidth,
        height: cardWidth * 1.56,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            width: cardWidth / 15,
            color: Palette.white,
          ),
          color: Palette.grey,
        ),
        child: Material(
          color: Palette.transparent,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            onTap: onPressed,
          ),
        ),
      ),
    );
  }
}

class MatchState extends BaseState {
  late final DatabaseReference matchRef;
  late final StreamSubscription subscription;
  JsonMatch match;

  MatchState({required this.match});

  bool get isWaitingForPlayers => match.status == MatchStatus.waitingForPlayers;

  bool get isPlaying => match.status == MatchStatus.playing;

  int get numberOfPlayers => match.numberOfPlayers;

  int get playersJoined => match.playersJoined;

  JsonHand get hand =>
      match.round.playersHand[LoggedUser.get.id] ??
      const JsonHand(
        hiddenPile: [],
        revealedPile: [],
      );

  @override
  void onLoad() {
    super.onLoad();

    matchRef = FirebaseDatabase.instance.ref('matches/${match.id}');
    subscription = matchRef.onValue.listen((event) {
      final json = jsonEncode(event.snapshot.value);
      match = JsonMatch.fromJson(jsonDecode(json));
      onMatchUpdated(match);
    });
  }

  Future onPutCard() async {
    await matchRef.runTransaction((Object? post) {
      if (post == null) {
        return Transaction.abort();
      }

      final Map<String, dynamic> _post = Map<String, dynamic>.from(post as Map);
      _post['stars'] = 0;

      return Transaction.success(_post);
    });
  }

  void onDiscardPilePressed() {}

  void onPlayCard(JsonCard json) {}

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
