import 'package:dafluta/dafluta.dart';
import 'package:flutter/widgets.dart';
import 'package:undervoltage/domain/models/room.dart';
import 'package:undervoltage/presentation/lobby/lobby_screen.dart';
import 'package:undervoltage/presentation/main/main_screen.dart';
import 'package:undervoltage/presentation/match/match_screen.dart';
import 'package:undervoltage/presentation/set_name/set_name_screen.dart';
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

  static void setNameScreen(bool pushAlone) {
    final FadeRoute route = FadeRoute(
      SetNameScreen.instance(pushAlone),
      name: 'set_name',
    );

    if (pushAlone) {
      get.routes.pushAlone(route);
    } else {
      get.routes.push(route);
    }
  }

  static void lobbyScreen({
    required String matchType,
    required int numberOfPlayers,
  }) =>
      get.routes.push(
        BasicRoute(
          LobbyScreen.instance(
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
