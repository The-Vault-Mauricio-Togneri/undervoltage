#!/usr/bin/env bash

set -e

BASE_DIR=`dirname $0`

FORMAT="json"
TOKEN="a6960eee-78d5-41fc-af60-17f057e5467c"
URL="https://script.google.com/macros/s/AKfycbzTusLIHZQ3KnrYwtgCuxbmU5DTLhMbnl4UxVysQ1qKnxhR4J0W3hCTKBSamddqctY/exec"

wget -O "${BASE_DIR}/../assets/i18n/en.json" "${URL}?locale=en&format=${FORMAT}&token=${TOKEN}"
wget -O "${BASE_DIR}/../assets/i18n/es.json" "${URL}?locale=es&format=${FORMAT}&token=${TOKEN}"

flutter pub upgrade
flutter pub pub run dalocale:dalocale.dart ./assets/i18n/ ./lib/services/localizations.dart en ./lib
flutter format lib --line-length=150