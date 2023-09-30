import 'dart:io';

void main() {
  const String filePath = 'lib/build/build_version.dart';

  final File file = File(filePath);

  final String content = file.readAsStringSync();
  final RegExp regex = RegExp(r'BUILD_VERSION = ([0-9]*);');
  final RegExpMatch? match = regex.firstMatch(content);

  if (match != null) {
    final currentVersion = int.parse(match.group(1)!);
    final String content = 'const int BUILD_VERSION = ${currentVersion + 1};';
    file.writeAsStringSync(content, flush: true);
  }
}
