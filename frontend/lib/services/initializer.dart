import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:undervoltage/services/logged_user.dart';
import 'package:undervoltage/services/navigation.dart';
import 'package:undervoltage/services/platform.dart';

final GetIt getIt = GetIt.instance;

class Initializer {
  static Future load() async {
    WidgetsFlutterBinding.ensureInitialized();

    if (Platform.isWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'AIzaSyDWAZs8_dNgfZl6EpLnTI7_P-JRvh4SzBI',
          authDomain: 'tensionplanet.firebaseapp.com',
          databaseURL:
              'https://tensionplanet-default-rtdb.europe-west1.firebasedatabase.app',
          projectId: 'tensionplanet',
          storageBucket: 'tensionplanet.appspot.com',
          messagingSenderId: '589993680424',
          appId: '1:589993680424:web:3f2329afb4dc7c37819f1d',
          measurementId: 'G-P4V5HZYCMR',
        ),
      );
    } else {
      await Firebase.initializeApp();
    }

    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    //setPathUrlStrategy();
    getIt.registerSingleton<Navigation>(Navigation());
    getIt.registerSingleton<LoggedUser>(LoggedUser());
  }
}
