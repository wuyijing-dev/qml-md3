"""Bootstrap helpers to load the packaged Md3 QML module from PySide6."""

from .app import Md3Application
from .binding import Binding, detect_binding, import_qt
from .bridge import connect_signal, disconnect_signal, find_child, invoke, root_object
from .capi import CRunConfig, load_md3_library, run_qml_file_c
from .doctor import doctor
from .fetch import candidate_asset_urls, fetch_md3_prefix
from .gallery import resolve_gallery_dir, run_gallery
from .native import WindowHelper, create_window_helper
from .paths import bundled_prefix, resolve_md3_prefix, setup_native_paths
from .run import RunOptions, run

__all__ = [
    "Binding",
    "CRunConfig",
    "Md3Application",
    "RunOptions",
    "WindowHelper",
    "bundled_prefix",
    "candidate_asset_urls",
    "connect_signal",
    "create_window_helper",
    "detect_binding",
    "disconnect_signal",
    "doctor",
    "fetch_md3_prefix",
    "find_child",
    "import_qt",
    "invoke",
    "load_md3_library",
    "resolve_gallery_dir",
    "resolve_md3_prefix",
    "root_object",
    "run",
    "run_gallery",
    "run_qml_file_c",
    "setup_native_paths",
]

__version__ = "1.0.0"
