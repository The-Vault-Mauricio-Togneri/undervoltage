import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:tensionpath/domain/model/user_logged.dart';
import 'package:tensionpath/environments/environment.dart';
import 'package:tensionpath/utils/navigation.dart';
import 'package:tensionpath/utils/set_url_strategy.dart';

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
          apiKey: 'AIzaSyBpGR88tMBiVA1Tvk48qQXqs1es7FaS2ac',
          authDomain: 'tension-path.firebaseapp.com',
          projectId: 'tension-path',
          storageBucket: 'tension-path.appspot.com',
          messagingSenderId: '183502893220',
          appId: '1:183502893220:web:2b1cc8c9b1378b23ecb631',
          measurementId: 'G-XBSE04LEGT',
        ),
      );
    } else {
      await Firebase.initializeApp();
    }

    SetUrlStrategy.set();

    locator.registerSingleton<Environment>(environment);
    locator.registerSingleton<Navigation>(Navigation());
    locator.registerSingleton<LoggedUser>(LoggedUser());

    await environment.configure();
  }
}
