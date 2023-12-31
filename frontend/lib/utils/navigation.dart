import 'package:dafluta/dafluta.dart';
import 'package:flutter/widgets.dart';
import 'package:undervoltage/domain/models/room.dart';
import 'package:undervoltage/presentation/history/history_screen.dart';
import 'package:undervoltage/presentation/lobby/lobby_screen.dart';
import 'package:undervoltage/presentation/main/main_screen.dart';
import 'package:undervoltage/presentation/match/match_screen.dart';
import 'package:undervoltage/presentation/settings/settings_screen.dart';
import 'package:undervoltage/utils/locator.dart';

class Navigation {
  final Routes routes = Routes();

  static Navigation get get => locator<Navigation>();

  static BuildContext context() => get.routes.key.currentContext!;

  static void pop<T>([T? result]) => get.routes.pop(result);

  static void mainScreen() => get.routes.pushAlone(
        BasicRoute(
          MainScreen.instance(),
          name: 'main',
        ),
      );

  static void settingsScreen(bool pushAlone) {
    final FadeRoute route = FadeRoute(
      SettingsScreen.instance(pushAlone),
      name: 'settings',
    );

    if (pushAlone) {
      get.routes.pushAlone(route);
    } else {
      get.routes.push(route);
    }
  }

  static void historyScreen() => get.routes.push(
        BasicRoute(
          HistoryScreen.instance(),
          name: 'history',
        ),
      );

  static void lobbyScreen({
    required int version,
    required String matchType,
    required int numberOfPlayers,
  }) =>
      get.routes.push(
        BasicRoute(
          LobbyScreen.instance(
            version: version,
            matchType: matchType,
            numberOfPlayers: numberOfPlayers,
          ),
          name: 'lobby',
        ),
      );

  static void matchScreen(Room room) => get.routes.pushReplacement(
        BasicRoute(
          MatchScreen.instance(room),
          name: 'game',
        ),
      );
}
