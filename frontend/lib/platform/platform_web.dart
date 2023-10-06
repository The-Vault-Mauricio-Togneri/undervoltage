import 'dart:html';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:undervoltage/platform/platform_base.dart';
import 'package:undervoltage/utils/empty_url_strategy.dart';

class PlatformMethods extends PlatformMethodsBase {
  @override
  void clipboard(String text) {
    try {
      final textarea = TextAreaElement();
      document.body!.append(textarea);
      textarea.style.border = '0';
      textarea.style.margin = '0';
      textarea.style.padding = '0';
      textarea.style.opacity = '0';
      textarea.style.position = 'absolute';
      textarea.readOnly = true;
      textarea.value = text;
      textarea.select();
      document.execCommand('copy');
      textarea.remove();
    } catch (e) {
      // ignore
    }
  }

  @override
  void urlStrategy() {
    setUrlStrategy(EmptyUrlStrategy());
  }
}
