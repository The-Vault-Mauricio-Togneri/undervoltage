import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:undervoltage/screens/leaderboard_screen.dart';
import 'package:undervoltage/screens/play_screen.dart';
import 'package:undervoltage/screens/profile_screen.dart';
import 'package:undervoltage/services/localizations.dart';
import 'package:undervoltage/services/palette.dart';
import 'package:undervoltage/widgets/game_container.dart';

class MainScreen extends StatelessWidget {
  final MainState state;

  const MainScreen._(this.state);

  factory MainScreen.instance({required Uri uri}) => MainScreen._(MainState(uri: uri));

  @override
  Widget build(BuildContext context) {
    return GameContainer(
      child: StateProvider<MainState>(
        state: state,
        builder: (context, state) => Content(state),
      ),
    );
  }
}

class Content extends StatelessWidget {
  final MainState state;

  const Content(this.state);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: state.getBody(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.leaderboard),
            label: Localized.get.menuLeaderboard,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.videogame_asset),
            label: Localized.get.menuPlay,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: Localized.get.menuProfile,
          ),
        ],
        currentIndex: state.page,
        selectedItemColor: Palette.primary,
        onTap: state.onChangePage,
      ),
    );
  }
}

class MainState extends BaseState {
  int page = 1;
  final Uri uri;

  MainState({required this.uri});

  void onChangePage(int index) {
    page = index;
    notify();
  }

  String? getMatchId() => uri.queryParameters['match'];

  Widget getBody() {
    if (page == 0) {
      return LeaderboardScreen();
    } else if (page == 1) {
      return PlayScreen(matchId: getMatchId());
    } else if (page == 2) {
      return ProfileScreen();
    } else {
      return const Empty();
    }
  }
}
