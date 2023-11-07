import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:undervoltage/domain/models/game/card.dart';
import 'package:undervoltage/domain/models/game/hand.dart';
import 'package:undervoltage/domain/models/game/player.dart';
import 'package:undervoltage/domain/models/game/summary.dart';
import 'package:undervoltage/domain/models/room.dart';
import 'package:undervoltage/domain/state/match/match_state.dart';
import 'package:undervoltage/domain/types/player_status.dart';
import 'package:undervoltage/utils/navigation.dart';
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
    } else if (state.isSummary ||
        state.isFinished ||
        state.match.self.isFinished) {
      return SummarySection(state);
    } else if (state.isPlaying) {
      return Playing(state);
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

class SummarySection extends StatelessWidget {
  final MatchState state;

  const SummarySection(this.state);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SummaryTitle(state),
          const VBox(60),
          SummaryTable(
            state.match.summary,
            state.match.players,
            state.match.maxPoints,
          ),
          const VBox(60),
          SummaryButton(state),
        ],
      ),
    );
  }
}

class SummaryTitle extends StatelessWidget {
  final MatchState state;

  const SummaryTitle(this.state);

  @override
  Widget build(BuildContext context) {
    if (state.isFinished) {
      return const Label(
        text: 'MATCH FINISHED',
        color: Palette.black,
        size: 22,
        weight: FontWeight.bold,
      );
    } else {
      return const Label(
        text: 'ROUND FINISHED',
        color: Palette.black,
        size: 22,
        weight: FontWeight.bold,
      );
    }
  }
}

class SummaryButton extends StatelessWidget {
  final MatchState state;

  const SummaryButton(this.state);

  @override
  Widget build(BuildContext context) {
    if (state.isFinished || state.match.self.isFinished) {
      return const ElevatedButton(
        onPressed: Navigation.pop,
        child: Text('Finish'),
      );
    } else if (state.match.self.status == PlayerStatus.readingSummary) {
      return ElevatedButton(
        onPressed: state.onSummaryAccepted,
        child: const Text('Continue'),
      );
    } else {
      return const Label(
        text: 'Waiting for players…',
        color: Palette.black,
        size: 14,
      );
    }
  }
}

class SummaryTable extends StatelessWidget {
  final List<Summary> summary;
  final Map<String, Player> players;
  final int maxPoints;

  const SummaryTable(this.summary, this.players, this.maxPoints);

  @override
  Widget build(BuildContext context) {
    final List<String> playerIds = players.keys.toList();

    return Table(
      border: TableBorder.all(),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      defaultColumnWidth: const IntrinsicColumnWidth(),
      children: [
        TableRow(
          children: [
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.fill,
              child: Container(
                color: Palette.lightGrey,
              ),
            ),
            for (final String playerId in playerIds)
              TableCell(
                child: Container(
                  color: Palette.lightGrey,
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width /
                        (players.length + 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Label(
                      text: players[playerId]!.name,
                      color: Palette.black,
                      weight: FontWeight.bold,
                      align: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      decoration: players[playerId]!.isFinished
                          ? TextDecoration.lineThrough
                          : null,
                      size: 12,
                    ),
                  ),
                ),
              ),
          ],
        ),
        for (int i = 0; i < summary.length; i++)
          TableRow(
            children: [
              TableCell(
                child: Container(
                  color: Palette.lightGrey,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Label(
                      text: 'Round ${i + 1}',
                      color: Palette.black,
                      weight: FontWeight.bold,
                      align: TextAlign.start,
                      size: 12,
                    ),
                  ),
                ),
              ),
              for (final String playerId in playerIds)
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Label(
                      text: summary[i].points[playerId].toString(),
                      color: Palette.black,
                      align: TextAlign.center,
                      size: 12,
                    ),
                  ),
                ),
            ],
          ),
        TableRow(
          children: [
            TableCell(
              child: Container(
                color: Palette.lightGrey,
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Label(
                    text: 'Total',
                    color: Palette.black,
                    weight: FontWeight.bold,
                    align: TextAlign.start,
                    size: 12,
                  ),
                ),
              ),
            ),
            for (final String playerId in playerIds)
              TableCell(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Label(
                    text: players[playerId]!.points.toString(),
                    color: players[playerId]!.points < maxPoints
                        ? Palette.green
                        : Palette.red,
                    weight: FontWeight.bold,
                    align: TextAlign.center,
                    size: 12,
                  ),
                ),
              ),
          ],
        ),
      ],
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
          for (final Player player in state.match.players.values)
            if (!player.isFinished && (player.id != state.playerId))
              OtherPlayerPile(
                player,
                state.match.round.playersHand[player.id]!,
              ),
        ],
      ),
    );
  }
}

class OtherPlayerPile extends StatelessWidget {
  final Player player;
  final Hand hand;

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
          align: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
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
            if (state.hand.faults > 0) FaultIndicator(state.hand.faults),
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

class FaultIndicator extends StatelessWidget {
  final int amount;

  const FaultIndicator(this.amount);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 5,
          right: 5,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Label(
              text: amount.toString(),
              color: Palette.red,
              size: 20,
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 2),
              child: Icon(
                Icons.close,
                color: Palette.red,
                size: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlayerHandRevealed extends StatelessWidget {
  final List<Card> cards;
  final double cardWidth;
  final Function(Card) onPressed;

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
          for (final Card card in cards)
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
