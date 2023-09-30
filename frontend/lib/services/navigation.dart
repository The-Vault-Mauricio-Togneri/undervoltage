import 'package:dafluta/dafluta.dart';
import 'package:flutter/widgets.dart';
import 'package:idlebattle/models/match.dart';
import 'package:idlebattle/screens/lobby_screen.dart';
import 'package:idlebattle/screens/main_screen.dart';
import 'package:idlebattle/screens/match_screen.dart';
import 'package:idlebattle/services/initializer.dart';
import 'package:idlebattle/types/match_type.dart';

class Navigation {
  final Routes routes = Routes();

  static Navigation get get => getIt<Navigation>();

  static void pop<T>([T? result]) => get.routes.pop();

  static BuildContext context() => get.routes.key.currentContext!;

  static void mainScreen(Uri uri) => get.routes.pushReplacement(
        FadeRoute(
          MainScreen.instance(uri: uri),
          name: 'main',
        ),
      );

  static void matchScreen(Match match) => get.routes.pushReplacement(
        FadeRoute(
          MatchScreen.instance(match: match),
          name: 'match',
        ),
      );

  static void lobbyScreen({
    required MatchType matchType,
    String? matchId,
  }) =>
      get.routes.push(
        FadeRoute(
          LobbyScreen.instance(
            matchType: matchType,
            matchId: matchId,
          ),
          name: 'lobby',
        ),
      );
}
