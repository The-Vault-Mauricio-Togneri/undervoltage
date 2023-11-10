#!/usr/bin/env bash

dart compile exe lib/main/main_local.dart -o output/undervoltage

while true; do
    ./output/undervoltage "foo" 3000
    echo "Restarting server"
done