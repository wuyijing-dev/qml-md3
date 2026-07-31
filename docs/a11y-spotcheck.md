# Accessibility spot-check (core path)

Manual keyboard / AT checklist for release candidates. Run after UI changes to Dialog, Menu, Select, DataTable, ListView, CommandBar, or PageHost.

Static heuristic: `python scripts/checks/check_a11y_qml.py --json docs/a11y-scan.json`

## Matrix

| Surface | Tab order | Esc | Enter / Space | `Accessible.name` |
|---------|-----------|-----|---------------|-------------------|
| Dialog | [ ] | [ ] | [ ] primary | [ ] |
| Menu / Dropdown | [ ] | [ ] | [ ] | [ ] |
| Select | [ ] | [ ] | [ ] | [ ] |
| DataTable | [ ] | [ ] | [ ] / F2 edit | [ ] |
| ListView | [ ] | — | [ ] | [ ] |
| CommandBar | [ ] | — | [ ] | [ ] |
| PageHost | [ ] | [ ] back | — | [ ] |

Also toggle Gallery **reduceMotion** / **highContrast** once per release candidate.

## Windows verify notes (v1.0.0)

- Kit: Qt **6.10.2** `msvc2022_64`, Ninja, VS 2026 tools
- Package: `python scripts/packaging/cli.py --qt-prefix … --shared -y` → `dist/Md3`
- Consumer: `examples/hello-md3` + `./Md3` → `hello_md3.exe` stayed up ≥4s
