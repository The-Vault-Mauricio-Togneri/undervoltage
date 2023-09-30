import 'dart:async';
import 'package:dafluta/dafluta.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:undervoltage/services/logged_user.dart';
import 'package:undervoltage/services/navigation.dart';
import 'package:undervoltage/widgets/game_container.dart';

class SplashScreen extends StatelessWidget {
  final SplashState state;

  SplashScreen({required Uri uri}) : state = SplashState(uri: uri);

  @override
  Widget build(BuildContext context) {
    return const GameContainer(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class SplashState extends BaseState {
  final Uri uri;

  SplashState({required this.uri});

  @override
  Future onLoad() async {
    //await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
    StreamSubscription? subscription;
    subscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      subscription?.cancel();
      _processUser(user);
    });
  }

  Future _processUser(User? user) async {
    final User signedUser = await _getSignedUser(user);
    LoggedUser.get.load(signedUser);
    Navigation.lobbyScreen(uri);
  }

  Future<User> _getSignedUser(User? user) async => user ?? (await FirebaseAuth.instance.signInAnonymously()).user!;
}
