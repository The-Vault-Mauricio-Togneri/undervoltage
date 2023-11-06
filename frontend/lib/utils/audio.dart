import 'package:just_audio/just_audio.dart';
import 'package:undervoltage/persistence/storage/settings_storage.dart';
import 'package:undervoltage/utils/locator.dart';

class Audio {
  final Map<String, AudioPlayer> soundPlayers = {};
  bool enabled = true;

  static const String ERROR = 'error';

  static Audio get get => locator<Audio>();

  void toggle() {
    enabled = !enabled;
    SettingsStorage.saveAudio(enabled);
  }

  Future playSound(String sound) async {
    if (enabled) {
      await stopSound(sound);
      soundPlayers[sound]?.play();
    }
  }

  Future stopSound(String sound) async {
    await soundPlayers[sound]?.pause();
    await soundPlayers[sound]?.seek(Duration.zero);
  }

  Future load() async {
    enabled = await SettingsStorage.loadAudio();
    soundPlayers[ERROR] = await _getPlayer(ERROR);
  }

  Future<AudioPlayer> _getPlayer(String name) async {
    final AudioPlayer player = AudioPlayer();
    await player.setAsset('assets/audio/$name.mp3');

    return player;
  }
}
