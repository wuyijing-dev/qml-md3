# Md3ReleaseUpdater

GitHub Release update client: metadata check, ZIP download, and archive extract. NOTE: This is non-visual (0x0) but uses `Item` so it can safely host the C++ backend instance.

- **Source:** `src/Md3/components/Md3ReleaseUpdater.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 22 | 5 | 5 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `owner` | `alias` | `backend.owner` | read/write | `Md3ReleaseUpdater` | Owner. |
| `repo` | `alias` | `backend.repo` | read/write | `Md3ReleaseUpdater` | Repo. |
| `currentVersion` | `alias` | `backend.currentVersion` | read/write | `Md3ReleaseUpdater` | Current Version. |
| `includePrerelease` | `alias` | `backend.includePrerelease` | read/write | `Md3ReleaseUpdater` | Include Prerelease. |
| `assetNameContains` | `alias` | `backend.assetNameContains` | read/write | `Md3ReleaseUpdater` | Asset Name Contains. |
| `checking` | `alias` | `backend.checking` | read/write | `Md3ReleaseUpdater` | Checking. |
| `downloading` | `alias` | `backend.downloading` | read/write | `Md3ReleaseUpdater` | Downloading. |
| `extracting` | `alias` | `backend.extracting` | read/write | `Md3ReleaseUpdater` | Extracting. |
| `errorString` | `alias` | `backend.errorString` | read/write | `Md3ReleaseUpdater` | Error String. |
| `latestTag` | `alias` | `backend.latestTag` | read/write | `Md3ReleaseUpdater` | Latest Tag. |
| `latestVersion` | `alias` | `backend.latestVersion` | read/write | `Md3ReleaseUpdater` | Latest Version. |
| `latestName` | `alias` | `backend.latestName` | read/write | `Md3ReleaseUpdater` | Latest Name. |
| `publishedAt` | `alias` | `backend.publishedAt` | read/write | `Md3ReleaseUpdater` | Published At. |
| `releaseNotes` | `alias` | `backend.releaseNotes` | read/write | `Md3ReleaseUpdater` | Release Notes. |
| `downloadUrl` | `alias` | `backend.downloadUrl` | read/write | `Md3ReleaseUpdater` | Download Url. |
| `downloadName` | `alias` | `backend.downloadName` | read/write | `Md3ReleaseUpdater` | Download Name. |
| `hasUpdate` | `alias` | `backend.hasUpdate` | read/write | `Md3ReleaseUpdater` | Has Update. |
| `downloadedBytes` | `alias` | `backend.downloadedBytes` | read/write | `Md3ReleaseUpdater` | Downloaded Bytes. |
| `totalBytes` | `alias` | `backend.totalBytes` | read/write | `Md3ReleaseUpdater` | Total Bytes. |
| `downloadProgress` | `alias` | `backend.downloadProgress` | read/write | `Md3ReleaseUpdater` | Download Progress. |
| `downloadedFilePath` | `alias` | `backend.downloadedFilePath` | read/write | `Md3ReleaseUpdater` | Downloaded File Path. |
| `extractedDirPath` | `alias` | `backend.extractedDirPath` | read/write | `Md3ReleaseUpdater` | Extracted Dir Path. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `checked()` | `Md3ReleaseUpdater` | Checked / on state. |
| `updateAvailable(string version, string url)` | `Md3ReleaseUpdater` | Emitted when update Available. |
| `checkFailed(string message)` | `Md3ReleaseUpdater` | Emitted when check Failed. |
| `downloadFinished(string filePath)` | `Md3ReleaseUpdater` | Emitted when download Finished. |
| `extractFinished(string directoryPath)` | `Md3ReleaseUpdater` | Emitted when extract Finished. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `check()` | `—` | `Md3ReleaseUpdater` | Check. |
| `downloadTo(directoryPath)` | `—` | `Md3ReleaseUpdater` | Download To. |
| `extractTo(directoryPath)` | `—` | `Md3ReleaseUpdater` | Extract To. |
| `downloadAndExtract(downloadDirectory, extractDirectory)` | `—` | `Md3ReleaseUpdater` | Download And Extract. |
| `clearDownloadedFile()` | `—` | `Md3ReleaseUpdater` | Clear Downloaded File. |

## Example

```qml
import Md3

Md3ReleaseUpdater {
    // see properties above
}
```
