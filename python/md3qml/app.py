"""High-level Application / Engine helpers (embed Md3 without calling run())."""

from __future__ import annotations

import sys
from pathlib import Path
from typing import Any, Callable, Dict, List, Optional, Sequence

from .binding import Binding, detect_binding, import_qt
from .paths import PathLike, resolve_md3_prefix, setup_native_paths
from .run import RunOptions, _sanitize_desktop_id


class Md3Application:
    """
    Long-lived host for apps that need the QML engine handle (context props, signals).

    Typical use::

        from md3qml import Md3Application, RunOptions
        from md3qml.qt import QObject, Signal, Slot

        class Host(QObject):
            ping = Signal(str)

            @Slot(str)
            def log(self, text: str) -> None:
                print(text)

        app = Md3Application(RunOptions(application_name="My App", auto_fetch=True))
        app.set_context_property("host", Host())
        app.load_file("Main.qml")
        raise SystemExit(app.exec())
    """

    def __init__(self, opts: Optional[RunOptions] = None, argv: Optional[List[str]] = None) -> None:
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

        if self.opts.print_banner:
            from .banner import print_banner

            print_banner(self.opts.application_name, self.opts.application_version)

        desk = _sanitize_desktop_id(self.opts.desktop_file_name or self.opts.application_name)
        set_desk = getattr(self.app, "setDesktopFileName", None)
        if callable(set_desk):
            set_desk(desk)

        if self.opts.app_user_model_id and self.binding.is_pyside6:
            # Applied in prepare_imports() via WindowHelper once Md3 is on the import path.
            pass

        self.engine = qt.QQmlApplicationEngine()
        self._prefix: Optional[Path] = None
        self._import_paths: List[str] = []
        self._context: Dict[str, Any] = dict(self.opts.context_properties)
        self._warnings: List[str] = []
        self._native: Any = None

        # Surface QML errors to Python (PySide6).
        warn = getattr(self.engine, "warnings", None)
        if warn is not None and hasattr(warn, "connect"):
            warn.connect(self._on_engine_warnings)
        failed = getattr(self.engine, "objectCreationFailed", None)
        if failed is not None and hasattr(failed, "connect"):
            failed.connect(self._on_object_creation_failed)

    def _on_engine_warnings(self, warnings: Any) -> None:
        for w in warnings or []:
            text = str(getattr(w, "toString", lambda: w)())
            self._warnings.append(text)
            print(f"md3qml QML: {text}", file=sys.stderr)

    def _on_object_creation_failed(self, url: Any) -> None:
        msg = f"objectCreationFailed: {url}"
        self._warnings.append(msg)
        print(f"md3qml: {msg}", file=sys.stderr)

    @property
    def warnings(self) -> List[str]:
        return list(self._warnings)

    @property
    def prefix(self) -> Optional[Path]:
        return self._prefix

    @property
    def import_paths(self) -> List[str]:
        return list(self._import_paths)

    @property
    def native(self) -> Any:
        """
        C++ ``Md3WindowHelper`` facade (``md3qml.native.WindowHelper``).

        Created lazily after import paths are prepared. Call ``prepare_imports()``
        or ``load_file()`` first. After load, defaults ``window`` to the first root.
        """
        return self.ensure_native()

    def ensure_native(self) -> Any:
        if self._native is not None:
            return self._native
        if self._prefix is None:
            self.prepare_imports()
        from .native import create_window_helper

        self._native = create_window_helper(self.engine, parent=self.engine)
        roots = list(self.engine.rootObjects())
        if roots:
            self._native.set_default_window(roots[0])
        return self._native

    def prepare_imports(self, *, start: Optional[PathLike] = None) -> Path:
        try:
            prefix = resolve_md3_prefix(self.opts.md3_prefix, start=start)
        except FileNotFoundError:
            if not self.opts.auto_fetch:
                raise
            prefix = self._auto_fetch_prefix()
        self._prefix = prefix
        paths = setup_native_paths(prefix, extra_import_paths=self.opts.extra_import_paths)
        self._import_paths = list(paths)
        for p in self._import_paths:
            self.engine.addImportPath(p)
        if self.opts.load_fonts:
            self._try_load_fonts(prefix)
        if self.opts.app_user_model_id:
            self._try_set_app_user_model_id(self.opts.app_user_model_id)
        return prefix

    def _try_load_fonts(self, prefix: Path) -> None:
        try:
            from .capi import load_fonts_c

            n = load_fonts_c(prefix)
            if n <= 0:
                print("md3qml: md3_load_fonts returned 0 (check Md3 qrc fonts)", file=sys.stderr)
        except Exception as exc:  # noqa: BLE001 — best-effort host path
            print(f"md3qml: load_fonts skipped ({exc})", file=sys.stderr)

    def _try_set_app_user_model_id(self, app_id: str) -> None:
        try:
            helper = self.ensure_native()
            if hasattr(helper, "set_app_user_model_id"):
                helper.set_app_user_model_id(app_id)
        except Exception as exc:  # noqa: BLE001
            print(f"md3qml: app_user_model_id skipped ({exc})", file=sys.stderr)
    def _auto_fetch_prefix(self) -> Path:
        from .fetch import fetch_md3_prefix

        dest = Path(self.opts.fetch_dest).expanduser()
        print(f"md3qml: auto-fetching shared Md3 → {dest}", file=sys.stderr)
        prefix = fetch_md3_prefix(
            dest,
            version=self.opts.fetch_version,
            url=self.opts.fetch_url,
        )
        # So subsequent resolve works without re-download preference
        import os

        os.environ.setdefault("MD3_PREFIX", str(prefix))
        return prefix

    def set_context_property(self, name: str, value: Any) -> None:
        self._context[name] = value
        ctx = self.engine.rootContext()
        ctx.setContextProperty(name, value)

    def set_context_properties(self, mapping: Dict[str, Any]) -> None:
        for name, value in mapping.items():
            self.set_context_property(name, value)

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
        ok = bool(self.engine.rootObjects())
        if ok and self._native is not None:
            self._native.set_default_window(self.engine.rootObjects()[0])
        elif ok:
            # Warm native helper and bind default window for C++-parity calls.
            self.ensure_native()
        return ok

    def load_data(self, qml_source: str, *, name: str = "inline.qml") -> bool:
        """Load QML from a string (useful for tests / generated UI)."""
        if self._prefix is None:
            self.prepare_imports()
        self._apply_context()
        data = qml_source.encode("utf-8")
        url = self._qt.QUrl(name)
        load_data = getattr(self.engine, "loadData", None)
        if callable(load_data):
            load_data(data, url)
        else:
            import tempfile

            tmp = Path(tempfile.gettempdir()) / f"md3qml-{name}"
            tmp.write_text(qml_source, encoding="utf-8")
            self.engine.load(self._qt.QUrl.fromLocalFile(str(tmp)))
        ok = bool(self.engine.rootObjects())
        if ok:
            self.ensure_native()
        return ok

    def load_module(self, uri: str, component: str = "Main") -> bool:
        if self._prefix is None:
            self.prepare_imports()
        self._apply_context()
        load_from = getattr(self.engine, "loadFromModule", None)
        if not callable(load_from):
            raise RuntimeError("loadFromModule requires Qt 6 / PySide6")
        load_from(uri, component)
        ok = bool(self.engine.rootObjects())
        if ok:
            self.ensure_native()
        return ok

    def root_objects(self) -> Sequence[Any]:
        return self.engine.rootObjects()

    def root_object(self, index: int = 0) -> Any:
        from .bridge import root_object

        return root_object(self, index)

    def invoke(self, method: str, *args: Any, root_index: int = 0) -> Any:
        from .bridge import invoke, root_object

        return invoke(root_object(self, root_index), method, *args)

    def exec(self) -> int:
        app = self.app
        return app.exec() if hasattr(app, "exec") else app.exec_()

    def quit(self) -> None:
        self.app.quit()

    def on_quit(self, callback: Callable[[], None]) -> None:
        self.app.aboutToQuit.connect(callback)
