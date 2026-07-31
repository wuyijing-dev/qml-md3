import QtQuick
import Md3

/// Read-only code block with lightweight syntax highlighting (QML / JS / C++ / JSON / plain).
Item {
    id: root

    property string code: ""
    property string language: "qml" // qml | js | javascript | cpp | c++ | json | plain
    property bool showLineNumbers: true
    property bool wrap: false
    property real fontSize: 12
    property string fontFamily: {
        const mono = "Cascadia Code, Consolas, 'Courier New', monospace"
        return mono
    }
    property int padding: 12
    property int maxHeight: 280
    /// When false, height grows with content (still clipped by parent).
    property bool scrollable: true

    readonly property string _lang: {
        const l = String(language).toLowerCase()
        if (l === "javascript")
            return "js"
        if (l === "c++")
            return "cpp"
        return l
    }

    implicitWidth: 360
    implicitHeight: scrollable ? Math.min(maxHeight, chrome.implicitHeight)
    height: implicitHeight
                               : chrome.implicitHeight

    function _escapeHtml(s) {
        return String(s)
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
    }

    function _keywords() {
        switch (_lang) {
        case "qml":
            return (
                "import|property|readonly|alias|signal|function|return|if|else|for|while|"
                + "switch|case|break|continue|true|false|null|undefined|var|let|const|"
                + "new|this|parent|id|as|enum|required|default|component|pragma|"
                + "onCompleted|Qt|qsTr"
            )
        case "js":
            return (
                "function|return|if|else|for|while|switch|case|break|continue|true|false|"
                + "null|undefined|var|let|const|new|this|class|extends|import|export|"
                + "from|async|await|try|catch|finally|throw|typeof|instanceof|of|in"
            )
        case "cpp":
            return (
                "alignas|alignof|and|and_eq|asm|auto|bitand|bitor|bool|break|case|catch|"
                + "char|class|compl|concept|const|consteval|constexpr|constinit|continue|"
                + "co_await|co_return|co_yield|decltype|default|delete|do|double|else|"
                + "enum|explicit|export|extern|false|float|for|friend|goto|if|inline|"
                + "int|long|mutable|namespace|new|noexcept|not|not_eq|nullptr|operator|"
                + "or|or_eq|private|protected|public|register|reinterpret_cast|requires|"
                + "return|short|signed|sizeof|static|static_assert|static_cast|struct|"
                + "switch|template|this|thread_local|throw|true|try|typedef|typeid|"
                + "typename|union|unsigned|using|virtual|void|volatile|wchar_t|while|"
                + "xor|xor_eq|override|final|Q_OBJECT|Q_PROPERTY|Q_INVOKABLE|signals|slots"
            )
        case "json":
            return "true|false|null"
        default:
            return ""
        }
    }

    function _highlightLine(line) {
        if (_lang === "plain" || line.length === 0)
            return _escapeHtml(line)

        const kw = _keywords()
        const kwRe = kw.length ? new RegExp("\\b(" + kw + ")\\b", "g") : null
        // Split into strings / comments / rest (single-line aware).
        const parts = []
        let i = 0
        const s = line
        while (i < s.length) {
            // line comment
            if (_lang !== "json" && s[i] === "/" && s[i + 1] === "/") {
                parts.push({ t: "c", v: s.substring(i) })
                break
            }
            // block comment start (rest of line)
            if (_lang !== "json" && s[i] === "/" && s[i + 1] === "*") {
                const end = s.indexOf("*/", i + 2)
                if (end < 0) {
                    parts.push({ t: "c", v: s.substring(i) })
                    break
                }
                parts.push({ t: "c", v: s.substring(i, end + 2) })
                i = end + 2
                continue
            }
            // string
            if (s[i] === "\"" || s[i] === "'" || (_lang !== "json" && s[i] === "`")) {
                const q = s[i]
                let j = i + 1
                while (j < s.length) {
                    if (s[j] === "\\" && j + 1 < s.length) {
                        j += 2
                        continue
                    }
                    if (s[j] === q)
                        break
                    j++
                }
                parts.push({ t: "s", v: s.substring(i, Math.min(s.length, j + 1)) })
                i = Math.min(s.length, j + 1)
                continue
            }
            // plain chunk until special
            let j = i + 1
            while (j < s.length) {
                const c = s[j]
                if (c === "\"" || c === "'" || c === "`")
                    break
                if (_lang !== "json" && c === "/" && (s[j + 1] === "/" || s[j + 1] === "*"))
                    break
                j++
            }
            parts.push({ t: "p", v: s.substring(i, j) })
            i = j
        }

        const cKeyword = Md3Theme.colorScheme.primary
        const cString = Md3Theme.colorScheme.tertiary
        const cComment = Md3Theme.colorScheme.colorOnSurfaceVariant
        const cNumber = Md3Theme.colorScheme.secondary
        const cType = Md3Theme.colorScheme.error

        function span(color, text, italic) {
            const style = "color:" + color
                        + (italic ? ";font-style:italic" : "")
                        + ";opacity:" + (italic ? "0.85" : "1")
            return "<span style=\"" + style + "\">" + text + "</span>"
        }

        let html = ""
        for (let p = 0; p < parts.length; ++p) {
            const part = parts[p]
            if (part.t === "c") {
                html += span(cComment, _escapeHtml(part.v), true)
                continue
            }
            if (part.t === "s") {
                html += span(cString, _escapeHtml(part.v), false)
                continue
            }
            let chunk = _escapeHtml(part.v)
            // numbers
            chunk = chunk.replace(
                /\b(0x[0-9a-fA-F]+|\d+\.\d+|\d+)\b/g,
                function (m) { return span(cNumber, m, false) }
            )
            // qml/cpp types (capitalized identifiers) — light heuristic
            if (_lang === "qml" || _lang === "cpp") {
                chunk = chunk.replace(
                    /\b([A-Z][A-Za-z0-9_]+)\b/g,
                    function (m) {
                        if (kwRe && new RegExp("^(" + kw + ")$").test(m))
                            return m
                        return span(cType, m, false)
                    }
                )
            }
            if (kwRe) {
                chunk = chunk.replace(kwRe, function (m) {
                    return span(cKeyword, m, false)
                })
            }
            html += chunk
        }
        return html
    }

    function _buildHtml() {
        const lines = String(code).replace(/\r\n/g, "\n").split("\n")
        const onSurf = Md3Theme.colorScheme.colorOnSurface
        let body = ""
        for (let i = 0; i < lines.length; ++i) {
            const num = showLineNumbers
                ? ("<td style=\"color:" + Md3Theme.colorScheme.colorOnSurfaceVariant
                   + ";text-align:right;padding-right:12px;user-select:none;opacity:0.7;\">"
                   + (i + 1) + "</td>")
                : ""
            body += "<tr>" + num
                 + "<td style=\"color:" + onSurf + ";white-space:"
                 + (wrap ? "pre-wrap" : "pre") + ";\">"
                 + _highlightLine(lines[i]) + "</td></tr>"
        }
        return "<table style=\"border-collapse:collapse;font-family:"
                + fontFamily + ";font-size:" + fontSize + "px;line-height:1.45;\">"
                + body + "</table>"
    }

    property string _html: ""
    property int _gen: 0

    function refresh() {
        _html = _buildHtml()
        _gen++
    }

    onCodeChanged: refresh()
    onLanguageChanged: refresh()
    onShowLineNumbersChanged: refresh()
    onWrapChanged: refresh()
    onFontSizeChanged: refresh()
    Component.onCompleted: refresh()
    Connections {
        target: Md3Theme
        function onDarkChanged() { root.refresh() }
        function onSeedChanged() { themeTimer.restart() }
    }
    Timer {
        id: themeTimer
        interval: 40
        onTriggered: root.refresh()
    }

    Rectangle {
        id: chrome
        anchors.fill: parent
        radius: Md3Theme.shape.medium
        color: Md3Theme.colorScheme.surfaceContainerLowest
        border.width: 1
        border.color: Md3Theme.colorScheme.outlineVariant
        implicitHeight: Math.max(80, flick.contentHeight + root.padding * 2)
        clip: true

            Flickable {
            id: flick
            anchors.fill: parent
            anchors.margins: root.padding
            contentWidth: Math.max(width, codeText.implicitWidth)
            contentHeight: codeText.implicitHeight
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            interactive: root.scrollable
                && (contentHeight > height + 1 || contentWidth > width + 1)

            Text {
                id: codeText
                width: root.wrap ? flick.width : implicitWidth
                textFormat: Text.RichText
                text: root._html
                color: Md3Theme.colorScheme.colorOnSurface
                wrapMode: root.wrap ? Text.WrapAnywhere : Text.NoWrap
                property int gen: root._gen
            }
        }
    }
}
