#!/usr/bin/env python3
"""Regression guards for performance contracts (Rail hover, docs anchors).

Usage:
  python scripts/checks/check_perf_guards.py
  python scripts/checks/check_perf_guards.py --strict

Exit 0 when all guards pass; with --strict, exit 1 on any failure.
Without --strict, always exit 0 after printing a report (CI-friendly soft mode).
"""
from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]


def _read(rel: str) -> str:
    return (ROOT / rel).read_text(encoding="utf-8", errors="replace")


def check_rail_hover_gates() -> list[str]:
    failures: list[str] = []
    rail = _read("src/Md3/components/Md3NavigationRail.qml")
    body = _read("src/Md3/window/Md3WindowBody.qml")
    host = _read("src/Md3/window/Md3PageHost.qml")

    if not re.search(
        r"onEntered:\s*\{[^}]*!root\.scrolling[^}]*destinationHovered",
        rail,
        re.DOTALL,
    ):
        failures.append(
            "Md3NavigationRail: onEntered must gate destinationHovered with !scrolling"
        )

    if "if (rail.scrolling)" not in body or "host.prefetchHint" not in body:
        failures.append(
            "Md3WindowBody: destinationHovered must skip prefetchHint while rail.scrolling"
        )

    if "clearAllPrefetchHints" not in host:
        failures.append("Md3PageHost: missing clearAllPrefetchHints()")

    if "onScrollingChanged" not in body or "clearAllPrefetchHints" not in body:
        failures.append(
            "Md3WindowBody: onScrollingChanged must call host.clearAllPrefetchHints()"
        )

    return failures


def check_docs_anchors() -> list[str]:
    failures: list[str] = []
    perf = _read("docs/topics/performance.md")
    required = [
        "## Charts：Live / Wave 默认档位与 CPU 预算",
        "## Rail：拖动时禁止 hover 预编译",
        "## 大列表检查清单：`Md3VirtualList` + 禁止层叠 `layer.enabled`",
        "effectsLiveFps",
        "Md3VirtualList",
        "md3PageActive",
        "pagePrefetchL1",
    ]
    for needle in required:
        if needle not in perf:
            failures.append(f"docs/topics/performance.md: missing section/anchor {needle!r}")
    gate = ROOT / "docs/api/Md3PageActivityGate.md"
    if not gate.is_file():
        failures.append("docs/api/Md3PageActivityGate.md: missing")
    return failures


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument(
        "--strict",
        action="store_true",
        help="exit 1 when any guard fails",
    )
    args = ap.parse_args()

    failures = check_rail_hover_gates() + check_docs_anchors()
    if not failures:
        print("check_perf_guards: OK")
        return 0

    print(f"check_perf_guards: {len(failures)} failure(s)")
    for f in failures:
        print(f"  - {f}")
    return 1 if args.strict else 0


if __name__ == "__main__":
    sys.exit(main())
