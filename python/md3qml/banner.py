"""ANSI startup banner for md3qml hosts (mirrors Md3::printBanner)."""

from __future__ import annotations

import os
import sys


def _stderr_is_tty() -> bool:
    try:
        return bool(sys.stderr.isatty())
    except Exception:
        return False


def _enable_windows_ansi() -> bool:
    if os.name != "nt":
        return True
    try:
        import ctypes

        kernel32 = ctypes.windll.kernel32  # type: ignore[attr-defined]
        handle = kernel32.GetStdHandle(-12)  # STD_ERROR_HANDLE
        mode = ctypes.c_uint32()
        if kernel32.GetConsoleMode(handle, ctypes.byref(mode)) == 0:
            return False
        ENABLE_VIRTUAL_TERMINAL_PROCESSING = 0x0004
        if mode.value & ENABLE_VIRTUAL_TERMINAL_PROCESSING:
            return True
        return bool(
            kernel32.SetConsoleMode(handle, mode.value | ENABLE_VIRTUAL_TERMINAL_PROCESSING)
        )
    except Exception:
        return False


def print_banner(title: str = "Md3", version: str = "1.0.0") -> None:
    """
    Print a colorful Md3 intro to stderr when attached to a TTY.

    Skipped when ``MD3_DEBUG=1`` (mirrors C++ Debug: no banner, prefer logs).
    """
    dbg = os.environ.get("MD3_DEBUG", "").strip().lower()
    if dbg in ("1", "true", "yes", "on"):
        return
    if not _stderr_is_tty():
        return
    color = _enable_windows_ansi()
    r = "\033[0m" if color else ""
    p = "\033[38;2;103;80;164m" if color else ""
    t = "\033[38;2;0;150;136m" if color else ""
    s = "\033[38;2;121;116;126m" if color else ""
    b = "\033[1m" if color else ""

    lines = [
        "",
        f"{p}{b}        ╭──────────────────────────────────────╮",
        f"        │{t}  ███╗   ███╗██████╗  ██████╗ {p}       │",
        f"        │{t}  ████╗ ████║██╔══██╗██╔════╝ {p}       │",
        f"        │{t}  ██╔████╔██║██║  ██║██║  ███╗{p}       │",
        f"        │{t}  ██║╚██╔╝██║██║  ██║██║   ██║{p}       │",
        f"        │{t}  ██║ ╚═╝ ██║██████╔╝╚██████╔╝{p}       │",
        f"        │{t}  ╚═╝     ╚═╝╚═════╝  ╚═════╝ {p}       │",
        f"        ╰──────────────────────────────────────╯{r}",
        f"          {t}●{r} {p}●{r} {t}●{r} {p}●{r} {s}●{r}   {b}Material Design 3{r} · {s}Qt Quick{r}",
        f"          {b}{title}{r}  {s}v{version}{r}",
        f"          {t}import Md3{r}  ·  tokens · controls · chrome",
        "",
    ]
    sys.stderr.write("\n".join(lines) + "\n")
    sys.stderr.flush()
