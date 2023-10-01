import 'package:dafluta/dafluta.dart';
import 'package:flutter/widgets.dart';
import 'package:undervoltage/screens/lobby_screen.dart';
import 'package:undervoltage/screens/set_name_screen.dart';
import 'package:undervoltage/services/initializer.dart';

class Navigation {
  final Routes routes = Routes();

  static Navigation get get => getIt<Navigation>();

  static void pop<T>([T? result]) => get.routes.pop();

  static BuildContext context() => get.routes.key.currentContext!;

  static void setNameScreen() => get.routes.pushAlone(
        FadeRoute(
          SetNameScreen.instance(),
          name: 'set_name',
        ),
      );

  static void lobbyScreen(Uri uri) => get.routes.pushAlone(
        FadeRoute(
          LobbyScreen.instance(uri: uri),
          name: 'lobby',
        ),
      );
}
