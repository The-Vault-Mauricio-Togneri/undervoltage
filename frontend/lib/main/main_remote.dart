import 'dart:async';
import 'package:flutter/material.dart';
import 'package:undervoltage/app/undervoltage.dart';
import 'package:undervoltage/environments/environment_remote.dart';
import 'package:undervoltage/utils/error_handler.dart';
import 'package:undervoltage/utils/locator.dart';

void main() {
  runZonedGuarded(() async {
    await Locator.load(RemoteEnvironment());
    runApp(const Undervoltage());
  }, ErrorHandler.onUncaughtError);
}
