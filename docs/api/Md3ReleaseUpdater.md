# Md3ReleaseUpdater

GitHub Release update checker. Fetches latest release metadata and exposes a download URL.

- **Source:** `src/Md3/components/Md3ReleaseUpdater.qml`
- **Extends:** `QtObject`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `owner` | `string` | `""` | read/write | `Md3ReleaseUpdater` | — |
| `repo` | `string` | `""` | read/write | `Md3ReleaseUpdater` | — |
| `currentVersion` | `string` | `""` | read/write | `Md3ReleaseUpdater` | — |
| `includePrerelease` | `bool` | `false` | read/write | `Md3ReleaseUpdater` | — |
| `assetNameContains` | `string` | `".zip"` | read/write | `Md3ReleaseUpdater` | — |
| `checking` | `bool` | `false` | read/write | `Md3ReleaseUpdater` | — |
| `errorString` | `string` | `""` | read/write | `Md3ReleaseUpdater` | — |
| `latestTag` | `string` | `""` | read/write | `Md3ReleaseUpdater` | — |
| `latestVersion` | `string` | `""` | read/write | `Md3ReleaseUpdater` | — |
| `latestName` | `string` | `""` | read/write | `Md3ReleaseUpdater` | — |
| `publishedAt` | `string` | `""` | read/write | `Md3ReleaseUpdater` | — |
| `releaseNotes` | `string` | `""` | read/write | `Md3ReleaseUpdater` | — |
| `downloadUrl` | `string` | `""` | read/write | `Md3ReleaseUpdater` | — |
| `downloadName` | `string` | `""` | read/write | `Md3ReleaseUpdater` | — |
| `hasUpdate` | `bool` | `compareVersion(latestVersion, currentVersion) > 0` | readonly | `Md3ReleaseUpdater` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `checked()` | `Md3ReleaseUpdater` | — |
| `updateAvailable(string version, string url)` | `Md3ReleaseUpdater` | — |
| `checkFailed(string message)` | `Md3ReleaseUpdater` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `compareVersion(a, b)` | `Md3ReleaseUpdater` | — |
| `check()` | `Md3ReleaseUpdater` | — |

## Example

```qml
import Md3

Md3ReleaseUpdater {
    owner: ""
    repo: ""
    currentVersion: ""
    includePrerelease: false
    assetNameContains: ".zip"
}
```
