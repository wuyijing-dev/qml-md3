"""Bootstrap helpers to load the packaged Md3 QML module from PySide6."""

from .app import Md3Application
from .binding import Binding, detect_binding, import_qt
from .bridge import connect_signal, disconnect_signal, find_child, invoke, root_object
from .banner import print_banner
from .capi import (
    CRunConfig,
    discover_qt_bin_dirs,
    load_md3_library,
    run_qml_file_c,
    run_qml_module_c,
    version_string_c,
    load_fonts_c,
)
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
    "discover_qt_bin_dirs",
    "doctor",
    "fetch_md3_prefix",
    "find_child",
    "import_qt",
    "invoke",
    "load_fonts_c",
    "load_md3_library",
    "print_banner",
    "resolve_gallery_dir",
    "resolve_md3_prefix",
    "root_object",
    "run",
    "run_gallery",
    "run_qml_file_c",
    "run_qml_module_c",
    "setup_native_paths",
    "version_string_c",
]

__version__ = "1.1.3"
