"""Bootstrap helpers to load the packaged Md3 QML module from PySide6 / PySide2."""

from .binding import Binding, detect_binding, import_qt
from .paths import resolve_md3_prefix, setup_native_paths
from .run import RunOptions, run

__all__ = [
    "Binding",
    "RunOptions",
    "detect_binding",
    "import_qt",
    "resolve_md3_prefix",
    "run",
    "setup_native_paths",
]

__version__ = "1.0.0"
