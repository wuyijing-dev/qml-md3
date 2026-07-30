"""Cross-platform Md3 library packaging (stage + optional install + archive)."""

from __future__ import annotations

import os
import platform
import shutil
import subprocess
import tarfile
import zipfile
from dataclasses import dataclass
from pathlib import Path

from .qt_detect import QtKit


@dataclass
class PackageOptions:
    root: Path
    qt: QtKit
    build_type: str = "Release"
    shared: bool = True
    build_dir: Path | None = None
    stage_prefix: Path | None = None
    install_prefix: Path | None = None
    jobs: int | None = None
    generator: str | None = None
    skip_system_install: bool = False
    make_archive: bool = True
    clean_build: bool = True
    create_bundle_dir: Path | None = None

    def __post_init__(self) -> None:
        self.root = self.root.resolve()
        if self.build_dir is None:
            self.build_dir = self.root / "build-lib"
        if self.stage_prefix is None:
            self.stage_prefix = self.root / "dist" / "Md3"
        if self.install_prefix is None:
            if platform.system() == "Windows":
                local = os.environ.get("LOCALAPPDATA")
                self.install_prefix = Path(local) / "Md3" if local else self.root / "dist" / "install"
            else:
                self.install_prefix = Path("/usr/local")


def _info(msg: str) -> None:
    print(f"==> {msg}", flush=True)


def _die(msg: str) -> None:
    raise RuntimeError(msg)


def _run(cmd: list[str], *, cwd: Path | None = None, env: dict[str, str] | None = None) -> None:
    _info(" ".join(cmd))
    proc = subprocess.run(cmd, cwd=cwd, env=env)
    if proc.returncode != 0:
        _die(f"command failed ({proc.returncode}): {' '.join(cmd)}")


def _which(name: str) -> str | None:
    return shutil.which(name)


def _jobs(opt: PackageOptions) -> int:
    if opt.jobs and opt.jobs > 0:
        return opt.jobs
    return max(1, os.cpu_count() or 4)


def _pick_generator(requested: str | None) -> str:
    if requested:
        return requested
    if _which("ninja"):
        return "Ninja"
    if platform.system() == "Windows":
        return "Ninja"
    return "Unix Makefiles"


def _is_msvc_kit(qt: QtKit) -> bool:
    return "msvc" in qt.kit.lower()


def _has_msvc_compiler() -> bool:
    return _which("cl") is not None


def _find_vcvars64() -> Path | None:
    if platform.system() != "Windows":
        return None
    pf = os.environ.get("ProgramFiles(x86)", r"C:\Program Files (x86)")
    vswhere = Path(pf) / "Microsoft Visual Studio/Installer/vswhere.exe"
    if vswhere.is_file():
        try:
            out = subprocess.check_output(
                [
                    str(vswhere),
                    "-latest",
                    "-products",
                    "*",
                    "-requires",
                    "Microsoft.VisualStudio.Component.VC.Tools.x86.x64",
                    "-property",
                    "installationPath",
                ],
                text=True,
                stderr=subprocess.DEVNULL,
            ).strip()
        except (OSError, subprocess.CalledProcessError):
            out = ""
        if out:
            cand = Path(out) / "VC/Auxiliary/Build/vcvars64.bat"
            if cand.is_file():
                return cand
    for root in (
        Path(r"D:\vsproduct"),
        Path(r"C:\Program Files\Microsoft Visual Studio\2022\Community"),
        Path(r"C:\Program Files\Microsoft Visual Studio\2022\Professional"),
        Path(r"C:\Program Files\Microsoft Visual Studio\2022\Enterprise"),
        Path(r"C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools"),
    ):
        cand = root / "VC/Auxiliary/Build/vcvars64.bat"
        if cand.is_file():
            return cand
    return None


