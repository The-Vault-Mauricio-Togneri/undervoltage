#!/usr/bin/env bash

set -e

flutter pub upgrade
flutter pub run build_runner build --delete-conflicting-outputs
dart format lib

rm -r ../frontend/lib/domain/json/game/*
rm -r ../frontend/lib/domain/json/messages/*

cp -r lib/domain/json/game/ ../frontend/lib/domain/json/
cp -r lib/domain/json/messages/ ../frontend/lib/domain/json/