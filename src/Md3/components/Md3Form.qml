import QtQuick
import Md3

Item {
    id: root

    property var errors: ({})
    property var values: ({})
    property int layoutMode: Md3ContainerBody.Fit
    /// Optional required field names used by validate() when no list is passed.
    property var requiredFields: []
    /// Vertical spacing between direct field children (built-in stack — no Md3VStack glue).
    property real spacing: Md3Theme.spacingMd
    /// Stretch direct children to form width.
    property bool fillFields: true
    /// When true, keep `canSubmit` / `hasErrors` fresh while typing (event-driven; no poll).
    property bool liveGate: true
    /// True when any entry in `errors` is a non-empty string.
    property bool hasErrors: false
    /// True when required fields are non-empty and `hasErrors` is false (does not run validators).
    property bool canSubmit: true
    /// True when every `requiredFields` entry has a non-empty value.
    property bool requiredSatisfied: true
    property var _wiredFields: ({})
    default property alias content: formStack.data

    signal submitted(var values)

    implicitWidth: Math.max(200, host.implicitWidth)
    implicitHeight: host.implicitHeight
    width: parent ? parent.width : implicitWidth
    Binding {
        target: root
        property: "height"
        value: root.implicitHeight
        when: !root.anchors.fill
        restoreMode: Binding.RestoreNone
    }
    readonly property Md3HeightSync _heightSync: Md3HeightSync {
        target: root
        enabled: !root.anchors.fill
        policy: Md3HeightSync.AtLeastImplicit
    }

    function setError(name, message) {
        const next = Object.assign({}, errors)
        if (message && message.length)
            next[name] = message
        else
            delete next[name]
        errors = next
        _applyErrors()
        refreshGate()
    }

    function clearErrors() {
        errors = ({})
        _applyErrors()
        refreshGate()
    }

    function errorFor(name) {
        return errors[name] !== undefined ? errors[name] : ""
    }

    function collectFields() {
        const out = []
        _walk(formStack, out)
        return out
    }

    function _walk(item, out) {
        if (!item)
            return
        if (item.name !== undefined && item.name !== null && String(item.name).length > 0)
            out.push(item)
        const kids = item.children
        if (!kids)
            return
        for (let i = 0; i < kids.length; ++i)
            _walk(kids[i], out)
    }

    function _readFieldValue(field) {
        if (field.text !== undefined)
            return field.text
        if (field.value !== undefined)
            return field.value
        if (field.checked !== undefined)
            return field.checked
        if (field.currentIndex !== undefined && field.model !== undefined) {
            const i = field.currentIndex
            if (i < 0)
                return ""
            const m = field.model
            const e = m[i]
            if (e === undefined || e === null)
                return ""
            if (typeof e === "object")
                return e.value !== undefined ? e.value : (e.text !== undefined ? e.text : e)
            return e
        }
        return undefined
    }

    function syncValues() {
        const next = Object.assign({}, values)
        const fields = collectFields()
        for (let i = 0; i < fields.length; ++i) {
            const f = fields[i]
            next[String(f.name)] = _readFieldValue(f)
        }
        values = next
        return values
    }

    function _applyErrors() {
        const fields = collectFields()
        for (let i = 0; i < fields.length; ++i) {
            const f = fields[i]
            const key = String(f.name)
            const msg = errorFor(key)
            if (f.errorText !== undefined)
                f.errorText = msg
            if (f.error !== undefined)
                f.error = msg.length > 0
        }
    }

    function _mapHasErrors(map) {
        if (!map)
            return false
        for (const k in map) {
            if (map[k] !== undefined && map[k] !== null && String(map[k]).length > 0)
                return true
        }
        return false
    }

    function _requiredOk(vals, req) {
        if (!req || !req.length)
            return true
        for (let i = 0; i < req.length; ++i) {
            const v = vals[req[i]]
            if (v === undefined || v === null || String(v).length === 0)
                return false
        }
        return true
    }

    /// Refresh `hasErrors` / `requiredSatisfied` / `canSubmit` from current fields + `errors`.
    function refreshGate() {
        syncValues()
        const err = _mapHasErrors(errors)
        const reqOk = _requiredOk(values, requiredFields)
        hasErrors = err
        requiredSatisfied = reqOk
        canSubmit = reqOk && !err
        return canSubmit
    }

    function _scheduleRefreshGate() {
        if (!liveGate)
            return
        gateDebounce.restart()
    }

    function _wireField(field) {
        if (!field || field.name === undefined || field.name === null)
            return
        const key = String(field.name)
        if (!key.length || _wiredFields[key])
            return
        const next = Object.assign({}, _wiredFields)
        next[key] = true
        _wiredFields = next
        function hook(sig) {
            if (sig === undefined || sig === null)
                return
            try {
                sig.connect(_scheduleRefreshGate)
            } catch (e) {
                // Property may not be a signal on some custom fields.
            }
        }
        hook(field.textChanged)
        hook(field.checkedChanged)
        hook(field.currentIndexChanged)
        hook(field.valueChanged)
        hook(field.toggled)
    }

    function _wireAllFields() {
        if (!liveGate)
            return
        const fields = collectFields()
        for (let i = 0; i < fields.length; ++i)
            _wireField(fields[i])
    }

    function validate(required) {
        syncValues()
        let ok = true
        const next = ({})
        const req = required && required.length ? required : requiredFields
        if (!req || !req.length) {
            errors = ({})
            _applyErrors()
            refreshGate()
            return true
        }
        for (let i = 0; i < req.length; ++i) {
            const name = req[i]
            const v = values[name]
            if (v === undefined || v === null || String(v).length === 0) {
                next[name] = qsTr("Required")
                ok = false
            }
        }
        errors = next
        _applyErrors()
        refreshGate()
        return ok
    }

    /// Run `validate()`; on success emit `submitted(values)` and return true.
    function submit() {
        if (!validate()) {
            if (typeof Md3Accessibility !== "undefined" && Md3Accessibility.announceError) {
                const keys = Object.keys(errors || ({}))
                let msg = qsTr("Form has errors")
                if (keys.length) {
                    const first = errors[keys[0]]
                    if (first)
                        msg = String(first)
                }
                Md3Accessibility.announceError(msg)
            }
            return false
        }
        submitted(values)
        return true
    }

    onErrorsChanged: Qt.callLater(function () {
        _applyErrors()
        refreshGate()
    })
    onRequiredFieldsChanged: Qt.callLater(refreshGate)
    Component.onCompleted: Qt.callLater(function () {
        refreshGate()
        _wireAllFields()
    })

    Timer {
        id: gateDebounce
        interval: 48
        repeat: false
        onTriggered: root.refreshGate()
    }

    // Fallback poll only when liveGate is on but no named fields were wired yet.
    Timer {
        interval: 800
        running: root.liveGate && root.visible
                 && Object.keys(root._wiredFields).length === 0
                 && Md3TreeVisibility.isSceneActive(root, null)
        repeat: true
        onTriggered: {
            root._wireAllFields()
            root.refreshGate()
        }
    }

    Connections {
        target: formStack
        function onChildrenChanged() {
            Qt.callLater(root._wireAllFields)
        }
    }

    Md3ContainerBody {
        id: host
        width: parent.width
        layoutMode: root.layoutMode

        Md3VStack {
            id: formStack
            width: parent.width
            spacing: root.spacing
            fillWidth: root.fillFields
            stretchChildren: root.fillFields
        }
    }
}
