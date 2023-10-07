#!/usr/bin/env bash

set -e

cd functions
npm run build
firebase emulators:start