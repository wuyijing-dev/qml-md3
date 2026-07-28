import QtQuick

/// GitHub Release update checker. Fetches latest release metadata and exposes a download URL.
QtObject {
    id: root

    property string owner: ""
    property string repo: ""
    property string currentVersion: ""
    property bool includePrerelease: false
    property string assetNameContains: ".zip"
    property bool checking: false
    property string errorString: ""

    property string latestTag: ""
    property string latestVersion: ""
    property string latestName: ""
    property string publishedAt: ""
    property string releaseNotes: ""
    property string downloadUrl: ""
    property string downloadName: ""

    readonly property bool hasUpdate: compareVersion(latestVersion, currentVersion) > 0

    signal checked()
    signal updateAvailable(string version, string url)
    signal checkFailed(string message)

    function _normalizeVersion(v) {
        return String(v || "").trim().replace(/^v/i, "")
    }

    function compareVersion(a, b) {
        const av = _normalizeVersion(a).split(".")
        const bv = _normalizeVersion(b).split(".")
        const n = Math.max(av.length, bv.length)
        for (let i = 0; i < n; ++i) {
            const ai = i < av.length ? parseInt(av[i], 10) : 0
            const bi = i < bv.length ? parseInt(bv[i], 10) : 0
            if (ai > bi)
                return 1
            if (ai < bi)
                return -1
        }
        return 0
    }

    function _pickAsset(assets) {
        if (!assets || !assets.length)
            return null
        const needle = String(assetNameContains || "").toLowerCase()
        for (let i = 0; i < assets.length; ++i) {
            const a = assets[i]
            const name = a && a.name !== undefined ? String(a.name).toLowerCase() : ""
            if (!needle.length || name.indexOf(needle) >= 0)
                return a
        }
        return assets[0]
    }

    function _applyRelease(rel) {
        latestTag = rel.tag_name !== undefined ? String(rel.tag_name) : ""
        latestVersion = _normalizeVersion(latestTag)
        latestName = rel.name !== undefined ? String(rel.name) : latestTag
        publishedAt = rel.published_at !== undefined ? String(rel.published_at) : ""
        releaseNotes = rel.body !== undefined ? String(rel.body) : ""
        const asset = _pickAsset(rel.assets || [])
        downloadUrl = asset && asset.browser_download_url !== undefined
                ? String(asset.browser_download_url) : ""
        downloadName = asset && asset.name !== undefined ? String(asset.name) : ""
    }

    function check() {
        if (!owner.length || !repo.length) {
            errorString = qsTr("Missing owner/repo")
            checkFailed(errorString)
            return
        }
        checking = true
        errorString = ""
        const req = new XMLHttpRequest()
        req.onreadystatechange = function () {
            if (req.readyState !== XMLHttpRequest.DONE)
                return
            checking = false
            if (req.status < 200 || req.status >= 300) {
                errorString = qsTr("GitHub API error %1").arg(req.status)
                checkFailed(errorString)
                return
            }
            let data = null
            try {
                data = JSON.parse(req.responseText)
            } catch (e) {
                errorString = qsTr("Invalid release metadata")
                checkFailed(errorString)
                return
            }
            let rel = null
            if (Array.isArray(data)) {
                for (let i = 0; i < data.length; ++i) {
                    if (!!data[i].prerelease === includePrerelease) {
                        rel = data[i]
                        break
                    }
                }
                if (!rel && data.length)
                    rel = data[0]
            } else {
                rel = data
            }
            if (!rel) {
                errorString = qsTr("No releases found")
                checkFailed(errorString)
                return
            }
            _applyRelease(rel)
            checked()
            if (hasUpdate)
                updateAvailable(latestVersion, downloadUrl)
        }
        const url = includePrerelease
                ? "https://api.github.com/repos/" + owner + "/" + repo + "/releases"
                : "https://api.github.com/repos/" + owner + "/" + repo + "/releases/latest"
        req.open("GET", url)
        req.send()
    }
}

