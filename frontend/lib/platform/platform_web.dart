import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:undervoltage/platform/platform_base.dart';
import 'package:undervoltage/utils/empty_url_strategy.dart';

class PlatformMethods extends PlatformMethodsBase {
  @override
  void urlStrategy() {
    setUrlStrategy(EmptyUrlStrategy());
  }
}
