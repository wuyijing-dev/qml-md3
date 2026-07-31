"""High-level Application / Engine helpers (embed Md3 without calling run())."""

from __future__ import annotations

from pathlib import Path
from typing import Any, Callable, Dict, List, Optional, Sequence

from .binding import Binding, detect_binding, import_qt
from .paths import PathLike, resolve_md3_prefix, setup_native_paths
from .run import RunOptions, _sanitize_desktop_id


class Md3Application:
    """
    Long-lived host for apps that need the QML engine handle (context props, signals).

    Typical use::

        app = Md3Application(opts)
        app.load_file("Main.qml")
        raise SystemExit(app.exec())
    """

    def __init__(self, opts: Optional[RunOptions] = None, argv: Optional[List[str]] = None) -> None:
        import sys

        self.opts = opts or RunOptions()
        self.argv = list(sys.argv if argv is None else argv)
        self.binding: Binding = detect_binding(self.opts.binding)
        if self.opts.require_qt6_for_md3 and self.binding.qt_major < 6:
            raise RuntimeError(
                "Md3 QML requires PySide6 / Qt 6. "
                "Set require_qt6_for_md3=False only for non-Md3 QML."
            )
        self._qt: Any
        self.binding, self._qt = import_qt(self.binding)

        if self.opts.alpha_buffer:
            self._qt.QQuickWindow.setDefaultAlphaBuffer(True)

        self.app = self._qt.QGuiApplication(self.argv)
        qt = self._qt
        qt.QCoreApplication.setOrganizationName(self.opts.organization)
        qt.QCoreApplication.setApplicationName(self.opts.application_name)
        qt.QCoreApplication.setApplicationVersion(self.opts.application_version)
        if self.opts.style:
            qt.QQuickStyle.setStyle(self.opts.style)

        desk = _sanitize_desktop_id(self.opts.desktop_file_name or self.opts.application_name)
        set_desk = getattr(self.app, "setDesktopFileName", None)
        if callable(set_desk):
            set_desk(desk)

        if self.opts.app_user_model_id and self.binding.is_pyside6:
            # Best-effort; Windows AUMID is normally set via C++ / env before GUI.
            pass

        self.engine = qt.QQmlApplicationEngine()
        self._prefix: Optional[Path] = None
        self._import_paths: List[str] = []
        self._context: Dict[str, Any] = dict(self.opts.context_properties)

    def prepare_imports(self, *, start: Optional[PathLike] = None) -> Path:
        prefix = resolve_md3_prefix(self.opts.md3_prefix, start=start)
        self._prefix = prefix
        paths = setup_native_paths(prefix, extra_import_paths=self.opts.extra_import_paths)
        self._import_paths = list(paths)
        for p in self._import_paths:
            self.engine.addImportPath(p)
        return prefix

    def set_context_property(self, name: str, value: Any) -> None:
        self._context[name] = value
        ctx = self.engine.rootContext()
        ctx.setContextProperty(name, value)

    def _apply_context(self) -> None:
        ctx = self.engine.rootContext()
        for name, value in self._context.items():
            ctx.setContextProperty(name, value)

    def load_file(self, qml: PathLike) -> bool:
        qml_path = Path(qml).resolve()
        if not qml_path.is_file():
            raise FileNotFoundError(qml_path)
        if self._prefix is None:
            self.prepare_imports(start=qml_path.parent)
        self.engine.addImportPath(str(qml_path.parent))
        self._apply_context()
        url = self._qt.QUrl.fromLocalFile(str(qml_path))
        self.engine.load(url)
        return bool(self.engine.rootObjects())

    def load_module(self, uri: str, component: str = "Main") -> bool:
        if self._prefix is None:
            self.prepare_imports()
        self._apply_context()
        load_from = getattr(self.engine, "loadFromModule", None)
        if not callable(load_from):
            raise RuntimeError("loadFromModule requires Qt 6 / PySide6")
        load_from(uri, component)
        return bool(self.engine.rootObjects())

    def root_objects(self) -> Sequence[Any]:
        return self.engine.rootObjects()

    def exec(self) -> int:
        app = self.app
        return app.exec() if hasattr(app, "exec") else app.exec_()

    def on_quit(self, callback: Callable[[], None]) -> None:
        self.app.aboutToQuit.connect(callback)
