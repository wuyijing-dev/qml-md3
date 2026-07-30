#!/usr/bin/env bash
# Legacy wrapper — use: python scripts/package.py
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
exec python3 "$ROOT/scripts/package.py" "$@"
