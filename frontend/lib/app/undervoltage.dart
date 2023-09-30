import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:undervoltage/screens/splash_screen.dart';
import 'package:undervoltage/services/localizations.dart';
import 'package:undervoltage/services/navigation.dart';
import 'package:undervoltage/services/palette.dart';

class Undervoltage extends StatelessWidget {
  final Uri uri;

  const Undervoltage({required this.uri});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Idle Battle',
      debugShowCheckedModeBanner: false,
      navigatorKey: Navigation.get.routes.key,
      theme: ThemeData(
        primarySwatch: Palette.primary,
        scaffoldBackgroundColor: Palette.white,
      ),
      localizationsDelegates: const [
        CustomLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: Localized.locales,
      home: SplashScreen(uri: Uri.base),
    );
  }
}
