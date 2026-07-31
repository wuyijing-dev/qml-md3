#!/usr/bin/env python3
"""Scan Md3 QML for interactive controls that may lack Accessible.name/role.

Usage:
  python scripts/checks/check_a11y_qml.py
  python scripts/checks/check_a11y_qml.py --json scripts/checks/out/a11y-scan.json

Exit 0 always (report); use --strict to exit 1 when findings > 0.
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
    ROOT / "src" / "Md3" / "window",
]

# Heuristic: files that define primary interactive surfaces.
INTERACTIVE_HINTS = re.compile(
    r"\b(MouseArea|Keys\.on|activeFocusOnTab|onClicked|AbstractButton|SelectionControl)\b"
)
HAS_ACCESSIBLE_NAME = re.compile(r"Accessible\.name\s*:")
HAS_ACCESSIBLE_ROLE = re.compile(r"Accessible\.role\s*:")
# Bases that already wire Accessible — child files often OK without redeclaring.
INHERITS_A11Y = re.compile(
    r"\b(Md3AbstractButton|Md3SelectionControl|Md3Control)\b"
)


def scan_file(path: Path) -> dict | None:
    text = path.read_text(encoding="utf-8", errors="replace")
    if not INTERACTIVE_HINTS.search(text):
        return None
    inherits = bool(INHERITS_A11Y.search(text))
    if inherits:
        return None
    has_name = bool(HAS_ACCESSIBLE_NAME.search(text))
    has_role = bool(HAS_ACCESSIBLE_ROLE.search(text))
    if has_name and has_role:
        return None
    issues = []
    if not has_name:
        issues.append("missing Accessible.name")
    if not has_role:
        issues.append("missing Accessible.role")
    return {
        "file": str(path.relative_to(ROOT)).replace("\\", "/"),
        "issues": issues,
    }


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
            hit = scan_file(path)
            if hit:
                findings.append(hit)

    report = {
        "root": str(ROOT),
        "count": len(findings),
        "findings": findings,
        "note": "Heuristic only — inherits Md3AbstractButton/SelectionControl are skipped.",
    }

    print(f"Md3 a11y scan: {len(findings)} file(s) may need Accessible.name/role")
    for f in findings[:40]:
        print(f"  - {f['file']}: {', '.join(f['issues'])}")
    if len(findings) > 40:
        print(f"  … {len(findings) - 40} more")

    if args.json:
        args.json.parent.mkdir(parents=True, exist_ok=True)
        args.json.write_text(json.dumps(report, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
        print(f"Wrote {args.json}")

    if args.strict and findings:
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
