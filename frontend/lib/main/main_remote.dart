import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tensionpath/app/tension_path.dart';
import 'package:tensionpath/environments/environment_remote.dart';
import 'package:tensionpath/utils/error_handler.dart';
import 'package:tensionpath/utils/locator.dart';

void main() {
  runZonedGuarded(() async {
    await Locator.load(RemoteEnvironment());
    runApp(const TensionPath());
  }, ErrorHandler.onUncaughtError);
}
