import 'package:undervoltage/persistence/storage/base_storage.dart';

class SettingsStorage extends Storage {
  static const FIELD_AUDIO = 'settings.audio';

  static Future saveAudio(bool value) => Storage.setBool(FIELD_AUDIO, value);

  static Future<bool> loadAudio() => Storage.getBool(FIELD_AUDIO, true);
}
