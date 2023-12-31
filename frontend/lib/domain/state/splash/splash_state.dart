import 'dart:async';
import 'package:dafluta/dafluta.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:undervoltage/domain/models/user_logged.dart';
import 'package:undervoltage/utils/audio.dart';
import 'package:undervoltage/utils/navigation.dart';

class SplashState extends BaseState {
  @override
  Future onLoad() async {
    await Audio.get.load();
    StreamSubscription? subscription;
    subscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      subscription?.cancel();
      _processUser(user);
    });
  }

  Future _processUser(User? user) async {
    final User signedUser = await _getSignedUser(user);
    LoggedUser.get.load(signedUser);

    if (LoggedUser.get.hasName) {
      Navigation.mainScreen();
    } else {
      Navigation.settingsScreen(true);
    }
  }

  Future<User> _getSignedUser(User? user) async {
    if (user != null) {
      return user;
    } else {
      final UserCredential credential =
          await FirebaseAuth.instance.signInAnonymously();

      return credential.user!;
    }
  }
}
