#!/usr/bin/env python3
"""Strip Co-authored-by: Cursor from commit messages (Windows-friendly hook)."""
from __future__ import annotations

import re
import sys
from pathlib import Path

def main() -> int:
    if len(sys.argv) < 2:
        return 0
    path = Path(sys.argv[1])
    if not path.is_file():
        return 0
    text = path.read_text(encoding="utf-8", errors="replace")
    cleaned = re.sub(
        r"(?im)^Co-authored-by:\s*Cursor\b.*(?:\r?\n)?",
        "",
        text,
    )
    if cleaned != text:
        path.write_text(cleaned, encoding="utf-8", newline="\n")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
