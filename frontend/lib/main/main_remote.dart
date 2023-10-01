import 'dart:async';
import 'package:flutter/material.dart';
import 'package:undervoltage/app/undervoltage.dart';
import 'package:undervoltage/environments/environment_remote.dart';
import 'package:undervoltage/services/locator.dart';
import 'package:undervoltage/utils/error_handler.dart';

void main() async {
  runZonedGuarded(() async {
    await Locator.initialize(RemoteEnvironment());
    runApp(Undervoltage(uri: Uri.base));
  }, ErrorHandler.onUncaughtError);
}
