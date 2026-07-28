import QtQuick

Item {
    id: root

    property var errors: ({})
    property var values: ({})
    property int layoutMode: Md3ContainerBody.Fit
    default property alias content: host.content

    function setError(name, message) {
        const next = Object.assign({}, errors)
        if (message && message.length)
            next[name] = message
        else
            delete next[name]
        errors = next
    }

    function clearErrors() {
        errors = ({})
    }

    function validate(requiredFields) {
        clearErrors()
        let ok = true
        if (!requiredFields)
            return true
        for (let i = 0; i < requiredFields.length; ++i) {
            const name = requiredFields[i]
            const v = values[name]
            if (v === undefined || v === null || String(v).length === 0) {
                setError(name, "Required")
                ok = false
            }
        }
        return ok
    }

    function errorFor(name) {
        return errors[name] !== undefined ? errors[name] : ""
    }

    Md3ContainerBody {
        id: host
        anchors.fill: parent
        layoutMode: root.layoutMode
    }
}