def _load_msvc_env(vcvars: Path) -> dict[str, str]:
    _info(f"Loading MSVC environment: {vcvars}")
    cmd = f'"{vcvars}" >nul 2>&1 && set'
    proc = subprocess.run(["cmd", "/c", cmd], capture_output=True, text=True)
    if proc.returncode != 0:
        _die("failed to load vcvars64.bat")
    env = os.environ.copy()
    for line in proc.stdout.splitlines():
        if "=" not in line:
            continue
        key, val = line.split("=", 1)
        env[key] = val
    if not shutil.which("cl", path=env.get("PATH", "")):
        _die("cl.exe still missing after vcvars64")
    return env


def _ensure_msvc_env(qt: QtKit) -> dict[str, str] | None:
    if platform.system() != "Windows" or not _is_msvc_kit(qt) or _has_msvc_compiler():
        return None
    vcvars = _find_vcvars64()
    if not vcvars:
        _die(
            f"Qt kit is MSVC ({qt.prefix}) but cl.exe is not in PATH. "
            "Install VS C++ tools or pick a MinGW Qt kit."
        )
    return _load_msvc_env(vcvars)


def _cmake_configure(opt: PackageOptions, *, build_dir: Path, install_prefix: Path, env: dict[str, str] | None) -> None:
    shared_on = "ON" if opt.shared else "OFF"
    args = [
        "cmake",
        "-S",
        str(opt.root),
        "-B",
        str(build_dir),
        "-G",
        opt.generator or "Ninja",
        "-DMD3_BUILD_GALLERY=OFF",
        f"-DMD3_BUILD_SHARED={shared_on}",
        f"-DCMAKE_BUILD_TYPE={opt.build_type}",
        f"-DCMAKE_INSTALL_PREFIX={install_prefix}",
        f"-DCMAKE_PREFIX_PATH={opt.qt.prefix}",
        f"-DMD3_QT_VERSION={opt.qt.major}",
    ]
    _run(args, env=env)


def _cmake_build(opt: PackageOptions, build_dir: Path, env: dict[str, str] | None) -> None:
    args = ["cmake", "--build", str(build_dir), "--parallel", str(_jobs(opt))]
    # Multi-config VS generators accept --config; single-config Ninja ignores it.
    if platform.system() == "Windows" and (opt.generator or "").startswith("Visual Studio"):
        args.extend(["--config", opt.build_type])
    _run(args, env=env)


def _cmake_install(build_dir: Path, prefix: Path, env: dict[str, str] | None, *, config: str | None = None) -> None:
    args = ["cmake", "--install", str(build_dir), "--prefix", str(prefix)]
    if config:
        args.extend(["--config", config])
    _run(args, env=env)


def _find_lib(stage: Path, shared: bool) -> Path | None:
    names = (
        ["libMd3.so", "libMd3.so.*", "Md3.dll", "libMd3.dll"]
        if shared
        else ["libMd3.a", "libMd3.so", "libMd3.lib", "Md3.lib", "libMd3.dll.a"]
    )
    for sub in ("lib", "lib64", "bin"):
        base = stage / sub
        if not base.is_dir():
            continue
        for name in names:
            if "*" in name:
                hits = sorted(base.glob(name))
                if hits:
                    return hits[0]
            else:
                p = base / name
                if p.is_file():
                    return p
    return None


def _write_readme(opt: PackageOptions, stage: Path, shared_label: str) -> None:
    script_name = "scripts/package.py"
    if platform.system() == "Windows":
        layout = (
            "| `lib\\` / `bin\\` | Core library + plugin |\n"
            "| `bin\\debug\\` | Debug `Md3.dll` (shared Release packages) |\n"
            "| `lib\\qml-debug\\` | Debug QML plugin tree |\n"
        )
        install_hint = f"Default install: `{opt.install_prefix}`"
    else:
        layout = (
            "| `lib/libMd3.*` | Core library |\n"
            "| `lib/debug/` | Debug libMd3 (shared Release packages) |\n"
            "| `lib/qml-debug/` | Debug QML plugin tree |\n"
        )
        install_hint = f"System install prefix: `{opt.install_prefix}`"

    text = f"""# Md3 packaged library ({shared_label})

Built by `{script_name}` from QML_MD3.

## Layout

{layout}
| `lib/cmake/Md3/` | `find_package(Md3)` |
| `include/Md3/` | C++ headers |

## CMake

```cmake
list(APPEND CMAKE_PREFIX_PATH "{opt.install_prefix}")
find_package(Md3 REQUIRED)
target_link_libraries(yourApp PRIVATE Md3::Md3)
```

{install_hint}

Qt used: `{opt.qt.prefix}`
"""
    (stage / "README.md").write_text(text, encoding="utf-8")


