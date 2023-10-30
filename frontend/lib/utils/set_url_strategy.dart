import 'package:tensionpath/platform/platform_mobile.dart'
    if (dart.library.html) 'package:tensionpath/platform/platform_web.dart';

class SetUrlStrategy {
  static void set() => PlatformMethods().urlStrategy();
}
