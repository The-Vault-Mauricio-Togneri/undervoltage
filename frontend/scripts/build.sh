#!/usr/bin/env bash

set -e

flutter clean
dart lib/build/generate_version.dart
flutter build web -t lib/main/main_remote.dart --web-renderer canvaskit

OUTPUT="../website/public"
rm -r ${OUTPUT}
mkdir ${OUTPUT}
cp -r build/web/** ${OUTPUT}

cd ../website
firebase deploy --only hosting
cd ../frontend