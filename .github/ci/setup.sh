#!/usr/bin/env bash
set -euo pipefail

case "${1:-}" in
  quick|full) ;;
  *) echo 'Unknown CI tier' >&2; exit 2 ;;
esac

# GitHub-hosted runners only (public fork): every job installs its own
# toolchain; setup only proves the tier reached a usable runner.
test "$(nproc)" -ge 2
echo "CIFAST_SETUP tier=$1 runner=$RUNNER_OS nproc=$(nproc)"