def _stage_debug_companion(opt: PackageOptions, env: dict[str, str] | None) -> None:
    if not opt.shared or opt.build_type != "Release":
        return
    debug_build = opt.root / "build-lib-debug"
    debug_stage = Path(os.environ.get("TEMP", "/tmp")) / f"md3-debug-stage-{os.getpid()}"
    _info("Also building Debug shared Md3 (debug runtime for Qt Creator kits)")
    if debug_build.exists():
        shutil.rmtree(debug_build)
    if debug_stage.exists():
        shutil.rmtree(debug_stage)
    _cmake_configure(
        PackageOptions(
            root=opt.root,
            qt=opt.qt,
            build_type="Debug",
            shared=True,
            build_dir=debug_build,
            stage_prefix=debug_stage,
            generator=opt.generator,
            jobs=opt.jobs,
            clean_build=False,
        ),
        build_dir=debug_build,
        install_prefix=debug_stage,
        env=env,
    )
    _cmake_build(opt, debug_build, env)
    _cmake_install(debug_build, debug_stage, env)

    stage = opt.stage_prefix
    assert stage is not None
    if platform.system() == "Windows":
        dbg_dll = debug_stage / "bin" / "Md3.dll"
        if dbg_dll.is_file():
            out = stage / "bin" / "debug"
            out.mkdir(parents=True, exist_ok=True)
            shutil.copy2(dbg_dll, out / "Md3.dll")
        dbg_qml = debug_stage / "lib" / "qml"
        if dbg_qml.is_dir():
            out_qml = stage / "lib" / "qml-debug"
            if out_qml.exists():
                shutil.rmtree(out_qml)
            shutil.copytree(dbg_qml, out_qml)
    else:
        dbg_lib = debug_stage / "lib"
        out_dbg = stage / "lib" / "debug"
        out_dbg.mkdir(parents=True, exist_ok=True)
        for cand in sorted(dbg_lib.glob("libMd3.so*")):
            shutil.copy2(cand, out_dbg / cand.name)
        dbg_qml = debug_stage / "lib" / "qml"
        if dbg_qml.is_dir():
            out_qml = stage / "lib" / "qml-debug"
            if out_qml.exists():
                shutil.rmtree(out_qml)
            shutil.copytree(dbg_qml, out_qml)
    if debug_stage.exists():
        shutil.rmtree(debug_stage, ignore_errors=True)


def _install_linux(opt: PackageOptions) -> None:
    assert opt.install_prefix is not None
    dest = opt.install_prefix
    _info(f"Install → {dest}")
    if dest.exists() and not os.access(dest, os.W_OK):
        sudo = _which("sudo")
        if sudo:
            _run(["sudo", "cmake", "--install", str(opt.build_dir), "--prefix", str(dest)])
        else:
            _die(f"cannot write to {dest}; set install prefix or use sudo")
    else:
        dest.parent.mkdir(parents=True, exist_ok=True)
        _cmake_install(opt.build_dir, dest, None)

    if opt.shared and str(dest) in ("/usr", "/usr/local"):
        ldconfig = _which("ldconfig")
        if ldconfig:
            _info("Running ldconfig")
            if os.geteuid() == 0:
                subprocess.run([ldconfig], check=False)
            elif _which("sudo"):
                subprocess.run(["sudo", ldconfig], check=False)


