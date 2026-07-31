# Smoke tests (Qt Quick Test)

Minimal qmltestrunner suite. Enable with `-DMD3_BUILD_TESTS=ON`.

```powershell
cmake -S . -B build-test `
  -DCMAKE_PREFIX_PATH="D:/Qt/6.10.2/mingw_64" `
  -DMD3_BUILD_GALLERY=OFF `
  -DMD3_BUILD_TESTS=ON
cmake --build build-test
ctest --test-dir build-test --output-on-failure
```

Cases live in `tst_*.qml`. Keep them headless-friendly (no Gallery).
