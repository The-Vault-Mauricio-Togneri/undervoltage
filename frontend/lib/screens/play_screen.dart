import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:idlebattle/services/localizations.dart';
import 'package:idlebattle/services/navigation.dart';
import 'package:idlebattle/types/match_type.dart';
import 'package:idlebattle/widgets/game_container.dart';

class PlayScreen extends StatelessWidget {
  final PlayState state;

  PlayScreen({required String? matchId}) : state = PlayState(matchId);

  @override
  Widget build(BuildContext context) {
    return GameContainer(
      child: Content(state),
    );
  }
}

class Content extends StatelessWidget {
  final PlayState state;

  const Content(this.state);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) => Padding(
          padding: EdgeInsets.fromLTRB(constraints.maxWidth * 0.2, 0, constraints.maxWidth * 0.2, 0),
          child: Column(
            children: [
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: state.onJoinPublic,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(Localized.get.buttonJoinPublicMatch.toUpperCase()),
                  ),
                ),
              ),
              const VBox(20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: state.onCreatePrivate,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(Localized.get.buttonCreatePrivateMatch.toUpperCase()),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class PlayState extends BaseState {
  String? matchId;

  PlayState(this.matchId);

  @override
  void onLoad() {
    if (matchId != null) {
      onJoinPrivate(matchId!);
    }
  }

  void onJoinPublic() => Navigation.lobbyScreen(
        matchType: MatchType.PUBLIC,
        matchId: matchId,
      );

  void onCreatePrivate() => Navigation.lobbyScreen(
        matchType: MatchType.PRIVATE,
        matchId: matchId,
      );

  void onJoinPrivate(String matchId) => Navigation.lobbyScreen(
        matchType: MatchType.PRIVATE,
        matchId: matchId,
      );
}
