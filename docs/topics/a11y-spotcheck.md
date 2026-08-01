# Accessibility spot-check (core path)

Manual keyboard / AT checklist for release candidates. Run after UI changes to Dialog, Menu, Select, DataTable, ListView, CommandBar, or PageHost.

Static heuristic: `python scripts/checks/check_a11y_qml.py --json scripts/checks/out/a11y-scan.json`

## Matrix

| Surface | Tab order | Esc | Enter / Space | `Accessible.name` |
|---------|-----------|-----|---------------|-------------------|
| Dialog | [x] focus restore | [x] | [x] primary (skips body editors) | [x] |
| Menu / Dropdown | [x] | [x] cascade | [x] | [x] restore trigger |
| Select | [x] | [x] closes menu | [x] opens | [x] + selection description |
| DataTable | [x] `activeFocusOnTab` | [x] cancel edit | [x] / F2 focused col | [x] `accessibleName` |
| ListView | [x] | — | [x] | [x] `accessibleName` (not emptyText) |
| CommandBar | [x] FocusScope + primary Tab | — | [x] overflow Enter/Space | [x] + focus ring |
| PageHost | [x] | [x] Esc / damped edge swipe back | — | [x] |

Also toggle Gallery **Accessibility** page **reduceMotion** / **highContrast** once per release candidate. Window page has a reduceMotion shortcut + “淡入 220ms”.

## Windows verify notes (v1.0.0)

- Kit: Qt **6.10.2** `msvc2022_64`, Ninja, VS 2026 tools
- Package: `python scripts/packaging/cli.py --qt-prefix … --shared -y` → `dist/Md3`
- Consumer: `examples/hello-md3` + `./Md3` → `hello_md3.exe` stayed up ≥4s
