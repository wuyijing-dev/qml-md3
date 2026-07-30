"""Md3 library packaging — Qt discovery, CMake build, stage/install."""

from .core import PackageOptions, run_package
from .qt_detect import QtKit, discover_qt_kits, pick_default_kit

__all__ = [
    "PackageOptions",
    "QtKit",
    "discover_qt_kits",
    "pick_default_kit",
    "run_package",
]
