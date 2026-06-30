#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd -P)"
TARGET_SCRIPT="${SCRIPT_DIR}/spotlight-dev-ignore"

if [[ ! -f "$TARGET_SCRIPT" ]]; then
  printf 'Missing delegated script: %s\n' "$TARGET_SCRIPT" >&2
  exit 1
fi

exec "$TARGET_SCRIPT" "$@"
