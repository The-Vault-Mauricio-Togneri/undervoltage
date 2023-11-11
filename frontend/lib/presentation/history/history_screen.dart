import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:undervoltage/domain/models/match.dart';
import 'package:undervoltage/domain/state/history/history_state.dart';
import 'package:undervoltage/utils/date_formatter.dart';
import 'package:undervoltage/utils/navigation.dart';
import 'package:undervoltage/utils/palette.dart';
import 'package:undervoltage/widgets/base_screen.dart';
import 'package:undervoltage/widgets/label.dart';

class HistoryScreen extends StatelessWidget {
  final HistoryState state;

  const HistoryScreen._(this.state);

  factory HistoryScreen.instance() => HistoryScreen._(HistoryState());

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: StateProvider<HistoryState>(
        state: state,
        builder: (context, state) => Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: Navigation.pop,
                icon: Icon(
                  Icons.arrow_back,
                  color: Palette.grey,
                  size: 25,
                ),
              ),
            ),
            if (state.isLoading)
              const Loading()
            else if (state.matches.isEmpty)
              const Empty()
            else
              Content(state.matches),
          ],
        ),
      ),
    );
  }
}

class Loading extends StatelessWidget {
  const Loading();

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class Empty extends StatelessWidget {
  const Empty();

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Center(
        child: Label(
          text: 'No past matches',
          color: Palette.grey,
          size: 14,
        ),
      ),
    );
  }
}

class Content extends StatelessWidget {
  final List<Match> matches;

  const Content(this.matches);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          for (final Match match in matches) MatchCard(match),
        ],
      ),
    );
  }
}

class MatchCard extends StatelessWidget {
  final Match match;

  const MatchCard(this.match);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Label(
                  text: 'Date:',
                  color: Palette.black,
                  size: 14,
                  weight: FontWeight.bold,
                ),
                const HBox(10),
                Label(
                  text: DateFormatter.format(match.createdAt),
                  color: Palette.grey,
                  size: 14,
                ),
                const Spacer(),
                Label(
                  text: '${match.numberOfPlayers} players',
                  color: Palette.grey,
                  size: 14,
                ),
              ],
            ),
            const VBox(5),
            for (final MapEntry<String, int> score in match.scoresTable)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  children: [
                    Label(
                      text: score.key,
                      color: Palette.black,
                      size: 14,
                      weight: FontWeight.bold,
                    ),
                    const Spacer(),
                    Label(
                      text: score.value.toString(),
                      color: score.value >= match.maxPoints
                          ? Palette.red
                          : Palette.green,
                      size: 14,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
