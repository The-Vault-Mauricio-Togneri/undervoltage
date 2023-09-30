import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

abstract class BaseLocalized {
  String get buttonCancel;

  String get buttonCopyLink;

  String get buttonCreatePrivateMatch;

  String get buttonJoinPublicMatch;

  String get buttonOk;

  String get buttonSave;

  String get buttonShareLink;

  String dialogDisconnected(String param1);

  String get dialogLost;

  String get dialogTie;

  String get dialogWon;

  String get errorCannotConnectToServer;

  String fieldCantBeEmpty(String param1);

  String get inputAudio;

  String get inputName;

  String get menuLeaderboard;

  String get menuPlay;

  String get menuProfile;

  String get messageGetReady;

  String get messageLoading;

  String get messageShareWaiting;

  String get messageWaiting;

  String get shareSubject;
}

class ENLocalized extends BaseLocalized {
  @override
  String get buttonCancel => 'Cancel';

  @override
  String get buttonCopyLink => 'Copy link';

  @override
  String get buttonCreatePrivateMatch => 'Create private match';

  @override
  String get buttonJoinPublicMatch => 'Join public match';

  @override
  String get buttonOk => 'Ok';

  @override
  String get buttonSave => 'Save';

  @override
  String get buttonShareLink => 'Share link';

  @override
  String dialogDisconnected(String param1) => '${param1.toString()} has disconnected';

  @override
  String get dialogLost => 'You lost!';

  @override
  String get dialogTie => "It's a tie!";

  @override
  String get dialogWon => 'You won!';

  @override
  String get errorCannotConnectToServer => 'Error connecting to server';

  @override
  String fieldCantBeEmpty(String param1) => '${param1.toString()} cannot be empty';

  @override
  String get inputAudio => 'Audio';

  @override
  String get inputName => 'Name';

  @override
  String get menuLeaderboard => 'Leaderboard';

  @override
  String get menuPlay => 'Play';

  @override
  String get menuProfile => 'Profile';

  @override
  String get messageGetReady => 'Get ready!';

  @override
  String get messageLoading => 'Loading…';

  @override
  String get messageShareWaiting => 'Match created. Waiting for another player…';

  @override
  String get messageWaiting => 'Waiting for another player…';

  @override
  String get shareSubject => 'I challenge you!';
}

class ESLocalized extends BaseLocalized {
  @override
  String get buttonCancel => 'Cancelar';

  @override
  String get buttonCopyLink => 'Copiar enlace';

  @override
  String get buttonCreatePrivateMatch => 'Crear una partida privada';

  @override
  String get buttonJoinPublicMatch => 'Unirse a una partida pública';

  @override
  String get buttonOk => 'Ok';

  @override
  String get buttonSave => 'Guardar';

  @override
  String get buttonShareLink => 'Compartir enlace';

  @override
  String dialogDisconnected(String param1) => '${param1.toString()} se ha desconectado';

  @override
  String get dialogLost => '¡Has perdido!';

  @override
  String get dialogTie => '¡Empate!';

  @override
  String get dialogWon => '¡Has ganado!';

  @override
  String get errorCannotConnectToServer => 'Error conectándose al servidor';

  @override
  String fieldCantBeEmpty(String param1) => '${param1.toString()} no puede esta vacío';

  @override
  String get inputAudio => 'Audio';

  @override
  String get inputName => 'Nombre';

  @override
  String get menuLeaderboard => 'Clasificación';

  @override
  String get menuPlay => 'Jugar';

  @override
  String get menuProfile => 'Perfil';

  @override
  String get messageGetReady => '¡Prepárate!';

  @override
  String get messageLoading => 'Cargando…';

  @override
  String get messageShareWaiting => 'Partida creada. Esperando a otro jugador…';

  @override
  String get messageWaiting => 'Esperando a otro jugador…';

  @override
  String get shareSubject => '¡Te reto!';
}

class Localized {
  static late BaseLocalized get;
  static late Locale current;

  static List<Locale> locales = localized.keys.map(Locale.new).toList();

  static Map<String, BaseLocalized> localized = <String, BaseLocalized>{'en': ENLocalized(), 'es': ESLocalized()};

  static bool isSupported(Locale locale) => locales.map((Locale l) => l.languageCode).contains(locale.languageCode);

  static void load(Locale locale) {
    current = locale;
    get = localized[locale.languageCode]!;
  }
}

class CustomLocalizationsDelegate extends LocalizationsDelegate<dynamic> {
  const CustomLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => Localized.isSupported(locale);

  @override
  Future<dynamic> load(Locale locale) {
    Localized.load(locale);
    return SynchronousFuture<dynamic>(Object());
  }

  @override
  bool shouldReload(CustomLocalizationsDelegate old) => false;
}
