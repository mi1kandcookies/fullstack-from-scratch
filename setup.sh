#!/usr/bin/env bash
# fullstack-from-scratch — entry point. Detects the OS and runs its script.
set -euo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
case "$(uname -s)" in
  Darwin) exec bash "$here/scripts/mac.sh" "$@" ;;
  Linux)  exec bash "$here/scripts/linux.sh" "$@" ;;
  *)
    echo "This is not macOS or Linux. On Windows run: .\\scripts\\windows.ps1" >&2
    exit 1 ;;
esac
