import QtQuick
import QtQuick.Dialogs

/// Path field with browse — open file, save file, or folder.
Item {
    id: root

    enum Mode { OpenFile, SaveFile, Folder }

    property int mode: Md3PathField.OpenFile
    property alias label: field.label
    property alias supportingText: field.supportingText
    property alias errorText: field.errorText
    property alias error: field.error
    property alias placeholderText: field.placeholderText
    property string path: ""
    property string dialogTitle: qsTr("Select")
    property var nameFilters: ["All files (*)"]
    property url currentFolder: ""
    property bool controlEnabled: true
    property string accessibleName: ""

    signal accepted(string path)
    signal rejected()

    implicitWidth: 320
    implicitHeight: field.implicitHeight
    width: implicitWidth
    height: implicitHeight

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
                    ? FileDialog.SaveFile : FileDialog.OpenFile
            fileDialog.open()
        }
    }

    function clear() { path = "" }

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

    onPathChanged: {
        if (field.text !== path)
            field.text = path
    }
    Component.onCompleted: field.text = path

    Md3TextField {
        id: field
        width: parent.width
        variant: Md3TextField.Outlined
        trailingIcon: root.mode === Md3PathField.Folder ? "folder_open" : "upload_file"
        clearOnTrailing: false
        enabled: root.controlEnabled
        accessibleName: root.accessibleName.length ? root.accessibleName
                        : (label.length ? label : qsTr("Path"))
        onTrailingClicked: root.browse()
        onAccepted: {
            root.path = text
            root.accepted(root.path)
        }
        onTextChanged: {
            if (text !== root.path)
                root.path = text
        }
    }

    FileDialog {
        id: fileDialog
        nameFilters: root.nameFilters
        onAccepted: {
            const p = root._urlToLocal(selectedFile)
            root.path = p
            root.accepted(p)
        }
        onRejected: root.rejected()
    }

    FolderDialog {
        id: folderDialog
        onAccepted: {
            const p = root._urlToLocal(selectedFolder)
            root.path = p
            root.accepted(p)
        }
        onRejected: root.rejected()
    }
}
