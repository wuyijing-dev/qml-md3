"""QObject bridge helpers for stronger Python ↔ QML binding."""

from __future__ import annotations

from typing import Any, Callable, Optional, Sequence


def connect_signal(obj: Any, signal_name: str, slot: Callable[..., Any]) -> Any:
    """Connect ``obj.<signal_name>`` to ``slot``."""
    signal = getattr(obj, signal_name, None)
    if signal is None:
        raise AttributeError(f"{type(obj).__name__} has no signal {signal_name!r}")
    return signal.connect(slot)


def disconnect_signal(obj: Any, signal_name: str, slot: Optional[Callable[..., Any]] = None) -> None:
    signal = getattr(obj, signal_name, None)
    if signal is None:
        raise AttributeError(f"{type(obj).__name__} has no signal {signal_name!r}")
    if slot is None:
        signal.disconnect()
    else:
        signal.disconnect(slot)


def invoke(obj: Any, method: str, *args: Any) -> Any:
    """Call a QML / QObject invokable method by name."""
    fn = getattr(obj, method, None)
    if not callable(fn):
        raise AttributeError(f"{type(obj).__name__} has no callable {method!r}")
    return fn(*args)


def find_child(root: Any, name: str = "", *, class_name: str = "") -> Any:
    """
    Find a child QObject by ``objectName`` and/or meta-object class name.
    """
    if root is None:
        return None
    from .qt import QObject

    if name:
        child = root.findChild(QObject, name)
        if child is None:
            return None
        if not class_name:
            return child
        mo = child.metaObject()
        return child if mo and mo.className() == class_name else None

    if class_name and hasattr(root, "findChildren"):
        for child in root.findChildren(QObject):
            mo = child.metaObject()
            if mo and mo.className() == class_name:
                return child
    return None


def root_object(engine_or_app: Any, index: int = 0) -> Any:
    """Return ``rootObjects()[index]`` from an engine or ``Md3Application``."""
    if hasattr(engine_or_app, "root_objects"):
        roots: Sequence[Any] = list(engine_or_app.root_objects())
    elif hasattr(engine_or_app, "rootObjects"):
        roots = list(engine_or_app.rootObjects())
    elif hasattr(engine_or_app, "engine"):
        roots = list(engine_or_app.engine.rootObjects())
    else:
        raise TypeError("expected Md3Application, QQmlApplicationEngine, or similar")
    if index < 0 or index >= len(roots):
        raise IndexError(f"root object index {index} out of range (have {len(roots)})")
    return roots[index]


# Documented pattern (imported for convenience):
#
#   from md3qml.qt import QObject, Signal, Slot
#   class Host(QObject):
#       ping = Signal(str)
#       @Slot(str)
#       def log(self, text: str) -> None: ...
