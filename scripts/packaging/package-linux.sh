#!/usr/bin/env bash
# Wrapper around packaging/cli.py (Linux). Prefer: python scripts/packaging/cli.py
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
exec python3 "$ROOT/scripts/packaging/cli.py" "$@"
