"""C++-parity native API: wraps ``Md3WindowHelper`` via the loaded Md3 QML module.

Requires a prepared QML engine (import path includes shared ``lib/qml``) and PySide6.
Methods mirror ``src/Md3/window/md3windowhelper.h`` invokables / properties.
"""

from __future__ import annotations

from pathlib import Path
from typing import Any, Callable, Optional, Sequence, Union

PathLike = Union[str, Path]
WindowLike = Any  # QWindow / QQuickWindow / ApplicationWindow root


_HELPER_QML = b"""
import QtQuick
import Md3
QtObject {
    id: root
    property var helper: Md3WindowHelper {}
}
"""


def _to_url(qt: Any, value: Any) -> Any:
    if value is None:
        return qt.QUrl()
    if hasattr(value, "isValid") and hasattr(value, "scheme"):
        return value  # already QUrl
    s = str(value)
    if "://" in s or s.startswith("qrc:") or s.startswith("file:"):
        return qt.QUrl(s)
    p = Path(s)
    if p.exists() or (len(s) > 1 and (s[1] == ":" or s.startswith("/") or s.startswith("\\"))):
        return qt.QUrl.fromLocalFile(str(p.resolve()) if p.exists() else str(p))
    # bare relative path → try as local file, else as user input URL
    from_user = getattr(qt.QUrl, "fromUserInput", None)
    if callable(from_user):
        return from_user(s)
    return qt.QUrl(s)


def create_window_helper(
    engine: Any,
    *,
    parent: Optional[Any] = None,
) -> "WindowHelper":
    """Instantiate C++ ``Md3WindowHelper`` through QML (same type Gallery uses)."""
    from .binding import import_qt

    _, qt = import_qt()
    # QQmlComponent lives on QtQml
    from importlib import import_module
    from .binding import detect_binding

    b = detect_binding()
    QQmlComponent = import_module(f"{b.name}.QtQml").QQmlComponent

    comp = QQmlComponent(engine)
    comp.setData(_HELPER_QML, qt.QUrl("qrc:/md3qml/WindowHelperHost.qml"))
    if comp.isError():
        errs = "; ".join(str(e.toString()) for e in comp.errors())
        raise RuntimeError(f"Failed to create Md3WindowHelper: {errs}")
    host = comp.create()
    if host is None:
        errs = "; ".join(str(e.toString()) for e in comp.errors())
        raise RuntimeError(f"Md3WindowHelper create() returned None: {errs}")
    raw = host.property("helper")
    if raw is None:
        raise RuntimeError("Md3WindowHelper property missing after QML create")
    if parent is not None:
        host.setParent(parent)
    return WindowHelper(raw, qt=qt, host=host)


