"""Uniform Qt for Python imports from the detected PySide binding.

::

    from md3qml.qt import QtCore, QtGui, QtQml, QtQuick, QObject, Slot, Signal, Property
"""

from __future__ import annotations

from importlib import import_module
from typing import Any, Optional

from .binding import Binding, detect_binding

_binding: Optional[Binding] = None


def use_binding(prefer: Optional[str] = None) -> Binding:
    """Select PySide6 / PySide2 before importing Qt symbols."""
    global _binding
    _binding = detect_binding(prefer)
    return _binding


def current_binding() -> Binding:
    global _binding
    if _binding is None:
        _binding = detect_binding()
    return _binding


def _qt_module(name: str) -> Any:
    return import_module(f"{current_binding().name}.{name}")


# Resolved lazily on first attribute access so `import md3qml` works without PySide.
QtCore: Any
QtGui: Any
QtQml: Any
QtQuick: Any
QtQuickControls2: Any
QObject: Any
Signal: Any
Slot: Any
Property: Any
QUrl: Any
QGuiApplication: Any
QQmlApplicationEngine: Any
QQuickWindow: Any


def __getattr__(name: str) -> Any:
    mapping = {
        "QtCore": "QtCore",
        "QtGui": "QtGui",
        "QtQml": "QtQml",
        "QtQuick": "QtQuick",
        "QtQuickControls2": "QtQuickControls2",
    }
    if name in mapping:
        mod = _qt_module(mapping[name])
        globals()[name] = mod
        return mod
    core = _qt_module("QtCore")
    gui = _qt_module("QtGui")
    qml = _qt_module("QtQml")
    quick = _qt_module("QtQuick")
    table = {
        "QObject": core.QObject,
        "Signal": core.Signal,
        "Slot": core.Slot,
        "Property": core.Property,
        "QUrl": core.QUrl,
        "QGuiApplication": gui.QGuiApplication,
        "QQmlApplicationEngine": qml.QQmlApplicationEngine,
        "QQuickWindow": quick.QQuickWindow,
    }
    if name in table:
        globals()[name] = table[name]
        return table[name]
    raise AttributeError(f"module {__name__!r} has no attribute {name!r}")


__all__ = [
    "use_binding",
    "current_binding",
    "QtCore",
    "QtGui",
    "QtQml",
    "QtQuick",
    "QtQuickControls2",
    "QObject",
    "Signal",
    "Slot",
    "Property",
    "QUrl",
    "QGuiApplication",
    "QQmlApplicationEngine",
    "QQuickWindow",
]
