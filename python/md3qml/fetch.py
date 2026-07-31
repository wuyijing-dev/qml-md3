"""Download a prebuilt shared Md3 prefix (from GitHub Releases or a custom URL)."""

from __future__ import annotations

import io
import os
import sys
import zipfile
from pathlib import Path
from typing import Optional
from urllib.error import HTTPError, URLError
from urllib.request import Request, urlopen

# Override with MD3_WHEEL_URL / MD3_FETCH_URL for private mirrors.
_DEFAULT_REPO = "wuyijing-dev/QML_MD3"


def _platform_tag() -> str:
    if sys.platform == "win32":
        return "windows-x64"
    if sys.platform == "darwin":
        return "macos-x64" if sys.platform == "darwin" else "macos"
    return "linux-x64"


def default_asset_url(version: str, *, repo: Optional[str] = None) -> str:
    """
    Conventional release asset name:

      Md3-{version}-shared-{platform}.zip
      e.g. Md3-1.0.0-shared-windows-x64.zip
    """
    repo = repo or os.environ.get("MD3_GITHUB_REPO", _DEFAULT_REPO)
    ver = version.lstrip("v")
    asset = f"Md3-{ver}-shared-{_platform_tag()}.zip"
    return f"https://github.com/{repo}/releases/download/v{ver}/{asset}"


def fetch_md3_prefix(
    dest: Path,
    *,
    version: str = "1.0.0",
    url: Optional[str] = None,
    repo: Optional[str] = None,
) -> Path:
    """
    Download and extract a shared Md3 zip into ``dest``.

    Returns the prefix directory that contains ``lib/qml``.
    """
    dest = Path(dest).expanduser().resolve()
    dest.mkdir(parents=True, exist_ok=True)

    url = (
        url
        or os.environ.get("MD3_FETCH_URL")
        or os.environ.get("MD3_WHEEL_URL")
        or default_asset_url(version, repo=repo)
    )

    req = Request(url, headers={"User-Agent": "md3qml-fetch/1.0"})
    try:
        with urlopen(req, timeout=120) as resp:
            data = resp.read()
    except HTTPError as exc:
        raise FileNotFoundError(
            f"Download failed HTTP {exc.code}: {url}\n"
            "Upload a shared package zip on GitHub Releases, or pass --url / MD3_FETCH_URL."
        ) from exc
    except URLError as exc:
        raise FileNotFoundError(f"Download failed: {url}\n{exc}") from exc

    with zipfile.ZipFile(io.BytesIO(data)) as zf:
        zf.extractall(dest)

    # Zip may contain top-level "Md3/" or flat lib/
    if (dest / "lib" / "qml").is_dir():
        return dest
    nested = dest / "Md3"
    if (nested / "lib" / "qml").is_dir():
        return nested
    for child in dest.iterdir():
        if child.is_dir() and (child / "lib" / "qml").is_dir():
            return child

    raise FileNotFoundError(
        f"Extracted {url} into {dest} but lib/qml was not found. "
        "Check the zip layout (expect lib/qml or Md3/lib/qml)."
    )
