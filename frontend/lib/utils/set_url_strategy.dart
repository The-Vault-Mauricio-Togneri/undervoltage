import 'package:undervoltage/platform/platform_mobile.dart'
    if (dart.library.html) 'package:undervoltage/platform/platform_web.dart';

class SetUrlStrategy {
  static void set() => PlatformMethods().urlStrategy();
}
