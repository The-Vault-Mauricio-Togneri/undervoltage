import 'package:flutter/material.dart';
import 'package:undervoltage/presentation/splash/splash_screen.dart';
import 'package:undervoltage/utils/navigation.dart';
import 'package:undervoltage/utils/palette.dart';

class Undervoltage extends StatelessWidget {
  const Undervoltage();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Undervoltage',
      debugShowCheckedModeBanner: false,
      navigatorKey: Navigation.get.routes.key,
      theme: ThemeData(
        primaryColor: Palette.primary,
        primarySwatch: Palette.primary,
        scaffoldBackgroundColor: Palette.white,
      ),
      home: SplashScreen.instance(),
    );
  }
}
