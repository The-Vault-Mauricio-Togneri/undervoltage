import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:undervoltage/services/platform.dart';
import 'package:undervoltage/utils/log.dart';

class ErrorHandler {
  static Future process(Object exception) => _logError(
        exception: exception,
        fatal: false,
      );

  static Future onUncaughtError(Object exception, StackTrace stackTrace) =>
      _logError(
        exception: exception,
        fatal: true,
        stackTrace: stackTrace,
      );

  static Future _logError({
    required dynamic exception,
    required bool fatal,
    StackTrace? stackTrace,
  }) {
    try {
      Log.error(exception, stackTrace);
    } catch (e) {
      debugPrint(exception.toString());
      debugPrint('Cannot log error in console');
    }

    if (Platform.isWeb) {
      return Future.value();
    } else {
      return FirebaseCrashlytics.instance.recordError(
        exception,
        stackTrace,
        fatal: fatal,
      );
    }
  }
}
