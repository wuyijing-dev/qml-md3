# Quickstart (≤ 10 minutes)

Windows-first path from a packaged `Md3` folder (or this repo) to a running window.

## A. Packaged folder (recommended for apps)

1. Build/package the library (from the QML_MD3 repo):

```powershell
python scripts/packaging/cli.py --qt-prefix "D:\Qt\6.10.2\mingw_64" -y
# → dist/Md3/
```

2. Create an app (or use `examples/hello-md3`):

```text
MyApp/
  CMakeLists.txt
  main.cpp
  Main.qml
  Md3/          ← copy dist/Md3 here
```

3. Configure & run:

```powershell
cd MyApp
cmake -S . -B build -DCMAKE_PREFIX_PATH="D:/Qt/6.10.2/mingw_64"
cmake --build build
.\build\hello_md3.exe   # or your target name
```

`examples/hello-md3` already contains CMake that `find_package(Md3)` when `./Md3` exists.

## B. From this repo (no package copy)

```powershell
cmake -S . -B build-hello `
  -DCMAKE_PREFIX_PATH="D:/Qt/6.10.2/mingw_64" `
  -DMD3_BUILD_GALLERY=OFF `
  -DMD3_BUILD_EXAMPLES=ON
cmake --build build-hello --target hello_md3
```

## Linux (sketch)

```bash
CMAKE_PREFIX_PATH=$HOME/Qt/6.10.2/gcc_64 \
  python scripts/packaging/cli.py -y
cp -a dist/Md3 examples/hello-md3/Md3
cmake -S examples/hello-md3 -B build-hello -DCMAKE_PREFIX_PATH=$HOME/Qt/6.10.2/gcc_64
cmake --build build-hello
```

## Shared vs static

| Mode | When | Notes |
|------|------|--------|
| **Shared (default package)** | Normal desktop apps | Ship `Md3.dll` / `.so` next to the app or on `PATH`/`LD_LIBRARY_PATH` |
| **Static** | Single-binary / locked-down deploy | Need `Q_IMPORT_QML_PLUGIN(Md3Plugin)` in `main.cpp`; larger link |

Troubleshooting: [packaging.md](packaging.md) · full integration: [integration.md](integration.md)

## Support scope (short)

- **Qt:** 6.8+ recommended (6.5 stage-1; see [qt-version-matrix.md](../topics/qt-version-matrix.md))
- **OS:** Windows primary; Linux/macOS best-effort until CI matrix expands
- **Experimental:** [experimental.md](../topics/experimental.md) — no SemVer promise
