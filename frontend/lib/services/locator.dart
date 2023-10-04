import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:undervoltage/environments/environment.dart';
import 'package:undervoltage/services/logged_user.dart';
import 'package:undervoltage/services/navigation.dart';
import 'package:undervoltage/services/platform.dart';

final GetIt locator = GetIt.instance;

class Locator {
  static Future initialize(Environment environment) async {
    WidgetsFlutterBinding.ensureInitialized();

    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    if (Platform.isWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'AIzaSyBFYvrQb8TIXIVgQkLJImGHsyDpsr_dikQ',
          authDomain: 'undervoltage.firebaseapp.com',
          databaseURL:
              'https://undervoltage-default-rtdb.europe-west1.firebasedatabase.app',
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

    //setPathUrlStrategy();
    locator.registerSingleton<Environment>(environment);
    locator.registerSingleton<Navigation>(Navigation());
    locator.registerSingleton<LoggedUser>(LoggedUser());

    await environment.configure();
  }
}
