import 'package:just_audio/just_audio.dart';
import 'package:undervoltage/services/initializer.dart';
import 'package:undervoltage/storage/settings_storage.dart';

class Audio {
  final Map<String, AudioPlayer> soundPlayers = {};
  final Map<String, AudioPlayer> musicPlayers = {};
  bool enabled = true;
  AudioPlayer? playerToResume;

  static const String MUSIC_MATCH = 'music_match';
  static const String SOUND_READY = 'sound_ready';
  static const String SOUND_INCREASE_MINE = 'increase_mine';
  static const String SOUND_INCREASE_ATTACK = 'increase_attack';
  static const String SOUND_ACCUMULATE_UNITS = 'accumulate_units';
  static const String SOUND_UNITS_LAUNCHED = 'units_launched';
  static const String SOUND_WALL_CRASH = 'wall_crash';
  static const String SOUND_MATCH_WON = 'match_won';
  static const String SOUND_MATCH_LOST = 'match_lost';
  static const String SOUND_MATCH_TIE = 'match_tie';
  static const String SOUND_LANE_REWARD_WON = 'lane_reward_won';
  static const String SOUND_LANE_REWARD_LOST = 'lane_reward_lost';
  static const String SOUND_LANE_WON = 'lane_won';
  static const String SOUND_LANE_LOST = 'lane_lost';
  static const String SOUND_WARNING_30_SECONDS = 'warning_30_seconds';
  static const String SOUND_COUNTDOWN = 'countdown';
  static const String SOUND_PLAYER_DISCONNECTED = 'player_disconnected';

  static Audio get get => getIt<Audio>();

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

  Future playMusic(String music) async {
    if (enabled) {
      await stopMusic();
      await musicPlayers[music]?.seek(const Duration(seconds: 0));
      musicPlayers[music]?.setVolume(0.2);
      musicPlayers[music]?.play();
    }
  }

  void pauseMusic() {
    for (final AudioPlayer player in musicPlayers.values) {
      if (player.playing) {
        playerToResume = player;
        break;
      }
    }

    playerToResume?.pause();
  }

  void resumeMusic() {
    playerToResume?.play();
    playerToResume = null;
  }

  Future stopMusic() async {
    for (final AudioPlayer player in musicPlayers.values) {
      await player.stop();
    }
  }

  void dispose() {
    stopMusic();
    soundPlayers.forEach((key, player) => player.dispose());
    musicPlayers.forEach((key, player) => player.dispose());
  }

  Future load() async {
    enabled = await SettingsStorage.loadAudio();

    musicPlayers[MUSIC_MATCH] = await _getPlayer(MUSIC_MATCH, LoopMode.one);

    soundPlayers[SOUND_READY] = await _getPlayer(SOUND_READY);
    soundPlayers[SOUND_INCREASE_MINE] = await _getPlayer(SOUND_INCREASE_MINE);
    soundPlayers[SOUND_INCREASE_ATTACK] = await _getPlayer(SOUND_INCREASE_ATTACK);
    soundPlayers[SOUND_ACCUMULATE_UNITS] = await _getPlayer(SOUND_ACCUMULATE_UNITS);
    soundPlayers[SOUND_UNITS_LAUNCHED] = await _getPlayer(SOUND_UNITS_LAUNCHED);
    soundPlayers[SOUND_WALL_CRASH] = await _getPlayer(SOUND_WALL_CRASH);
    soundPlayers[SOUND_MATCH_WON] = await _getPlayer(SOUND_MATCH_WON);
    soundPlayers[SOUND_MATCH_LOST] = await _getPlayer(SOUND_MATCH_LOST);
    soundPlayers[SOUND_MATCH_TIE] = await _getPlayer(SOUND_MATCH_TIE);
    soundPlayers[SOUND_LANE_REWARD_WON] = await _getPlayer(SOUND_LANE_REWARD_WON);
    soundPlayers[SOUND_LANE_REWARD_LOST] = await _getPlayer(SOUND_LANE_REWARD_LOST);
    soundPlayers[SOUND_LANE_WON] = await _getPlayer(SOUND_LANE_WON);
    soundPlayers[SOUND_LANE_LOST] = await _getPlayer(SOUND_LANE_LOST);
    soundPlayers[SOUND_WARNING_30_SECONDS] = await _getPlayer(SOUND_WARNING_30_SECONDS);
    soundPlayers[SOUND_COUNTDOWN] = await _getPlayer(SOUND_COUNTDOWN);
    soundPlayers[SOUND_PLAYER_DISCONNECTED] = await _getPlayer(SOUND_PLAYER_DISCONNECTED);
  }

  Future<AudioPlayer> _getPlayer(String name, [LoopMode loopMode = LoopMode.off]) async {
    final AudioPlayer player = AudioPlayer();
    await player.setAsset('assets/audio/$name.mp3');

    if (loopMode != LoopMode.off) {
      await player.setLoopMode(loopMode);
    }

    return player;
  }
}