def _install_windows(opt: PackageOptions) -> None:
    assert opt.stage_prefix is not None and opt.install_prefix is not None
    _info(f"Install → {opt.install_prefix}")
    if opt.install_prefix.exists():
        shutil.rmtree(opt.install_prefix)
    opt.install_prefix.parent.mkdir(parents=True, exist_ok=True)
    shutil.copytree(opt.stage_prefix, opt.install_prefix)


def _make_archive(opt: PackageOptions, shared_label: str) -> Path | None:
    assert opt.stage_prefix is not None
    dist = opt.root / "dist"
    dist.mkdir(parents=True, exist_ok=True)
    if platform.system() == "Windows":
        arch = os.environ.get("PROCESSOR_ARCHITECTURE", "x64")
        out = dist / f"Md3-windows-{arch}-{shared_label}.zip"
        if out.exists():
            out.unlink()
        with zipfile.ZipFile(out, "w", compression=zipfile.ZIP_DEFLATED) as zf:
            for path in opt.stage_prefix.rglob("*"):
                zf.write(path, path.relative_to(opt.stage_prefix.parent))
        return out
    arch = platform.machine() or "unknown"
    out = dist / f"Md3-linux-{arch}-{shared_label}.tar.gz"
    with tarfile.open(out, "w:gz") as tf:
        tf.add(opt.stage_prefix, arcname=opt.stage_prefix.name)
    return out


def run_package(opt: PackageOptions) -> None:
    if not _which("cmake"):
        _die("cmake not found in PATH")

    opt.generator = _pick_generator(opt.generator)
    env = _ensure_msvc_env(opt.qt)
    shared_label = "shared" if opt.shared else "static"

    assert opt.build_dir is not None and opt.stage_prefix is not None

    _info(f"ROOT         = {opt.root}")
    _info(f"BUILD_DIR    = {opt.build_dir}")
    _info(f"STAGE        = {opt.stage_prefix}")
    _info(f"INSTALL      = {opt.install_prefix}")
    _info(f"SHARED       = {opt.shared} ({shared_label})")
    _info(f"Qt           = {opt.qt.label}")
    _info(f"Generator    = {opt.generator} ({_jobs(opt)} jobs, {opt.build_type})")

    if opt.clean_build and opt.build_dir.exists():
        _info(f"Clean build dir {opt.build_dir}")
        shutil.rmtree(opt.build_dir)

    _cmake_configure(opt, build_dir=opt.build_dir, install_prefix=opt.stage_prefix, env=env)
    _cmake_build(opt, opt.build_dir, env)

    _info(f"Stage → {opt.stage_prefix}")
    if opt.stage_prefix.exists():
        shutil.rmtree(opt.stage_prefix)
    _cmake_install(opt.build_dir, opt.stage_prefix, env)

    if not (opt.stage_prefix / "include/Md3").exists():
        _die("missing include/Md3 after stage")
    if not (opt.stage_prefix / "lib/cmake/Md3").exists():
        _die("missing lib/cmake/Md3 after stage")
    if _find_lib(opt.stage_prefix, opt.shared) is None:
        _die(f"missing libMd3 artifact under {opt.stage_prefix}")

    _stage_debug_companion(opt, env)
    _write_readme(opt, opt.stage_prefix, shared_label)

    if not opt.skip_system_install:
        if platform.system() == "Windows":
            _install_windows(opt)
        else:
            _install_linux(opt)
    else:
        _info("Skip system install — staged only")

    if opt.make_archive:
        archive = _make_archive(opt, shared_label)
        if archive:
            _info(f"Archive: {archive}")

    if opt.create_bundle_dir:
        bundle = opt.create_bundle_dir / "Md3"
        _info(f"Copy package → {bundle}")
        opt.create_bundle_dir.mkdir(parents=True, exist_ok=True)
        if bundle.exists():
            shutil.rmtree(bundle)
        shutil.copytree(opt.stage_prefix, bundle)

    _info(f"Done ({shared_label}).")
    print(f"  staged:   {opt.stage_prefix}")
    if not opt.skip_system_install:
        print(f"  install:  {opt.install_prefix}")
