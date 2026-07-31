"""Detect PySide6 (Qt6) and expose a uniform Qt surface."""

from __future__ import annotations

from dataclasses import dataclass
from types import ModuleType
from typing import Any, Optional, Tuple


@dataclass(frozen=True)
class Binding:
    name: str
    qt_major: int
    module: ModuleType

    @property
    def is_pyside6(self) -> bool:
        return self.qt_major >= 6

    @property
    def is_pyside2(self) -> bool:
        return False


def detect_binding(prefer: Optional[str] = None) -> Binding:
    """
    Resolve Qt for Python. Md3 requires **PySide6** (Qt 6.5+).

    ``prefer`` may be ``\"PySide6\"`` / ``\"6\"`` / ``None``. PySide2 is not supported.
    """
    if prefer:
        p = prefer.strip().lower().replace("-", "")
        if p in ("pyside2", "5", "qt5"):
            raise ImportError(
                "PySide2 / Qt5 is not supported. Install PySide6 (Qt 6.5+):\n"
                "  pip install PySide6"
            )
        if p not in ("pyside6", "6", "qt6", "auto", ""):
            raise ValueError(f"Unknown binding prefer={prefer!r}; use PySide6")

    try:
        mod = __import__("PySide6")
        return Binding(name="PySide6", qt_major=6, module=mod)
    except ImportError as exc:
        raise ImportError(
            "PySide6 is required for Md3.\n"
            "  pip install PySide6\n"
            f"({exc})"
        ) from exc


def import_qt(binding: Optional[Binding] = None) -> Tuple[Binding, Any]:
    """
    Import QtGui / QtQml / QtQuick / QtQuickControls2 under one namespace object.

    Returns (binding, qt) where qt has attributes:
      QGuiApplication, QQmlApplicationEngine, QQuickWindow, QQuickStyle,
      QUrl, QCoreApplication, Qt (optional)
    """
    binding = binding or detect_binding()
    name = binding.name

    from importlib import import_module

    class _Qt:
        pass

    qt = _Qt()
    qt.QGuiApplication = import_module(f"{name}.QtGui").QGuiApplication
    qt.QQuickWindow = import_module(f"{name}.QtQuick").QQuickWindow
    qt.QQmlApplicationEngine = import_module(f"{name}.QtQml").QQmlApplicationEngine
    qt.QUrl = import_module(f"{name}.QtCore").QUrl
    qt.QCoreApplication = import_module(f"{name}.QtCore").QCoreApplication

    try:
        qt.QQuickStyle = import_module(f"{name}.QtQuickControls2").QQuickStyle
    except ImportError:
        qt.QQuickStyle = import_module(f"{name}.QtQuick.Controls").QQuickStyle

    return binding, qt
