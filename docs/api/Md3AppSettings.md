# Md3AppSettings

- **Source:** `src/Md3/diagnostics/md3appsettings.h`
- **Type:** `QML_SINGLETON`

QSettings facade (`organization` / `application`).

## Keys used by Md3ApplicationWindow

| Key | Meaning |
|-----|---------|
| `window/x,y,width,height` | Geometry |
| `theme/dark` | Dark mode |
| `theme/seed` | Seed color |
| `shell/railExpanded` | Rail state |
| `shell/pageIndex` | Last page |
| `tour/completed` | Tour finished |

Enable with `persistSession: true` and optional `settingsApplication` (e.g. `"Gallery"`).
