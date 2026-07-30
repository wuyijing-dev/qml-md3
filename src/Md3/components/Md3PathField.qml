import QtQuick
import QtQuick.Dialogs
import Md3

/// Path field — open/save file, multi-file, or folder; recent paths, validation, drop, breadcrumb.
Item {
    id: root

    enum Mode { OpenFile, SaveFile, OpenFiles, Folder }

    property int mode: Md3PathField.OpenFile
    property alias label: field.label
    property alias supportingText: field.supportingText
    property alias errorText: field.errorText
    property alias error: field.error
    property alias placeholderText: field.placeholderText
    property string path: ""
    property var paths: []
    property string dialogTitle: qsTr("Select")
    property var nameFilters: ["All files (*)"]
    property url currentFolder: ""
    property bool controlEnabled: true
    property string accessibleName: ""
    property var recentPaths: []
    property int maxRecent: 8
    property bool rememberRecent: true
    property string recentStoreKey: "" // e.g. "desktop/recentPaths"
    property bool validateExtension: true
    property bool validateExists: false
    property bool validateWritable: false
    property var allowedExtensions: [] // e.g. [".qml", ".json"]
    property var pathValidator: null // function(path) -> { valid: bool, message: string }
    property var existsProbe: null // function(path)->bool
    property var writableProbe: null // function(path)->bool
    /// Localized when existsProbe fails (validateExists).
    property string notFoundText: qsTr("Path does not exist")
    /// Localized when writableProbe fails (validateWritable) — permission / ACL.
    property string permissionDeniedText: qsTr("No write permission for this path")
    /// Announce validation failures via Md3Accessibility (default on).
    property bool announceValidationErrors: true
    property bool showBreadcrumb: false
    property bool acceptDrops: true

    signal accepted(string path)
    signal pathsAccepted(var paths)
    signal rejected()
    signal validationChanged(bool valid, string message)

    implicitWidth: 320
    implicitHeight: field.implicitHeight + (crumbRow.visible ? crumbRow.height + 4 : 0)
    width: implicitWidth
    height: implicitHeight

    readonly property bool multiMode: mode === Md3PathField.OpenFiles
    readonly property var breadcrumbModel: _splitPath(path)

    Accessible.role: Accessible.EditableText
    Accessible.name: accessibleName.length ? accessibleName : (label.length ? label : (dialogTitle.length ? dialogTitle : qsTr("Path field")))

    function browse() {
        if (!controlEnabled)
            return
        if (mode === Md3PathField.Folder) {
            if (currentFolder.toString().length > 0)
                folderDialog.currentFolder = currentFolder
            folderDialog.title = dialogTitle
            folderDialog.open()
        } else {
            if (currentFolder.toString().length > 0)
                fileDialog.currentFolder = currentFolder
            fileDialog.title = dialogTitle
            fileDialog.fileMode = (mode === Md3PathField.SaveFile)
                    ? FileDialog.SaveFile
                    : (mode === Md3PathField.OpenFiles ? FileDialog.OpenFiles : FileDialog.OpenFile)
            fileDialog.open()
        }
    }

    function clear() {
        path = ""
        paths = []
        _runValidation()
    }

    function addRecent(p) {
        if (!rememberRecent || !p || !String(p).length)
            return
        const s = String(p)
        const list = (recentPaths || []).slice()
        const at = list.indexOf(s)
        if (at >= 0)
            list.splice(at, 1)
        list.unshift(s)
        while (list.length > maxRecent)
            list.pop()
        recentPaths = list
        _persistRecent()
    }

    function _persistRecent() {
        if (!rememberRecent || !recentStoreKey.length)
            return
        Md3AppSettings.setValue(recentStoreKey, JSON.stringify(recentPaths || []))
    }

    function _restoreRecent() {
        if (!rememberRecent || !recentStoreKey.length)
            return
        const raw = Md3AppSettings.value(recentStoreKey, "[]")
        try {
            const list = JSON.parse(String(raw))
            if (Array.isArray(list))
                recentPaths = list
        } catch (e) {
            // ignore malformed persisted value
        }
    }

    function validatePath(p) {
        const msg = _validationMessage(p)
        const ok = !msg.length
        field.error = !ok
        field.errorText = ok ? "" : msg
        validationChanged(ok, msg)
        if (!ok && announceValidationErrors && msg.length
                && typeof Md3Accessibility !== "undefined"
                && Md3Accessibility.announceError)
            Md3Accessibility.announceError(msg)
        return ok
    }

    function _validationMessage(p) {
        if (!p || !String(p).length)
            return ""
        if (pathValidator) {
            const r = pathValidator(p)
            if (r && r.valid === false)
                return r.message !== undefined ? String(r.message) : qsTr("Invalid path")
        }
        if (validateExtension && allowedExtensions && allowedExtensions.length) {
            const lower = String(p).toLowerCase()
            let ok = false
            for (let i = 0; i < allowedExtensions.length; ++i) {
                const ext = String(allowedExtensions[i]).toLowerCase()
                if (lower.endsWith(ext)) {
                    ok = true
                    break
                }
            }
            if (!ok)
                return qsTr("Extension not allowed")
        }
        if (validateExists && existsProbe) {
            if (!existsProbe(p))
                return notFoundText
        }
        if (validateWritable && writableProbe) {
            if (!writableProbe(p))
                return permissionDeniedText
        }
        return ""
    }

    function _runValidation() {
        if (multiMode) {
            for (let i = 0; i < paths.length; ++i) {
                const msg = _validationMessage(paths[i])
                if (msg.length) {
                    field.error = true
                    field.errorText = msg
                    validationChanged(false, msg)
                    return
                }
            }
            field.error = false
            field.errorText = ""
            validationChanged(true, "")
            return
        }
        validatePath(path)
    }

    function _splitPath(p) {
        const s = String(p || "").replace(/\\/g, "/")
        if (!s.length)
            return []
        const parts = s.split("/").filter(function (x) { return x.length > 0 })
        const out = []
        let acc = ""
        for (let i = 0; i < parts.length; ++i) {
            acc += (i === 0 && s.indexOf(":") === 1) ? parts[i] : (acc.length ? "/" : "") + parts[i]
            if (i === 0 && parts[i].indexOf(":") === parts[i].length - 1)
                acc += "/"
            out.push({ title: parts[i] })
        }
        return out
    }

    function _pathFromBreadcrumb(index) {
        const items = breadcrumbModel
        if (index < 0 || index >= items.length)
            return path
        const parts = []
        for (let i = 0; i <= index; ++i)
            parts.push(items[i].title)
        let joined = parts.join("/")
        if (joined.indexOf(":") > 0 && joined.indexOf(":/") < 0)
            joined = parts[0] + "/" + parts.slice(1).join("/")
        return joined
    }

    function _urlToLocal(u) {
        let p = u ? u.toString() : ""
        if (p.indexOf("file:///") === 0) {
            p = p.substring(8)
            if (Qt.platform.os === "windows" || Qt.platform.os === "winrt")
                return decodeURIComponent(p)
            return "/" + decodeURIComponent(p)
        }
        if (p.indexOf("file://") === 0)
            return decodeURIComponent(p.substring(7))
        return p
    }

    function _applySingle(p) {
        path = p
        paths = [p]
        addRecent(p)
        _runValidation()
        accepted(p)
    }

    function _applyMany(list) {
        paths = list
        path = list.length ? list.join("; ") : ""
        for (let i = 0; i < list.length; ++i)
            addRecent(list[i])
        _runValidation()
        pathsAccepted(list)
        if (list.length === 1)
            accepted(list[0])
    }

    onPathChanged: {
        const display = multiMode ? paths.join("; ") : path
        if (field.text !== display)
            field.text = display
        if (!multiMode)
            _runValidation()
    }
    Component.onCompleted: {
        _restoreRecent()
        field.text = multiMode ? paths.join("; ") : path
        _runValidation()
    }

    Column {
        anchors.fill: parent
        spacing: 4

        Item {
            width: parent.width
            height: field.implicitHeight

            Md3TextField {
                id: field
                width: parent.width - (root.recentPaths.length ? 40 : 0)
                variant: Md3TextField.Outlined
                trailingIcon: root.mode === Md3PathField.Folder ? "folder_open" : "upload_file"
                clearOnTrailing: false
                enabled: root.controlEnabled
                accessibleName: root.accessibleName.length ? root.accessibleName
                                : (label.length ? label : qsTr("Path"))
                onTrailingClicked: root.browse()
                onAccepted: {
                    if (root.multiMode) {
                        const list = text.split(";").map(function (s) { return s.trim() }).filter(function (s) { return s.length })
                        root._applyMany(list)
                    } else {
                        root.path = text
                        root._runValidation()
                        root.accepted(root.path)
                    }
                }
                onTextChanged: {
                    if (root.multiMode) {
                        if (text !== root.paths.join("; "))
                            root.paths = text.split(";").map(function (s) { return s.trim() }).filter(function (s) { return s.length })
                    } else if (text !== root.path) {
                        root.path = text
                    }
                }
            }

            Md3IconButton {
                visible: root.recentPaths.length > 0
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                icon: "history"
                accessibleName: qsTr("Recent paths")
                onClicked: recentMenu.popupAtItem(field, field.width - 8, field.height)
            }

            DropArea {
                anchors.fill: parent
                enabled: root.acceptDrops && root.controlEnabled
                onDropped: function (drop) {
                    if (!drop.hasUrls || !drop.urls.length)
                        return
                    const list = []
                    for (let i = 0; i < drop.urls.length; ++i)
                        list.push(root._urlToLocal(drop.urls[i]))
                    if (root.multiMode || list.length > 1)
                        root._applyMany(list)
                    else
                        root._applySingle(list[0])
                    drop.acceptProposedAction()
                }
            }
        }

        Md3Breadcrumb {
            id: crumbRow
            width: parent.width
            visible: root.showBreadcrumb && root.breadcrumbModel.length > 0
            model: root.breadcrumbModel
            onCrumbClicked: function (index) {
                root.path = root._pathFromBreadcrumb(index)
                root._runValidation()
            }
        }
    }

    Md3Menu {
        id: recentMenu
        modal: true
        Repeater {
            model: root.recentPaths
            Md3MenuItem {
                required property var modelData
                text: String(modelData)
                icon: "history"
                onClicked: {
                    if (root.multiMode)
                        root._applyMany([String(modelData)])
                    else
                        root._applySingle(String(modelData))
                    recentMenu.dismiss()
                }
            }
        }
        Md3MenuDivider { visible: root.recentPaths.length > 0 }
        Md3MenuItem {
            text: qsTr("Browse…")
            icon: "folder_open"
            onClicked: {
                recentMenu.dismiss()
                root.browse()
            }
        }
    }

    FileDialog {
        id: fileDialog
        nameFilters: root.nameFilters
        onAccepted: {
            if (root.mode === Md3PathField.OpenFiles) {
                const list = []
                const files = selectedFiles || []
                for (let i = 0; i < files.length; ++i)
                    list.push(root._urlToLocal(files[i]))
                root._applyMany(list)
            } else {
                root._applySingle(root._urlToLocal(selectedFile))
            }
        }
        onRejected: root.rejected()
    }

    FolderDialog {
        id: folderDialog
        onAccepted: root._applySingle(root._urlToLocal(selectedFolder))
        onRejected: root.rejected()
    }
}
