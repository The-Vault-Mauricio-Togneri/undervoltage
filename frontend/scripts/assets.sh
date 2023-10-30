#!/usr/bin/env bash

set -e

flutter clean
flutter pub upgrade
flutter pub pub run daassets:daassets.dart ./pubspec.yaml ./lib/services/assets.dart
sed -i'.original' -e 's/\.\/assets/assets/' "./lib/services/assets.dart"
rm "./lib/services/assets.dart.original"
flutter format lib