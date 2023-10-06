import 'dart:async';
import 'dart:convert';
import 'package:dafluta/dafluta.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:undervoltage/json/json_card.dart';
import 'package:undervoltage/json/json_hand.dart';
import 'package:undervoltage/json/json_match.dart';
import 'package:undervoltage/json/json_player.dart';
import 'package:undervoltage/services/logged_user.dart';
import 'package:undervoltage/services/palette.dart';
import 'package:undervoltage/types/match_status.dart';
import 'package:undervoltage/widgets/base_screen.dart';
import 'package:undervoltage/widgets/face_down_pile.dart';
import 'package:undervoltage/widgets/face_up_card.dart';
import 'package:undervoltage/widgets/label.dart';
import 'package:undervoltage/widgets/summary_pile.dart';

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
        OtherPlayers(state),
        const Spacer(),
        DiscardPile(state),
        const Spacer(),
        PlayerHand(state),
      ],
    );
  }
}

class OtherPlayers extends StatelessWidget {
  final MatchState state;

  const OtherPlayers(this.state);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (final JsonPlayer player in state.match.players.values)
            if (player.id != state.playerId)
              OtherPlayerPile(
                  player, state.match.round.playersHand[player.id]!),
        ],
      ),
    );
  }
}

class OtherPlayerPile extends StatelessWidget {
  final JsonPlayer player;
  final JsonHand hand;

  const OtherPlayerPile(this.player, this.hand);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SummaryPile(
          amount: hand.hiddenPile.length + hand.revealedPile.length,
          width: MediaQuery.of(context).size.width / 8,
        ),
        const VBox(10),
        Label(
          text: player.name,
          color: Palette.grey,
          size: 16,
        ),
      ],
    );
  }
}

class DiscardPile extends StatelessWidget {
  final MatchState state;

  const DiscardPile(this.state);

  @override
  Widget build(BuildContext context) {
    return FaceUpCard(
      card: state.match.round.discardPile.last,
      width: (MediaQuery.of(context).size.width - 104) / 4,
      onPressed: null,
    );
  }
}

class PlayerHand extends StatelessWidget {
  final MatchState state;

  const PlayerHand(this.state);

  double _cardWidth(BuildContext context) {
    if (state.hand.revealedPile.length > 20) {
      return _fit(context, 6);
    } else if (state.hand.revealedPile.length > 9) {
      return _fit(context, 5);
    } else {
      return _fit(context, 4);
    }
  }

  double _fit(BuildContext context, int amount) =>
      (MediaQuery.of(context).size.width - ((amount + 1) * 20) - amount) /
      amount;

  @override
  Widget build(BuildContext context) {
    final double cardWidth = _cardWidth(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Wrap(
                children: [
                  for (int i = 0; i < state.hand.faults; i++)
                    const FaultBullet(),
                ],
              ),
            ),
            const VBox(20),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                PlayerHandRevealed(
                  cards: state.hand.revealedPile,
                  cardWidth: cardWidth,
                  onPressed: state.onPlayCard,
                ),
                if (state.hand.hiddenPile.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: FaceDownPile(
                      cards: state.hand.hiddenPile,
                      width: cardWidth,
                      onPressed: state.onDiscardPilePressed,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FaultBullet extends StatelessWidget {
  const FaultBullet();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(
        left: 5,
        right: 5,
      ),
      child: Icon(
        Icons.close,
        color: Palette.red,
        size: 20,
      ),
    );
  }
}

class PlayerHandRevealed extends StatelessWidget {
  final List<JsonCard> cards;
  final double cardWidth;
  final Function(JsonCard) onPressed;

  const PlayerHandRevealed({
    required this.cards,
    required this.cardWidth,
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
                right: 20,
                bottom: 20,
              ),
              child: FaceUpCard(
                card: card,
                width: cardWidth,
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
  final FlutterTts tts = FlutterTts();
  JsonMatch match;
  String lastCard = '';

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
        faults: 0,
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

  Future playCard(JsonCard card) async {
    final pileRef =
        FirebaseDatabase.instance.ref('matches/${match.id}/round/discardPile');
    final TransactionResult result = await pileRef.runTransaction(
      (Object? old) {
        if (old == null) {
          return Transaction.abort();
        } else {
          final List<dynamic> newPile = List<dynamic>.from(old as List);
          final JsonCard topCard = JsonCard.fromJson(newPile.last);

          if (topCard.canAccept(card)) {
            newPile.add(card.toJson());

            return Transaction.success(newPile);
          } else {
            return Transaction.abort();
          }
        }
      },
      applyLocally: false,
    );

    return result.committed;
  }

  Future updateHand(JsonHand hand) async {
    final handRef = FirebaseDatabase.instance
        .ref('matches/${match.id}/round/playersHand/$playerId');
    final TransactionResult result = await handRef.runTransaction(
      (Object? old) {
        if (old == null) {
          return Transaction.abort();
        } else {
          final Map<String, dynamic> newHand =
              Map<String, dynamic>.from(old as Map);
          newHand['hiddenPile'] = hand.hiddenPile.map((e) => e.toJson());
          newHand['revealedPile'] = hand.revealedPile.map((e) => e.toJson());
          newHand['faults'] = hand.faults;

          return Transaction.success(newHand);
        }
      },
      applyLocally: false,
    );

    return result.committed;
  }

  void onDiscardPilePressed() {
    final JsonHand currentHand = hand;
    currentHand.revealCard();
    updateHand(currentHand);
  }

  Future onPlayCard(JsonCard card) async {
    final JsonHand currentHand = hand;
    final JsonCard topCard = match.round.discardPile.last;

    if (topCard.canAccept(card)) {
      final bool success = await playCard(card);

      if (success) {
        currentHand.playCard(card);
        updateHand(currentHand);
      }
    } else {
      updateHand(currentHand.withNewFault);
    }
  }

  void onMatchUpdated(JsonMatch match) {
    notify();

    final bool shouldSpeak = lastCard.isNotEmpty;

    if (match.round.discardPile.isNotEmpty) {
      final String newCard = match.round.discardPile.last.value.toString();

      if (lastCard != newCard) {
        lastCard = newCard;

        if (shouldSpeak) {
          tts.speak(lastCard);
        }
      }
    }
  }

  @override
  void onDestroy() {
    super.onDestroy();

    subscription.cancel();
  }
}
