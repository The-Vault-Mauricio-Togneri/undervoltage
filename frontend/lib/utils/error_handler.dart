import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:undervoltage/utils/log.dart';

class ErrorHandler {
  static Future process(Object exception) {
    _logError(
      exception,
      null,
    );

    return FirebaseCrashlytics.instance.recordError(
      exception,
      null,
      fatal: false,
    );
  }

  static Future onUncaughtError(Object exception, StackTrace stackTrace) {
    _logError(
      exception,
      stackTrace,
    );

    return FirebaseCrashlytics.instance.recordError(
      exception,
      stackTrace,
      fatal: true,
    );
  }

  static void _logError(
    dynamic exception,
    StackTrace? stackTrace,
  ) {
    try {
      Log.error(exception, stackTrace);
    } catch (e) {
      debugPrint(exception.toString());
      debugPrint('Cannot log error in console');
    }
  }
}
