# Md3ReleaseUpdater

GitHub Release update client: metadata check, ZIP download, and archive extract. NOTE: This is non-visual (0x0) but uses `Item` so it can safely host the C++ backend instance.

- **Source:** `src/Md3/components/Md3ReleaseUpdater.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `owner` | `alias` | `backend.owner` | read/write | `Md3ReleaseUpdater` | Alias → `backend.owner` |
| `repo` | `alias` | `backend.repo` | read/write | `Md3ReleaseUpdater` | Alias → `backend.repo` |
| `currentVersion` | `alias` | `backend.currentVersion` | read/write | `Md3ReleaseUpdater` | Alias → `backend.currentVersion` |
| `includePrerelease` | `alias` | `backend.includePrerelease` | read/write | `Md3ReleaseUpdater` | Alias → `backend.includePrerelease` |
| `assetNameContains` | `alias` | `backend.assetNameContains` | read/write | `Md3ReleaseUpdater` | Alias → `backend.assetNameContains` |
| `checking` | `alias` | `backend.checking` | read/write | `Md3ReleaseUpdater` | Alias → `backend.checking` |
| `downloading` | `alias` | `backend.downloading` | read/write | `Md3ReleaseUpdater` | Alias → `backend.downloading` |
| `extracting` | `alias` | `backend.extracting` | read/write | `Md3ReleaseUpdater` | Alias → `backend.extracting` |
| `errorString` | `alias` | `backend.errorString` | read/write | `Md3ReleaseUpdater` | Alias → `backend.errorString` |
| `latestTag` | `alias` | `backend.latestTag` | read/write | `Md3ReleaseUpdater` | Alias → `backend.latestTag` |
| `latestVersion` | `alias` | `backend.latestVersion` | read/write | `Md3ReleaseUpdater` | Alias → `backend.latestVersion` |
| `latestName` | `alias` | `backend.latestName` | read/write | `Md3ReleaseUpdater` | Alias → `backend.latestName` |
| `publishedAt` | `alias` | `backend.publishedAt` | read/write | `Md3ReleaseUpdater` | Alias → `backend.publishedAt` |
| `releaseNotes` | `alias` | `backend.releaseNotes` | read/write | `Md3ReleaseUpdater` | Alias → `backend.releaseNotes` |
| `downloadUrl` | `alias` | `backend.downloadUrl` | read/write | `Md3ReleaseUpdater` | Alias → `backend.downloadUrl` |
| `downloadName` | `alias` | `backend.downloadName` | read/write | `Md3ReleaseUpdater` | Alias → `backend.downloadName` |
| `hasUpdate` | `alias` | `backend.hasUpdate` | read/write | `Md3ReleaseUpdater` | Alias → `backend.hasUpdate` |
| `downloadedBytes` | `alias` | `backend.downloadedBytes` | read/write | `Md3ReleaseUpdater` | Alias → `backend.downloadedBytes` |
| `totalBytes` | `alias` | `backend.totalBytes` | read/write | `Md3ReleaseUpdater` | Alias → `backend.totalBytes` |
| `downloadProgress` | `alias` | `backend.downloadProgress` | read/write | `Md3ReleaseUpdater` | Alias → `backend.downloadProgress` |
| `downloadedFilePath` | `alias` | `backend.downloadedFilePath` | read/write | `Md3ReleaseUpdater` | Alias → `backend.downloadedFilePath` |
| `extractedDirPath` | `alias` | `backend.extractedDirPath` | read/write | `Md3ReleaseUpdater` | Alias → `backend.extractedDirPath` |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `checked()` | `Md3ReleaseUpdater` | — |
| `updateAvailable(string version, string url)` | `Md3ReleaseUpdater` | — |
| `checkFailed(string message)` | `Md3ReleaseUpdater` | — |
| `downloadFinished(string filePath)` | `Md3ReleaseUpdater` | — |
| `extractFinished(string directoryPath)` | `Md3ReleaseUpdater` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `check()` | `Md3ReleaseUpdater` | — |
| `downloadTo(directoryPath)` | `Md3ReleaseUpdater` | — |
| `extractTo(directoryPath)` | `Md3ReleaseUpdater` | — |
| `downloadAndExtract(downloadDirectory, extractDirectory)` | `Md3ReleaseUpdater` | — |
| `clearDownloadedFile()` | `Md3ReleaseUpdater` | — |

## Example

```qml
import Md3

Md3ReleaseUpdater {
    // see properties above
}
```
