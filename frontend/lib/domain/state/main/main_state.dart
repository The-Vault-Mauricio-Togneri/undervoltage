import 'package:dafluta/dafluta.dart';
import 'package:undervoltage/utils/navigation.dart';

class MainState extends BaseState {
  int numberOfPlayers = 2;
  final List<bool> selectedPlayers = [
    true,
    false,
    false,
  ];

  void onSelectPlayers(int index) {
    for (int i = 0; i < selectedPlayers.length; i++) {
      selectedPlayers[i] = i == index;
    }

    numberOfPlayers = index + 2;
    notify();
  }

  void onSettings() => Navigation.settingsScreen(false);

  void onHistory() => Navigation.historyScreen();

  void onMatchmaking() => Navigation.lobbyScreen(
        version: 1,
        matchType: 'undervoltage',
        numberOfPlayers: numberOfPlayers,
      );
}
