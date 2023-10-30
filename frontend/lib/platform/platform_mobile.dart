import 'package:flutter/services.dart';
import 'package:tensionpath/platform/platform_base.dart';

class PlatformMethods extends PlatformMethodsBase {
  @override
  void clipboard(String text) {
    try {
      Clipboard.setData(ClipboardData(text: text));
    } catch (e) {
      // ignore
    }
  }

  @override
  void urlStrategy() {}
}