class WindowHelper:
    """
    Pythonic facade over C++ ``Md3WindowHelper``.

    Prefer obtaining via ``Md3Application.native`` after ``prepare_imports()`` /
    ``load_file()`` so the Md3 plugin is on the import path.
    """

    # Enum mirrors (int values match C++)
    BackdropNone = 0
    BackdropAuto = 1
    BackdropMica = 2
    BackdropAcrylic = 3
    BackdropTabbed = 4

    ProgressNoProgress = 0
    ProgressIndeterminate = 1
    ProgressNormal = 2
    ProgressError = 3
    ProgressPaused = 4

    TrayUnknown = 0
    TrayLeftClick = 1
    TrayLeftDoubleClick = 2
    TrayRightClick = 3
    TrayMiddleClick = 4
    TrayBalloonShown = 5
    TrayBalloonClicked = 6
    TrayBalloonTimeout = 7

    def __init__(self, cpp_helper: Any, *, qt: Any = None, host: Any = None) -> None:
        self._h = cpp_helper
        self._qt = qt
        self._host = host  # keep QML host alive
        self._default_window: Optional[WindowLike] = None

    @property
    def raw(self) -> Any:
        """Underlying C++ ``Md3WindowHelper`` QObject."""
        return self._h

    def set_default_window(self, window: Optional[WindowLike]) -> None:
        """Used when methods omit ``window=`` (e.g. ApplicationWindow root)."""
        self._default_window = window

    def _win(self, window: Optional[WindowLike]) -> WindowLike:
        w = window if window is not None else self._default_window
        if w is None:
            raise ValueError("window is required (pass window= or set_default_window)")
        return w

    def _url(self, value: Any) -> Any:
        if self._qt is None:
            from .binding import import_qt

            _, self._qt = import_qt()
        return _to_url(self._qt, value)

    # --- properties ---

    @property
    def platform_id(self) -> str:
        return str(self._h.platformId)

    @property
    def wayland(self) -> bool:
        return bool(self._h.wayland)

    @property
    def xcb(self) -> bool:
        return bool(self._h.xcb)

    @property
    def display_server(self) -> str:
        return str(self._h.displayServer)

    @property
    def last_native_status(self) -> str:
        return str(self._h.lastNativeStatus)

    @property
    def traffic_lights_inset(self) -> float:
        return float(self._h.trafficLightsInset)

    @property
    def window_corner_radius(self) -> float:
        return float(self._h.windowCornerRadius)

    @property
    def custom_chrome_recommended(self) -> bool:
        return bool(self._h.customChromeRecommended)

    @property
    def caption_buttons_recommended(self) -> bool:
        return bool(self._h.captionButtonsRecommended)

    @property
    def snap_layouts_supported(self) -> bool:
        return bool(self._h.snapLayoutsSupported)

    @property
    def system_backdrop_supported(self) -> bool:
        return bool(self._h.systemBackdropSupported)

    @property
    def system_tray_supported(self) -> bool:
        return bool(self._h.systemTraySupported)

    @property
    def always_on_top_supported(self) -> bool:
        return bool(self._h.alwaysOnTopSupported)

    @property
    def system_accent_supported(self) -> bool:
        return bool(self._h.systemAccentSupported)

    # --- bind ---

    def bind_window(self, window: Optional[WindowLike] = None) -> None:
        self._h.bindWindow(self._win(window))

    def unbind_window(self, window: Optional[WindowLike] = None) -> None:
        self._h.unbindWindow(self._win(window))

    # --- chrome / win11 ---

    def apply_corner_preference(self, rounded: bool, *, window: Optional[WindowLike] = None) -> None:
        self._h.applyCornerPreference(self._win(window), bool(rounded))

    def set_maximize_button_rect(
        self, x: float, y: float, w: float, h: float, *, window: Optional[WindowLike] = None
    ) -> None:
        self._h.setMaximizeButtonRect(self._win(window), x, y, w, h)

    def clear_maximize_button_rect(self, *, window: Optional[WindowLike] = None) -> None:
        self._h.clearMaximizeButtonRect(self._win(window))

    def set_snap_maximize_rect(
        self, x: float, y: float, w: float, h: float, *, window: Optional[WindowLike] = None
    ) -> None:
        self._h.setSnapMaximizeRect(self._win(window), x, y, w, h)

    def clear_snap_maximize_rect(self, *, window: Optional[WindowLike] = None) -> None:
        self._h.clearSnapMaximizeRect(self._win(window))

    def set_snap_layouts_armed(self, armed: bool, *, window: Optional[WindowLike] = None) -> None:
        self._h.setSnapLayoutsArmed(self._win(window), bool(armed))

    def set_caption_hit_rect(
        self, x: float, y: float, w: float, h: float, *, window: Optional[WindowLike] = None
    ) -> None:
        self._h.setCaptionHitRect(self._win(window), x, y, w, h)

    def clear_caption_hit_rect(self, *, window: Optional[WindowLike] = None) -> None:
        self._h.clearCaptionHitRect(self._win(window))

    def set_window_icon(self, icon_url: Any, *, window: Optional[WindowLike] = None) -> bool:
        return bool(self._h.setWindowIcon(self._win(window), self._url(icon_url)))

    def show_system_menu(self, global_x: float, global_y: float, *, window: Optional[WindowLike] = None) -> None:
        self._h.showSystemMenu(self._win(window), global_x, global_y)

    def set_immersive_dark_mode(self, dark: bool, *, window: Optional[WindowLike] = None) -> None:
        self._h.setImmersiveDarkMode(self._win(window), bool(dark))

    def set_system_backdrop(self, backdrop: int, *, window: Optional[WindowLike] = None) -> None:
        self._h.setSystemBackdrop(self._win(window), int(backdrop))

    def set_border_color(self, css_color: str, *, window: Optional[WindowLike] = None) -> None:
        self._h.setBorderColor(self._win(window), css_color)

    def set_caption_text_color(self, css_color: str, *, window: Optional[WindowLike] = None) -> None:
        self._h.setCaptionTextColor(self._win(window), css_color)

    def flash_taskbar(self, flash: bool = True, *, window: Optional[WindowLike] = None) -> None:
        self._h.flashTaskbar(self._win(window), bool(flash))

    # --- taskbar / dock ---

    def set_app_user_model_id(self, app_id: str) -> bool:
        return bool(self._h.setAppUserModelId(app_id))

    def set_taskbar_progress(
        self, value: float, state: int = ProgressNormal, *, window: Optional[WindowLike] = None
    ) -> None:
        self._h.setTaskbarProgress(self._win(window), float(value), int(state))

    def clear_taskbar_progress(self, *, window: Optional[WindowLike] = None) -> None:
        self._h.clearTaskbarProgress(self._win(window))

    def set_taskbar_overlay_icon(
        self, icon_url: Any, description: str = "", *, window: Optional[WindowLike] = None
    ) -> bool:
        return bool(self._h.setTaskbarOverlayIcon(self._win(window), self._url(icon_url), description))

    def clear_taskbar_overlay_icon(self, *, window: Optional[WindowLike] = None) -> None:
        self._h.clearTaskbarOverlayIcon(self._win(window))

    def set_excluded_from_peek(self, excluded: bool, *, window: Optional[WindowLike] = None) -> None:
        self._h.setExcludedFromPeek(self._win(window), bool(excluded))

    def set_disallow_peek(self, disallow: bool, *, window: Optional[WindowLike] = None) -> None:
        self._h.setDisallowPeek(self._win(window), bool(disallow))

    def set_exclude_from_capture(self, exclude: bool, *, window: Optional[WindowLike] = None) -> None:
        self._h.setExcludeFromCapture(self._win(window), bool(exclude))

    def set_jump_list_tasks(self, tasks: Sequence[Any]) -> bool:
        return bool(self._h.setJumpListTasks(list(tasks)))

    def clear_jump_list(self) -> None:
        self._h.clearJumpList()

    def set_thumb_bar_buttons(self, buttons: Sequence[Any], *, window: Optional[WindowLike] = None) -> bool:
        return bool(self._h.setThumbBarButtons(self._win(window), list(buttons)))

    def clear_thumb_bar_buttons(self, *, window: Optional[WindowLike] = None) -> None:
        self._h.clearThumbBarButtons(self._win(window))

    def set_force_iconic_representation(self, enabled: bool, *, window: Optional[WindowLike] = None) -> None:
        self._h.setForceIconicRepresentation(self._win(window), bool(enabled))

    def set_iconic_thumbnail(self, image_url: Any, *, window: Optional[WindowLike] = None) -> bool:
        return bool(self._h.setIconicThumbnail(self._win(window), self._url(image_url)))

    def clear_iconic_thumbnail(self, *, window: Optional[WindowLike] = None) -> None:
        self._h.clearIconicThumbnail(self._win(window))

    def set_thumbnail_clip(
        self, x: float, y: float, w: float, h: float, *, window: Optional[WindowLike] = None
    ) -> None:
        self._h.setThumbnailClip(self._win(window), x, y, w, h)

    def clear_thumbnail_clip(self, *, window: Optional[WindowLike] = None) -> None:
        self._h.clearThumbnailClip(self._win(window))

    def set_thumbnail_tooltip(self, text: str, *, window: Optional[WindowLike] = None) -> None:
        self._h.setThumbnailTooltip(self._win(window), text)

    # --- tray ---

    def show_system_tray_icon(
        self, icon_url: Any, tooltip: str = "", *, window: Optional[WindowLike] = None
    ) -> bool:
        return bool(self._h.showSystemTrayIcon(self._win(window), self._url(icon_url), tooltip))

    def hide_system_tray_icon(self) -> None:
        self._h.hideSystemTrayIcon()

    def show_tray_notification(self, title: str, body: str, timeout_ms: int = 5000) -> bool:
        return bool(self._h.showTrayNotification(title, body, int(timeout_ms)))

    def cursor_screen_pos(self) -> Any:
        return self._h.cursorScreenPos()

    # --- window state ---

    def set_always_on_top(self, on_top: bool, *, window: Optional[WindowLike] = None) -> None:
        self._h.setAlwaysOnTop(self._win(window), bool(on_top))

    def set_window_cloaked(self, cloaked: bool, *, window: Optional[WindowLike] = None) -> None:
        self._h.setWindowCloaked(self._win(window), bool(cloaked))

    def set_preferred_app_mode(self, dark: bool) -> None:
        self._h.setPreferredAppMode(bool(dark))

    def monitor_count(self) -> int:
        return int(self._h.monitorCount())

    def move_to_monitor(self, monitor_index: int, *, window: Optional[WindowLike] = None) -> bool:
        return bool(self._h.moveToMonitor(self._win(window), int(monitor_index)))

    def register_application_restart(self, command_line_args: str = "") -> bool:
        return bool(self._h.registerApplicationRestart(command_line_args))

    def unregister_application_restart(self) -> None:
        self._h.unregisterApplicationRestart()

    def raise_window(self, *, window: Optional[WindowLike] = None) -> None:
        self._h.raiseWindow(self._win(window))

    def set_dock_badge(self, count: int) -> bool:
        return bool(self._h.setDockBadge(int(count)))

    def set_idle_inhibit(self, inhibit: bool, reason: str = "") -> bool:
        return bool(self._h.setIdleInhibit(bool(inhibit), reason))

    def blur_behind_available(self) -> bool:
        return bool(self._h.blurBehindAvailable())

    def open_blur_settings(self) -> bool:
        return bool(self._h.openBlurSettings())

    def system_accent_color(self) -> str:
        return str(self._h.systemAccentColor())

    def wallpaper_seed_color(self) -> str:
        return str(self._h.wallpaperSeedColor())

    def device_pixel_ratio(self, *, window: Optional[WindowLike] = None) -> float:
        return float(self._h.devicePixelRatio(self._win(window)))

    def window_dpi(self, *, window: Optional[WindowLike] = None) -> int:
        return int(self._h.windowDpi(self._win(window)))

    def set_persistent_scene_graph(self, persistent: bool, *, window: Optional[WindowLike] = None) -> None:
        self._h.setPersistentSceneGraph(self._win(window), bool(persistent))

    # --- portable system wrappers ---

    def open_url(self, url: Any) -> bool:
        return bool(self._h.openUrl(self._url(url)))

    def reveal_in_folder(self, path_or_url: Any) -> bool:
        return bool(self._h.revealInFolder(self._url(path_or_url)))

    def beep(self) -> None:
        self._h.beep()

    def center_on_screen(self, *, window: Optional[WindowLike] = None) -> bool:
        return bool(self._h.centerOnScreen(self._win(window)))

    def set_window_opacity(self, opacity: float, *, window: Optional[WindowLike] = None) -> bool:
        return bool(self._h.setWindowOpacity(self._win(window), float(opacity)))

    def set_visible_in_taskbar(self, visible: bool, *, window: Optional[WindowLike] = None) -> bool:
        return bool(self._h.setVisibleInTaskbar(self._win(window), bool(visible)))

    def minimize_window(self, *, window: Optional[WindowLike] = None) -> None:
        self._h.minimizeWindow(self._win(window))

    def maximize_window(self, *, window: Optional[WindowLike] = None) -> None:
        self._h.maximizeWindow(self._win(window))

    def restore_window(self, *, window: Optional[WindowLike] = None) -> None:
        self._h.restoreWindow(self._win(window))

    def set_full_screen(self, full_screen: bool, *, window: Optional[WindowLike] = None) -> None:
        self._h.setFullScreen(self._win(window), bool(full_screen))

    def system_color_scheme_dark(self) -> bool:
        return bool(self._h.systemColorSchemeDark())

    def share_text(self, text: str, title: str = "") -> bool:
        return bool(self._h.shareText(text, title))

    def vibrate(self, duration_ms: int = 40) -> bool:
        return bool(self._h.vibrate(int(duration_ms)))

    def set_immersive_system_ui(self, immersive: bool) -> bool:
        return bool(self._h.setImmersiveSystemUi(bool(immersive)))

    def request_attention(self, on: bool = True, *, window: Optional[WindowLike] = None) -> None:
        self._h.requestAttention(self._win(window), bool(on))

    # --- signals ---

    def on_last_native_status_changed(self, slot: Callable[..., Any]) -> Any:
        return self._h.lastNativeStatusChanged.connect(slot)

    def on_tray_activated(self, slot: Callable[..., Any]) -> Any:
        return self._h.trayActivated.connect(slot)

    def on_thumb_bar_button_clicked(self, slot: Callable[..., Any]) -> Any:
        return self._h.thumbBarButtonClicked.connect(slot)

    def on_dpi_changed(self, slot: Callable[..., Any]) -> Any:
        return self._h.dpiChanged.connect(slot)
