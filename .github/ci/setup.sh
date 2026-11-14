#!/usr/bin/env bash
set -euo pipefail

case "${1:-}" in
  quick|full) ;;
  *) echo 'Unknown CI tier' >&2; exit 2 ;;
esac

# GitHub-hosted runners only (public fork), across Linux/macOS/Windows:
# every job installs its own toolchain; setup only proves the tier reached
# a usable runner. RUNNER_OS is set by the runner on every platform;
# nproc does not exist on macOS, so it is not used here.
test -n "${RUNNER_OS:-}"
echo "CIFAST_SETUP tier=$1 runner=$RUNNER_OS"
