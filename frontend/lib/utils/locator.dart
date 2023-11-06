import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:undervoltage/domain/models/user_logged.dart';
import 'package:undervoltage/environments/environment.dart';
import 'package:undervoltage/utils/audio.dart';
import 'package:undervoltage/utils/navigation.dart';
import 'package:undervoltage/utils/set_url_strategy.dart';

final GetIt locator = GetIt.instance;

class Locator {
  static Future load(Environment environment) async {
    WidgetsFlutterBinding.ensureInitialized();

    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'AIzaSyBFYvrQb8TIXIVgQkLJImGHsyDpsr_dikQ',
          authDomain: 'undervoltage.firebaseapp.com',
          projectId: 'undervoltage',
          storageBucket: 'undervoltage.appspot.com',
          messagingSenderId: '963808568802',
          appId: '1:963808568802:web:b9cb1b44dcc8ab50b045bb',
          measurementId: 'G-7RMJ54P739',
        ),
      );
    } else {
      await Firebase.initializeApp();
    }

    SetUrlStrategy.set();

    locator.registerSingleton<Environment>(environment);
    locator.registerSingleton<Navigation>(Navigation());
    locator.registerSingleton<LoggedUser>(LoggedUser());
    locator.registerSingleton<Audio>(Audio());

    await environment.configure();
  }
}
