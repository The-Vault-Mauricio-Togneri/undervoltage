import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:idlebattle/screens/splash_screen.dart';
import 'package:idlebattle/services/localizations.dart';
import 'package:idlebattle/services/navigation.dart';
import 'package:idlebattle/services/palette.dart';

class IdleBattleApp extends StatelessWidget {
  final Uri uri;

  const IdleBattleApp({required this.uri});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Idle Battle',
      debugShowCheckedModeBanner: false,
      navigatorKey: Navigation.get.routes.key,
      theme: ThemeData(
        primarySwatch: Palette.primary,
        backgroundColor: Palette.white,
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
