# Hello Md3

Minimal consumer: one window, Theme, Button, Dialog.

## Option 1 — from the library repo

```powershell
cmake -S ../.. -B ../../build-hello `
  -DCMAKE_PREFIX_PATH="D:/Qt/6.10.2/mingw_64" `
  -DMD3_BUILD_GALLERY=OFF `
  -DMD3_BUILD_EXAMPLES=ON
cmake --build ../../build-hello --target hello_md3
```

## Option 2 — packaged `./Md3` (`find_package`)

1. Package the library → `dist/Md3`
2. `copy` / `xcopy` / `cp -a` that folder to `examples/hello-md3/Md3`
3. Configure this directory:

```powershell
cmake -S . -B build -DCMAKE_PREFIX_PATH="D:/Qt/6.10.2/mingw_64"
cmake --build build
```

See [docs/quickstart.md](../../docs/quickstart.md).
