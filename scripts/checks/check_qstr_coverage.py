#!/usr/bin/env python3
"""Heuristic qsTr coverage for user-visible string literals in Md3 QML.

Flags patterns like:
  text: "Hardcoded"
  title: 'Hardcoded'
while allowing qsTr("…"), properties bound to identifiers, and empty strings.

Usage:
  python scripts/check_qstr_coverage.py
  python scripts/checks/check_qstr_coverage.py --json docs/i18n-scan.json
"""
from __future__ import annotations

import argparse
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SCAN_DIRS = [
    ROOT / "src" / "Md3" / "components",
    ROOT / "src" / "Md3" / "primitives",
    ROOT / "src" / "Md3" / "foundation",
    ROOT / "src" / "Md3" / "window",
    ROOT / "src" / "Md3" / "layout",
]

PROP = re.compile(
    r"""(?P<prop>\b(?:text|title|label|placeholderText|confirmText|dismissText|"""
    r"""subtitle|message|tooltip|headerLabel|accessibleName)\s*:\s*)"""
    r"""(?P<val>qsTr\s*\(|"[^"]*"|'[^']*')""",
    re.MULTILINE,
)


def scan_file(path: Path) -> list[dict]:
    text = path.read_text(encoding="utf-8", errors="replace")
    hits = []
    for m in PROP.finditer(text):
        val = m.group("val")
        if val.startswith("qsTr"):
            continue
        # empty or icon-only short tokens often intentional
        lit = val[1:-1]
        if not lit.strip():
            continue
        if len(lit) <= 2 and lit.isascii():
            continue
        line = text.count("\n", 0, m.start()) + 1
        hits.append({
            "file": str(path.relative_to(ROOT)).replace("\\", "/"),
            "line": line,
            "snippet": m.group(0)[:120],
        })
    return hits


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--json", type=Path, default=None)
    ap.add_argument("--strict", action="store_true")
    args = ap.parse_args()

    findings = []
    for d in SCAN_DIRS:
        if not d.is_dir():
            continue
        for path in sorted(d.rglob("*.qml")):
            findings.extend(scan_file(path))

    report = {"root": str(ROOT), "count": len(findings), "findings": findings}
    print(f"Md3 qsTr coverage: {len(findings)} hardcoded UI string(s)")
    for f in findings[:50]:
        print(f"  - {f['file']}:{f['line']}: {f['snippet']}")
    if len(findings) > 50:
        print(f"  … {len(findings) - 50} more")

    if args.json:
        args.json.parent.mkdir(parents=True, exist_ok=True)
        args.json.write_text(json.dumps(report, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
        print(f"Wrote {args.json}")

    if args.strict and findings:
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
