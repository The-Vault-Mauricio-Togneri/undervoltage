#!/usr/bin/env bash

set -e

flutter pub upgrade
flutter pub pub run dapublock:dapublock.dart .
flutter pub pub run daunused:daunused.dart . lib/main.dart -- lib/main/main.dart lib/generated_plugin_registrant.dart
flutter pub outdated
flutter pub upgrade --major-versions