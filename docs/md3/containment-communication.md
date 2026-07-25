# Dialog / Fullscreen dialog / Bottom sheet / Snackbar / Progress / Badge / Divider / ListTile

## Sources
- https://m3.material.io/components/dialogs/specs
- https://m3.material.io/components/bottom-sheets/specs
- https://m3.material.io/components/snackbar/specs
- https://m3.material.io/components/progress-indicators/specs
- https://m3.material.io/components/badges/specs
- https://m3.material.io/components/divider/specs
- https://m3.material.io/components/lists/specs
- Flutter Material counterparts

## Dialog
| Token | Value |
|-------|-------|
| corner | 28 (extraLarge) |
| container | surfaceContainerHigh |
| min width | 280 |
| padding | 24 |
| actions | labelLarge primary text buttons |

Motion: enter `medium4` emphasizedDecelerate; scrim fade `short4`

## Dialog window (separate OS window)
`Md3DialogWindow` is a top-level `Window` (QWidget-like), not an overlay.

| API | Notes |
|-----|-------|
| `openDialog(owner)` / `closeDialog()` | Show / hide; sets `transientParent` |
| `dialogModality` | `Qt.ApplicationModal` / `WindowModal` / `NonModal` |
| `showPinButton` | **Default true** — title-bar always-on-top pin |
| `pinned` / `setPinned()` | Syncs with `Md3WindowHelper.setAlwaysOnTop` |
| `showMinimizeButton` / `showMaximizeButton` | Default false for modal dialogs |
| `dialogText` + default content + footer OK/Cancel | M3 action row |

Use `Md3Dialog` for in-page scrim overlays; use `Md3DialogWindow` when you need a second HWND / independent taskbar entry / tool window.


## Fullscreen dialog
- surface fill, top app bar with close + confirm

## Bottom sheet
| Token | Value |
|-------|-------|
| corner top | 28 |
| drag handle | 32×4 colorOnSurfaceVariant@0.4 |
| modal scrim | scrim @ 0.32 |

## Snackbar
| Token | Value |
|-------|-------|
| height | 48 single / auto dual |
| corner | 4 |
| container | inverseSurface |
| enter | medium2 from bottom |

## Progress
- Linear track 4dp; Circular size 48, stroke 4

## Badge
- Small (6) / Large (16 height, labelSmall)

## Divider
- 1dp outlineVariant; inset 16

## ListTile
- one/two/three line; min height 56/72/88; leading 24–40
