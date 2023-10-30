#!/usr/bin/env bash

set -e

dart compile exe lib/main/main_remote.dart -o output/undervoltage
scp -s output/undervoltage max@zeronest.com:/home/max/undervoltage