import 'package:flutter/material.dart';
import 'package:undervoltage/domain/state/splash/splash_state.dart';
import 'package:undervoltage/widgets/base_screen.dart';

class SplashScreen extends StatelessWidget {
  final SplashState state;

  const SplashScreen._(this.state);

  factory SplashScreen.instance() => SplashScreen._(SplashState());

  @override
  Widget build(BuildContext context) {
    return const BaseScreen(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
