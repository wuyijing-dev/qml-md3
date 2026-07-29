import QtQuick

Item {
    id: root

    property var errors: ({})
    property var values: ({})
    property int layoutMode: Md3ContainerBody.Fit
    /// Optional required field names used by validate() when no list is passed.
    property var requiredFields: []
    /// Vertical spacing between direct field children (built-in stack — no Md3VStack glue).
    property real spacing: 12
    /// Stretch direct children to form width.
    property bool fillFields: true
    default property alias content: formStack.data

    implicitWidth: Math.max(200, host.implicitWidth)
    implicitHeight: host.implicitHeight
    width: parent ? parent.width : implicitWidth
    height: implicitHeight

    function setError(name, message) {
        const next = Object.assign({}, errors)
        if (message && message.length)
            next[name] = message
        else
            delete next[name]
        errors = next
        _applyErrors()
    }

    function clearErrors() {
        errors = ({})
        _applyErrors()
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

    function validate(required) {
        syncValues()
        let ok = true
        const next = ({})
        const req = required && required.length ? required : requiredFields
        if (!req || !req.length) {
            errors = ({})
            _applyErrors()
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
        return ok
    }

    onErrorsChanged: Qt.callLater(_applyErrors)

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
