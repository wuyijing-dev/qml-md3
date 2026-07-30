import QtQuick
import Md3

/// GitHub Release update client: metadata check, ZIP download, and archive extract.
/// NOTE: This is non-visual (0x0) but uses `Item` so it can safely host the C++ backend instance.
Item {
    id: root
    width: 0
    height: 0

    property alias owner: backend.owner
    property alias repo: backend.repo
    property alias currentVersion: backend.currentVersion
    property alias includePrerelease: backend.includePrerelease
    property alias assetNameContains: backend.assetNameContains
    property alias checking: backend.checking
    property alias downloading: backend.downloading
    property alias extracting: backend.extracting
    property alias errorString: backend.errorString
    property alias latestTag: backend.latestTag
    property alias latestVersion: backend.latestVersion
    property alias latestName: backend.latestName
    property alias publishedAt: backend.publishedAt
    property alias releaseNotes: backend.releaseNotes
    property alias downloadUrl: backend.downloadUrl
    property alias downloadName: backend.downloadName
    property alias hasUpdate: backend.hasUpdate
    property alias downloadedBytes: backend.downloadedBytes
    property alias totalBytes: backend.totalBytes
    property alias downloadProgress: backend.downloadProgress
    property alias downloadedFilePath: backend.downloadedFilePath
    property alias extractedDirPath: backend.extractedDirPath

    signal checked()
    signal updateAvailable(string version, string url)
    signal checkFailed(string message)
    signal downloadFinished(string filePath)
    signal extractFinished(string directoryPath)

    function check() { backend.check() }
    function downloadTo(directoryPath) { backend.downloadTo(directoryPath) }
    function extractTo(directoryPath) { backend.extractTo(directoryPath) }
    function downloadAndExtract(downloadDirectory, extractDirectory) {
        backend.downloadAndExtract(downloadDirectory, extractDirectory)
    }
    function clearDownloadedFile() { backend.clearDownloadedFile() }

    Md3ReleaseUpdaterNative {
        id: backend
        onChecked: root.checked()
        onUpdateAvailable: function (version, url) { root.updateAvailable(version, url) }
        onCheckFailed: function (message) { root.checkFailed(message) }
        onDownloadFinished: function (filePath) { root.downloadFinished(filePath) }
        onExtractFinished: function (directoryPath) { root.extractFinished(directoryPath) }
    }
}

