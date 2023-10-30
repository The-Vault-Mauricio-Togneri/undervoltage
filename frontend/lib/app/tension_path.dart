import 'package:flutter/material.dart';
import 'package:tensionpath/presentation/splash/splash_screen.dart';
import 'package:tensionpath/utils/navigation.dart';
import 'package:tensionpath/utils/palette.dart';

class TensionPath extends StatelessWidget {
  const TensionPath();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tension Path',
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
