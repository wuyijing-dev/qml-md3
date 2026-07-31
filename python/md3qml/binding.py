"""Detect PySide6 (Qt6) or PySide2 (Qt5) and expose a uniform Qt surface."""

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
        return self.qt_major == 5


def detect_binding(prefer: Optional[str] = None) -> Binding:
    """
    Resolve a Qt for Python binding.

    prefer: \"PySide6\" | \"PySide2\" | None (try 6 then 2)
    """
    order = []
    if prefer:
        p = prefer.strip().lower().replace("-", "")
        if p in ("pyside6", "6", "qt6"):
            order = ["PySide6", "PySide2"]
        elif p in ("pyside2", "5", "qt5"):
            order = ["PySide2", "PySide6"]
        else:
            raise ValueError(f"Unknown binding prefer={prefer!r}; use PySide6 or PySide2")
    else:
        order = ["PySide6", "PySide2"]

    errors = []
    for name in order:
        try:
            mod = __import__(name)
            major = 6 if name == "PySide6" else 5
            return Binding(name=name, qt_major=major, module=mod)
        except ImportError as exc:
            errors.append(f"{name}: {exc}")

    raise ImportError(
        "Neither PySide6 nor PySide2 is installed.\n"
        "  pip install PySide6          # recommended — matches Md3 Qt6 module\n"
        "  pip install PySide2          # Qt5 only; Md3 QML module needs Qt6 today\n"
        + "\n".join(errors)
    )


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
        # Older wheels may expose style via QtQuick.Controls
        qt.QQuickStyle = import_module(f"{name}.QtQuick.Controls").QQuickStyle

    return binding, qt
