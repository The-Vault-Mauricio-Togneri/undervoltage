import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:undervoltage/domain/json/game/json_card.dart';
import 'package:undervoltage/domain/json/game/json_hand.dart';
import 'package:undervoltage/domain/json/game/json_player.dart';
import 'package:undervoltage/domain/model/room.dart';
import 'package:undervoltage/domain/state/match/match_state.dart';
import 'package:undervoltage/utils/palette.dart';
import 'package:undervoltage/widgets/base_screen.dart';
import 'package:undervoltage/widgets/face_down_pile.dart';
import 'package:undervoltage/widgets/face_up_card.dart';
import 'package:undervoltage/widgets/label.dart';
import 'package:undervoltage/widgets/summary_pile.dart';

class MatchScreen extends StatelessWidget {
  final MatchState state;

  const MatchScreen._(this.state);

  factory MatchScreen.instance(Room room) => MatchScreen._(MatchState(room));

  @override
  Widget build(BuildContext context) {
    return StateProvider<MatchState>(
      state: state,
      builder: (context, state) => Body(state),
    );
  }
}

class Body extends StatelessWidget {
  final MatchState state;

  const Body(this.state);

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: Center(
        child: StateProvider<MatchState>(
          state: state,
          builder: (context, state) => _child(state),
        ),
      ),
    );
  }

  Widget _child(MatchState state) {
    if (state.isLoading) {
      return const Loading();
    } else if (state.isPlaying) {
      return Playing(state);
    } else if (state.isSummary) {
      return Summary(state);
    } else {
      return const Loading();
    }
  }
}

class Loading extends StatelessWidget {
  const Loading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class Summary extends StatelessWidget {
  final MatchState state;

  const Summary(this.state);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final player in state.match.players.values)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Label(
                    text: player.name,
                    color: Palette.grey,
                    size: 16,
                    weight: FontWeight.bold,
                  ),
                  const HBox(20),
                  Label(
                    text: player.points.toString(),
                    color: Palette.grey,
                    size: 16,
                  ),
                ],
              ),
            ),
          const VBox(40),
          ElevatedButton(
            onPressed: state.onFinishTurn,
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class Playing extends StatelessWidget {
  final MatchState state;

  const Playing(this.state);

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
    final double cardWidth = (MediaQuery.of(context).size.width - 104) / 4;

    return FaceUpCard(
      card: state.match.round.discardPile.last,
      width: cardWidth,
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
                      onPressed: state.onDiscardCard,
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
