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

  void onSettings() => Navigation.setNameScreen(false);

  void onMatchmaking() => Navigation.lobbyScreen(
        matchType: 'undervoltage',
        numberOfPlayers: numberOfPlayers,
      );
}
