"""Discover installed Qt6 kits for CMake (6.5+)."""

from __future__ import annotations

import os
import platform
import re
import shutil
import subprocess
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable


@dataclass(frozen=True)
class QtKit:
    prefix: Path
    major: int
    version: str
    kit: str

    @property
    def label(self) -> str:
        return f"Qt {self.major} {self.version} — {self.kit}  ({self.prefix})"

    def cmake_config(self) -> Path:
        name = f"Qt{self.major}Config.cmake"
        for rel in (
            f"lib/cmake/Qt{self.major}/{name}",
            f"lib64/cmake/Qt{self.major}/{name}",
            f"lib/x86_64-linux-gnu/cmake/Qt{self.major}/{name}",
        ):
            p = self.prefix / rel
            if p.is_file():
                return p
        return self.prefix / f"lib/cmake/Qt{self.major}/{name}"


def _run_text(cmd: list[str]) -> str | None:
    try:
        out = subprocess.check_output(cmd, stderr=subprocess.DEVNULL, text=True)
    except (OSError, subprocess.CalledProcessError):
        return None
    text = out.strip()
    return text or None


def _major_from_prefix(prefix: Path) -> int | None:
    if (prefix / "lib/cmake/Qt6/Qt6Config.cmake").is_file():
        return 6
    alt = prefix / "lib/x86_64-linux-gnu/cmake/Qt6/Qt6Config.cmake"
    if alt.is_file():
        return 6
    return None


def _version_from_prefix(prefix: Path, major: int) -> str:
    for name in ("QtCore/QtCoreConfig.cmake", f"Qt{major}Core/Qt{major}CoreConfig.cmake"):
        cfg = prefix / "lib/cmake" / name.replace("/", os.sep)
        if not cfg.is_file():
            continue
        try:
            text = cfg.read_text(encoding="utf-8", errors="ignore")
        except OSError:
            continue
        m = re.search(r"set\(QT_VERSION\s+\"?([0-9.]+)\"?\)", text)
        if m:
            return m.group(1)
    parts = prefix.parts
    for i, part in enumerate(parts):
        if re.fullmatch(r"\d+\.\d+(\.\d+)?", part):
            return part
    return "unknown"


def _kit_name(prefix: Path) -> str:
    return prefix.name or str(prefix)


def _kit_from_prefix(prefix: Path) -> QtKit | None:
    prefix = prefix.resolve()
    major = _major_from_prefix(prefix)
    if major is None:
        return None
    return QtKit(
        prefix=prefix,
        major=major,
        version=_version_from_prefix(prefix, major),
        kit=_kit_name(prefix),
    )


def _prefix_from_tool(tool: str) -> Path | None:
    if shutil.which(tool) is None:
        return None
    if "qtpaths" in tool:
        text = _run_text([tool, "--install-prefix"])
    else:
        text = _run_text([tool, "-query", "QT_INSTALL_PREFIX"])
    if not text:
        return None
    kit = _kit_from_prefix(Path(text))
    return kit.prefix if kit else None


def _scan_roots() -> Iterable[Path]:
    if platform.system() == "Windows":
        roots = [
            Path(r"D:\Qt"),
            Path(r"C:\Qt"),
            Path.home() / "Qt",
        ]
        kits = ("mingw_64", "msvc2022_64", "msvc2019_64", "msvc2022_arm64")
    else:
        roots = [
            Path.home() / "Qt",
            Path("/opt/Qt"),
            Path("/usr"),
        ]
        kits = ("gcc_64", "clang_64", "llvm")

    for root in roots:
        if not root.is_dir():
            continue
        if (root / "lib/cmake/Qt6/Qt6Config.cmake").is_file():
            yield root
            continue
        if root.name in kits or root.match("gcc_*") or root.match("msvc*"):
            yield root
            continue
        for ver_dir in sorted(root.glob("[0-9]*"), reverse=True):
            if not ver_dir.is_dir():
                continue
            for kit in kits:
                cand = ver_dir / kit
                if cand.is_dir():
                    yield cand


def discover_qt_kits() -> list[QtKit]:
    found: dict[str, QtKit] = {}

    env = os.environ.get("CMAKE_PREFIX_PATH", "").strip()
    if env:
        for chunk in re.split(r"[;:]", env):
            chunk = chunk.strip()
            if not chunk:
                continue
            kit = _kit_from_prefix(Path(chunk))
            if kit:
                found[str(kit.prefix)] = kit

    for tool in ("qmake6", "qtpaths6", "qmake", "qtpaths"):
        prefix = _prefix_from_tool(tool)
        if prefix is None:
            continue
        kit = _kit_from_prefix(prefix)
        if kit:
            found[str(kit.prefix)] = kit

    for cand in _scan_roots():
        kit = _kit_from_prefix(cand)
        if kit:
            found[str(kit.prefix)] = kit

    kits = list(found.values())
    kits.sort(key=lambda k: (k.major, _version_tuple(k.version), k.kit), reverse=True)
    return kits


def _version_tuple(version: str) -> tuple[int, int, int]:
    parts = []
    for chunk in version.split("."):
        try:
            parts.append(int(chunk))
        except ValueError:
            parts.append(0)
    while len(parts) < 3:
        parts.append(0)
    return parts[0], parts[1], parts[2]


def pick_default_kit(kits: list[QtKit]) -> QtKit | None:
    """Prefer newest Qt6 ≥ 6.5; fall back to any Qt6 kit."""
    if not kits:
        return None
    qt6 = [k for k in kits if k.major == 6]
    if not qt6:
        return None
    recent = [k for k in qt6 if _version_tuple(k.version) >= (6, 5, 0)]
    pool = recent or qt6
    pool.sort(key=lambda k: (_version_tuple(k.version), k.kit), reverse=True)
    return pool[0]
