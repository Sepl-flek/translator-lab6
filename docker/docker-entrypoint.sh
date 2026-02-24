#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="${PROJECT_DIR:-/workspace}"
BUILD_DIR="${BUILD_DIR:-${PROJECT_DIR}/build}"
BIN="${BIN:-${BUILD_DIR}/main}"
TEST_SCRIPT="${TEST_SCRIPT:-${PROJECT_DIR}/examples/run_tests.sh}"
MODE="${1:-test}"

build_translator() {
  cmake -S "$PROJECT_DIR" -B "$BUILD_DIR" -DCMAKE_BUILD_TYPE=Release
  cmake --build "$BUILD_DIR" --parallel
}

run_tests_script() {
  if [[ ! -f "$TEST_SCRIPT" ]]; then
    echo "Test script not found: $TEST_SCRIPT"
    exit 1
  fi

  # Run script via bash with CRLF stripped on the fly (Windows-safe bind mount).
  tr -d '\r' < "$TEST_SCRIPT" | bash -s -- "$BIN"
}

if [[ "$#" -gt 0 ]]; then
  shift
fi

case "$MODE" in
  bash|sh)
    exec /bin/bash "$@"
    ;;
  run)
    if [[ "$#" -lt 1 ]]; then
      echo "Usage: run <path-to-input-file>"
      echo "Example: run /workspace/examples/valid/test.mini"
      exit 1
    fi
    build_translator
    exec "$BIN" "$1"
    ;;
  test)
    build_translator
    run_tests_script
    ;;
  *)
    build_translator
    exec "$BIN" "$MODE" "$@"
    ;;
esac