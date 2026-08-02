"""Download a prebuilt shared Md3 prefix (from GitHub Releases or a custom URL)."""

from __future__ import annotations

import io
import os
import sys
import zipfile
from pathlib import Path
from typing import Iterable, List, Optional
from urllib.error import HTTPError, URLError
from urllib.request import Request, urlopen

# Override with MD3_WHEEL_URL / MD3_FETCH_URL for private mirrors.
_DEFAULT_REPO = "wuyijing-dev/QML_MD3"


def _platform_tags() -> List[str]:
    if sys.platform == "win32":
        # Prefer packaging/cli Release names first (v1.1.1: Md3-windows-AMD64-shared.zip).
        return ["windows-AMD64", "windows-x64", "win64", "windows"]
    if sys.platform == "darwin":
        machine = os.uname().machine if hasattr(os, "uname") else ""
        if machine in ("arm64", "aarch64"):
            return ["macos-arm64", "macos-x64", "darwin"]
        return ["macos-x64", "macos-arm64", "darwin"]
    return ["linux-x64", "linux-AMD64", "linux"]


def candidate_asset_urls(version: str, *, repo: Optional[str] = None) -> List[str]:
    """
    Possible GitHub Release asset URLs (tried in order).

    Matches both packaging naming ``Md3-windows-AMD64-shared.zip`` (v1.1.1 Release)
    and CI naming ``Md3-{ver}-shared-windows-x64.zip``.
    """
    repo = repo or os.environ.get("MD3_GITHUB_REPO", _DEFAULT_REPO)
    ver = version.lstrip("v")
    base = f"https://github.com/{repo}/releases/download/v{ver}"
    urls: List[str] = []
    for tag in _platform_tags():
        # Packaging / scripts/packaging zip names
        urls.append(f"{base}/Md3-{tag}-shared.zip")
        # CI pyside-wheels / build_wheel fetch zip names
        urls.append(f"{base}/Md3-{ver}-shared-{tag}.zip")
        urls.append(f"{base}/Md3-{ver}-shared-{tag.replace('AMD64', 'x64')}.zip")
    # De-dupe preserve order
    seen = set()
    out: List[str] = []
    for u in urls:
        if u not in seen:
            seen.add(u)
            out.append(u)
    return out


def default_asset_url(version: str, *, repo: Optional[str] = None) -> str:
    """First conventional URL (may 404 — prefer :func:`fetch_md3_prefix` which tries all)."""
    return candidate_asset_urls(version, repo=repo)[0]


def _download(url: str) -> bytes:
    req = Request(url, headers={"User-Agent": "md3qml-fetch/1.0"})
    with urlopen(req, timeout=180) as resp:
        return resp.read()


def fetch_md3_prefix(
    dest: Path,
    *,
    version: str = "1.1.1",
    url: Optional[str] = None,
    repo: Optional[str] = None,
) -> Path:
    """
    Download and extract a shared Md3 zip into ``dest``.

    Returns the prefix directory that contains ``lib/qml``.
    """
    dest = Path(dest).expanduser().resolve()
    dest.mkdir(parents=True, exist_ok=True)

    env_url = os.environ.get("MD3_FETCH_URL") or os.environ.get("MD3_WHEEL_URL")
    urls: Iterable[str]
    if url or env_url:
        urls = [url or env_url]  # type: ignore[list-item]
    else:
        urls = candidate_asset_urls(version, repo=repo)

    data: Optional[bytes] = None
    used = ""
    errors: List[str] = []
    for candidate in urls:
        try:
            data = _download(candidate)
            used = candidate
            break
        except HTTPError as exc:
            errors.append(f"HTTP {exc.code} {candidate}")
        except URLError as exc:
            errors.append(f"{exc} {candidate}")

    if data is None:
        raise FileNotFoundError(
            "Could not download a shared Md3 zip.\n"
            "Tried:\n  - "
            + "\n  - ".join(errors)
            + "\nUpload a shared package on GitHub Releases, or pass --url / MD3_FETCH_URL.\n"
            "Note: PyPI does not yet host md3qml wheels; use git install + fetch, or a local dist/Md3."
        )

    with zipfile.ZipFile(io.BytesIO(data)) as zf:
        zf.extractall(dest)

    # Zip may contain top-level "Md3/" or flat lib/
    if (dest / "lib" / "qml").is_dir():
        prefix = dest
    else:
        nested = dest / "Md3"
        if (nested / "lib" / "qml").is_dir():
            prefix = nested
        else:
            prefix = None
            for child in dest.iterdir():
                if child.is_dir() and (child / "lib" / "qml").is_dir():
                    prefix = child
                    break
            if prefix is None:
                raise FileNotFoundError(
                    f"Extracted {used} into {dest} but lib/qml was not found. "
                    "Check the zip layout (expect lib/qml or Md3/lib/qml)."
                )

    # Soft marker for tooling
    marker = prefix / ".md3qml-fetch-url"
    try:
        marker.write_text(used + "\n", encoding="utf-8")
    except OSError:
        pass
    return prefix
