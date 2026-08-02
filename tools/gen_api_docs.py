#!/usr/bin/env python3
"""Extract Md3 public API from QML (+ C++ QML_ELEMENT headers) into docs/api/.

Parses:
  - Top-level QML properties / aliases / enums / signals / functions
  - Leading ``///`` and trailing ``//`` docs
  - Enum-typed ``int`` defaults (``Md3Button.Filled`` → Variant)
  - Function return types (``function foo(): bool``)
  - Md3 inheritance chains
  - C++ ``Q_PROPERTY`` / ``Q_INVOKABLE`` / signals / enums for selected headers

Hand-written appendices in ``docs/api-manual/<Type>.md`` are appended after regen.
"""

from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / "src" / "Md3"
OUT = ROOT / "docs" / "api"
MANUAL = ROOT / "docs" / "api-manual"

SCAN_DIRS = [
    SRC / "components",
    SRC / "window",
    SRC / "foundation",
    SRC / "primitives",
    SRC / "layout",
]

SKIP_NAMES = {
    "Md3WindowBody",
    "Md3WindowPlatformWindows",
    "Md3WindowPlatformLinux",
    "Md3WindowPlatformMacOS",
    "Md3WindowPlatformMobile",
    "Md3ChartInteraction",
}

# C++ types exposed to QML / host docs (regenerated from headers).
CPP_SOURCES: list[tuple[str, Path, str]] = [
    ("Md3WindowHelper", SRC / "window" / "md3windowhelper.h", "Native window chrome / taskbar / tray / DPI."),
    ("Md3Graphics", SRC / "window" / "md3graphics.h", "RHI / alpha-buffer helpers."),
    ("Md3ChartData", SRC / "charts" / "md3chartdata.h", "Chart series / downsampling."),
    ("Md3AppSettings", SRC / "diagnostics" / "md3appsettings.h", "QSettings facade for QML."),
    ("Md3HotReload", SRC / "diagnostics" / "md3hotreload.h", "QML hot-reload watcher."),
    ("Md3NativeShell", SRC / "window" / "md3nativeshell.h", "Desktop shell hooks (login item, etc.)."),
    ("Md3QtCompat", SRC / "foundation" / "md3qtcompat.h", "Qt kit facts + layout policy helpers."),
    ("Md3HeightSync", SRC / "layout" / "md3heightsync.h", "Keep item height/width aligned with implicit size."),
]

ENUM_RE = re.compile(r"^\s*enum\s+(\w+)\s*\{([^}]*)\}", re.MULTILINE)
PROP_RE = re.compile(
    r"^\s*(?:(?P<default_prop>default)\s+)?"
    r"(?:(?P<required>required)\s+)?"
    r"(?:(?P<readonly>readonly)\s+)?"
    r"property\s+"
    r"(?:alias\s+(?P<alias_name>[A-Za-z_][A-Za-z0-9_]*)\s*:\s*(?P<alias_target>[^\n]+)"
    r"|"
    r"(?P<type>[A-Za-z0-9_.<>,\s*]+?)\s+"
    r"(?P<name>[A-Za-z_][A-Za-z0-9_]*)"
    r"(?:\s*:\s*(?P<default>[^\n]+))?)",
    re.MULTILINE,
)
SIGNAL_RE = re.compile(
    r"^\s*signal\s+(?P<name>[A-Za-z_][A-Za-z0-9_]*)\s*"
    r"(?:\((?P<args>[^)]*)\))?",
    re.MULTILINE,
)
FUNC_RE = re.compile(
    r"^\s*function\s+(?P<name>[A-Za-z_][A-Za-z0-9_]*)\s*"
    r"\((?P<args>[^)]*)\)"
    r"(?:\s*:\s*(?P<ret>[A-Za-z0-9_.<>,\s*]+))?",
    re.MULTILINE,
)
DOC_LINE_RE = re.compile(r"^\s*///\s?(.*)$")
TRAIL_COMMENT_RE = re.compile(r"^(.*?)(?:///\s?(.*)|//\s?(.*))$")
SINGLETON_RE = re.compile(r"^\s*pragma\s+Singleton\b", re.MULTILINE)
ENUM_DEFAULT_RE = re.compile(r"^(?P<type>Md3\w+)\.(?P<value>[A-Za-z_][A-Za-z0-9_]*)$")

# Common undocumented names → short English description (QML consumer-facing).
INFER_DOCS: dict[str, str] = {
    "variant": "Visual / role variant (see Enums).",
    "size": "Control size token (see Enums).",
    "density": "Layout density (see Enums / theme).",
    "text": "Primary label text.",
    "icon": "Material icon name or empty.",
    "iconName": "Material icon name or empty.",
    "title": "Title text.",
    "subtitle": "Secondary supporting text.",
    "enabled": "Whether the control accepts interaction.",
    "visible": "Whether the item is visible.",
    "loading": "Show loading / busy presentation.",
    "busy": "Show busy presentation and block activation.",
    "interactive": "Gate activation without forcing `enabled: false`.",
    "checked": "Checked / on state.",
    "value": "Current value.",
    "from": "Range lower bound.",
    "to": "Range upper bound.",
    "model": "Data model.",
    "count": "Item count.",
    "index": "Current index.",
    "currentIndex": "Current index.",
    "placeholderText": "Placeholder when empty.",
    "errorText": "Validation error string (empty = ok).",
    "helperText": "Helper / supporting text under the field.",
    "label": "Field / control label.",
    "name": "Form field key / identity.",
    "width": "Explicit width.",
    "height": "Explicit height.",
    "implicitWidth": "Preferred width from content.",
    "implicitHeight": "Preferred height from content.",
    "radius": "Corner radius.",
    "cornerRadius": "Corner radius.",
    "color": "Foreground / content color.",
    "opacity": "Opacity 0…1.",
    "clip": "Clip children to bounds.",
    "padding": "Uniform padding.",
    "spacing": "Child spacing.",
    "orientation": "Layout orientation.",
    "columns": "Column definitions or count.",
    "rows": "Row data or count.",
    "pageSize": "Rows / items per page.",
    "currentPage": "Zero-based page index.",
    "selectedRow": "Selected row index (−1 = none).",
    "selectedIndices": "Multi-selection indices.",
    "selectionEnabled": "Enable row selection UI.",
    "sortColumn": "Sorted column index (−1 = none).",
    "sortOrder": "`Qt.AscendingOrder` / `Qt.DescendingOrder`.",
    "filterText": "Global filter string.",
    "emptyTitle": "Empty-state title.",
    "emptyBody": "Empty-state body.",
    "emptyIcon": "Empty-state icon name.",
    "emptyActionText": "Empty-state action label.",
    "accessibleName": "Accessible name override.",
    "accessibleDescription": "Accessible description override.",
    "focusFirstError": "Focus (and scroll to) the first invalid field.",
    "submit": "Validate then emit success; on failure focus first error.",
    "validate": "Run validation and refresh error map.",
    "reset": "Clear values / errors to defaults.",
    "copy": "Copy text (optional toast feedback).",
    "showShellInfoBar": "Show the window shell InfoBar.",
    "dismissShellInfoBar": "Dismiss the window shell InfoBar.",
    "open": "Open the overlay / dialog.",
    "close": "Close the overlay / dialog.",
    "toggle": "Toggle open / checked state.",
    "clear": "Clear value / selection.",
    "refresh": "Refresh content.",
}


def strip_block_comments(text: str) -> str:
    return re.sub(r"/\*.*?\*/", "", text, flags=re.DOTALL)


def strip_line_comment(s: str) -> str:
    out: list[str] = []
    in_s = in_d = False
    i = 0
    while i < len(s):
        c = s[i]
        if c == "'" and not in_d:
            in_s = not in_s
        elif c == '"' and not in_s:
            in_d = not in_d
        elif c == "/" and not in_s and not in_d and i + 1 < len(s) and s[i + 1] == "/":
            break
        out.append(c)
        i += 1
    return "".join(out).rstrip()


def split_trail_comment(line: str) -> tuple[str, str]:
    """Return (code_without_comment, trailing_doc)."""
    out: list[str] = []
    in_s = in_d = False
    i = 0
    while i < len(line):
        c = line[i]
        if c == "'" and not in_d:
            in_s = not in_s
            out.append(c)
        elif c == '"' and not in_s:
            in_d = not in_d
            out.append(c)
        elif c == "/" and not in_s and not in_d and i + 1 < len(line) and line[i + 1] == "/":
            rest = line[i + 2 :]
            if rest.startswith("/"):
                rest = rest[1:]
            return "".join(out).rstrip(), rest.strip()
        else:
            out.append(c)
        i += 1
    return "".join(out).rstrip(), ""


def leading_doc(lines: list[str], idx: int) -> str:
    docs: list[str] = []
    j = idx - 1
    while j >= 0:
        s = lines[j].strip()
        if not s:
            j -= 1
            continue
        m = DOC_LINE_RE.match(lines[j])
        if m:
            docs.append(m.group(1).strip())
            j -= 1
            continue
        break
    docs.reverse()
    return " ".join(docs)


def find_extends(text: str) -> str:
    for line in text.splitlines():
        s = line.strip()
        if not s or s.startswith("//") or s.startswith("import ") or s.startswith("pragma "):
            continue
        if s.startswith("///"):
            continue
        m = re.match(r"^([A-Za-z0-9_.]+)\s*\{", s)
        if m:
            return m.group(1)
        break
    return "Item"


def truncate_default(default: str) -> str:
    default = strip_line_comment(default).strip()
    if not default:
        return ""
    if "{" in default:
        return "{…}"
    if len(default) > 80:
        return default[:77] + "…"
    return default


def looks_incomplete_default(default: str) -> bool:
    s = default.rstrip()
    if not s:
        return False
    if s.endswith(("?", ":", "||", "&&", "+", "-", "*", "/", ",", "(")):
        return True
    for a, b in (("(", ")"), ("[", "]"), ("{", "}")):
        if s.count(a) > s.count(b):
            return True
    return False


def expand_multiline_default(lines: list[str], start_idx: int, default: str) -> str:
    if not default or not looks_incomplete_default(default):
        return default
    parts = [default]
    j = start_idx + 1
    while j < len(lines):
        nxt = lines[j]
        if not nxt.strip():
            break
        indent = len(nxt) - len(nxt.lstrip(" "))
        if indent < 8:
            break
        piece = strip_line_comment(nxt).strip()
        if not piece or piece.startswith(("property ", "function ", "signal ", "enum ", "readonly ")):
            break
        parts.append(piece)
        joined = " ".join(parts)
        if not looks_incomplete_default(joined):
            return truncate_default(joined)
        j += 1
    return truncate_default(" ".join(parts))


def infer_doc(name: str, *, kind: str = "prop") -> str:
    if name in INFER_DOCS:
        return INFER_DOCS[name]
    # camelCase → sentence
    spaced = re.sub(r"([a-z])([A-Z])", r"\1 \2", name).replace("_", " ")
    spaced = spaced[0].upper() + spaced[1:] if spaced else name
    if kind == "signal":
        return f"Emitted when {spaced[0].lower() + spaced[1:] if len(spaced) > 1 else spaced}."
    # props + funcs: humanize camelCase when no curated blurb
    return f"{spaced}."


def resolve_enum_type(type_name: str, default: str, enums: list[dict], owner: str) -> str:
    """Enrich `int`/`var` types when default is Owner.EnumValue."""
    d = (default or "").strip()
    m = ENUM_DEFAULT_RE.match(d)
    if not m:
        # Also match Type.Value when Type == owner
        if d.startswith(owner + "."):
            value = d[len(owner) + 1 :]
            for e in enums:
                if value in e["values"]:
                    return f"{type_name} ({owner}.{e['name']})"
        return type_name
    etype, value = m.group("type"), m.group("value")
    if etype != owner and type_name not in ("int", "var", "?"):
        return type_name
    for e in enums:
        if value in e["values"]:
            return f"{type_name} ({etype}.{e['name']})"
    return f"{type_name} ({etype}.*)" if etype == owner else type_name


def member_doc(leading: str, trailing: str, name: str, *, kind: str) -> str:
    doc = (leading or trailing or "").strip()
    if doc:
        return doc
    return infer_doc(name, kind=kind)


def parse_qml(path: Path) -> dict:
    raw = path.read_text(encoding="utf-8")
    text = strip_block_comments(raw)
    lines = text.splitlines()
    name = path.stem
    extends = find_extends(text)
    singleton = bool(SINGLETON_RE.search(text))

    file_doc: list[str] = []
    for line in lines[:40]:
        m = DOC_LINE_RE.match(line)
        if m:
            file_doc.append(m.group(1).strip())
            continue
        s = line.strip()
        if not s or s.startswith("import ") or s.startswith("pragma ") or s.startswith("//"):
            continue
        if s.startswith("///"):
            continue
        break

    enums = []
    for m in ENUM_RE.finditer(text):
        raw_vals = m.group(2).split(",")
        values = []
        for v in raw_vals:
            v = strip_line_comment(v).strip()
            if not v:
                continue
            values.append(v.split("=")[0].strip())
        if values:
            enums.append({"name": m.group(1), "values": values})

    props = []
    for i, line in enumerate(lines):
        code, trail = split_trail_comment(line)
        m = PROP_RE.match(code)
        if not m:
            continue
        indent = len(line) - len(line.lstrip(" "))
        if indent > 4:
            continue

        if m.group("alias_name"):
            pname = m.group("alias_name")
            if pname.startswith("_"):
                continue
            target = truncate_default(m.group("alias_target") or "")
            is_default = bool(m.group("default_prop"))
            doc = member_doc(
                leading_doc(lines, i),
                trail,
                pname,
                kind="prop",
            )
            if not doc:
                doc = ("Default property → " if is_default else "Alias → ") + f"`{target}`"
            props.append(
                {
                    "readonly": False,
                    "required": False,
                    "default_prop": is_default,
                    "type": "alias",
                    "name": pname,
                    "default": target,
                    "doc": doc,
                }
            )
            continue

        pname = m.group("name")
        if not pname or pname.startswith("_"):
            continue
        ptype = (m.group("type") or "").strip()
        raw_default = (m.group("default") or "").strip()
        default = truncate_default(expand_multiline_default(lines, i, raw_default))
        ptype = resolve_enum_type(ptype, default, enums, name)
        doc = member_doc(leading_doc(lines, i), trail, pname, kind="prop")
        if m.group("default_prop") and not doc:
            doc = "Default property"
        if m.group("required") and not doc:
            doc = "Required"
        props.append(
            {
                "readonly": bool(m.group("readonly")),
                "required": bool(m.group("required")),
                "default_prop": bool(m.group("default_prop")),
                "type": ptype,
                "name": pname,
                "default": default,
                "doc": doc,
            }
        )

    signals = []
    for i, line in enumerate(lines):
        code, trail = split_trail_comment(line)
        m = SIGNAL_RE.match(code)
        if not m:
            continue
        indent = len(line) - len(line.lstrip(" "))
        if indent > 4:
            continue
        sname = m.group("name")
        if sname.startswith("_"):
            continue
        signals.append(
            {
                "name": sname,
                "args": (m.group("args") or "").strip(),
                "doc": member_doc(leading_doc(lines, i), trail, sname, kind="signal"),
            }
        )

    funcs = []
    for i, line in enumerate(lines):
        code, trail = split_trail_comment(line)
        m = FUNC_RE.match(code)
        if not m:
            continue
        indent = len(line) - len(line.lstrip(" "))
        if indent > 4:
            continue
        fname = m.group("name")
        if fname.startswith("_"):
            continue
        funcs.append(
            {
                "name": fname,
                "args": (m.group("args") or "").strip(),
                "ret": (m.group("ret") or "").strip(),
                "doc": member_doc(leading_doc(lines, i), trail, fname, kind="func"),
            }
        )

    seen: set[str] = set()
    uniq_props = []
    for p in props:
        if p["name"] in seen:
            continue
        seen.add(p["name"])
        uniq_props.append(p)

    return {
        "kind": "qml",
        "name": name,
        "path": path.relative_to(ROOT).as_posix(),
        "extends": extends,
        "singleton": singleton,
        "summary": " ".join(file_doc).strip(),
        "enums": enums,
        "props": uniq_props,
        "signals": signals,
        "funcs": funcs,
    }


# --- C++ header parsing -------------------------------------------------------

CPP_PROP_RE = re.compile(
    r"Q_PROPERTY\s*\(\s*(?P<type>[\w:<>\s*]+?)\s+(?P<name>\w+)\s+"
    r"(?P<body>[^)]*)\)",
    re.MULTILINE,
)
CPP_INVOKABLE_RE = re.compile(
    r"Q_INVOKABLE\s+(?P<ret>[\w:<>\s*&]+?)\s+(?P<name>\w+)\s*\((?P<args>[^)]*)\)\s*(?:const)?\s*;",
    re.MULTILINE,
)
CPP_ENUM_RE = re.compile(
    r"enum\s+(?:class\s+)?(?P<name>\w+)\s*\{(?P<body>[^}]*)\}",
    re.MULTILINE,
)
CPP_SIGNAL_BLOCK_RE = re.compile(
    r"Q_SIGNALS:\s*(?P<body>.*?)(?:public:|protected:|private:|Q_OBJECT|\Z)",
    re.MULTILINE | re.DOTALL,
)
CPP_SIGNAL_LINE_RE = re.compile(
    r"^\s*void\s+(?P<name>\w+)\s*\((?P<args>[^)]*)\)\s*;",
    re.MULTILINE,
)
CPP_CLASS_RE = re.compile(r"class\s+(?P<name>\w+)\s*(?::\s*public\s+(?P<base>[\w:]+))?")


def cpp_type_qmlish(t: str) -> str:
    t = " ".join(t.split())
    mapping = {
        "QString": "string",
        "QUrl": "url",
        "QColor": "color",
        "qreal": "real",
        "qsizetype": "int",
        "quint32": "int",
        "quint64": "int",
        "qint32": "int",
        "qint64": "int",
        "uint": "int",
        "qlonglong": "int",
        "QVariant": "var",
        "QVariantList": "var",
        "QVariantMap": "var",
        "QStringList": "var",
        "QObject *": "var",
        "QObject*": "var",
        "QQuickWindow *": "var",
        "QQuickWindow*": "var",
        "QWindow *": "var",
        "QWindow*": "var",
        "void": "void",
        "bool": "bool",
        "int": "int",
        "double": "real",
        "float": "real",
    }
    if t in mapping:
        return mapping[t]
    if t.endswith("*"):
        return "var"
    return t.replace("::", ".")


def parse_cpp_header(path: Path, qml_name: str, summary: str) -> dict | None:
    if not path.is_file():
        return None
    text = strip_block_comments(path.read_text(encoding="utf-8", errors="ignore"))
    class_m = CPP_CLASS_RE.search(text)
    extends = "QObject"
    if class_m and class_m.group("base"):
        extends = class_m.group("base").split("::")[-1]

    enums = []
    for m in CPP_ENUM_RE.finditer(text):
        vals = []
        for part in m.group("body").split(","):
            part = strip_line_comment(part).strip()
            if not part:
                continue
            vals.append(part.split("=")[0].strip())
        if vals:
            enums.append({"name": m.group("name"), "values": vals})

    props = []
    for m in CPP_PROP_RE.finditer(text):
        body = m.group("body")
        name = m.group("name")
        if name.startswith("_"):
            continue
        readonly = "WRITE" not in body
        constant = "CONSTANT" in body
        notify = None
        nm = re.search(r"NOTIFY\s+(\w+)", body)
        if nm:
            notify = nm.group(1)
        doc = ""
        if constant:
            doc = "Constant"
        elif notify:
            doc = f"Notify: `{notify}`"
        props.append(
            {
                "readonly": readonly or constant,
                "required": False,
                "default_prop": False,
                "type": cpp_type_qmlish(m.group("type")),
                "name": name,
                "default": "",
                "doc": doc or infer_doc(name),
            }
        )

    signals = []
    for block in CPP_SIGNAL_BLOCK_RE.finditer(text):
        for sm in CPP_SIGNAL_LINE_RE.finditer(block.group("body")):
            sname = sm.group("name")
            if sname.startswith("_"):
                continue
            signals.append(
                {
                    "name": sname,
                    "args": " ".join(sm.group("args").split()),
                    "doc": infer_doc(sname, kind="signal"),
                }
            )

    funcs = []
    for m in CPP_INVOKABLE_RE.finditer(text):
        fname = m.group("name")
        if fname.startswith("_"):
            continue
        funcs.append(
            {
                "name": fname,
                "args": " ".join(m.group("args").split()),
                "ret": cpp_type_qmlish(m.group("ret")),
                "doc": infer_doc(fname, kind="func"),
            }
        )

    # Dedupe props
    seen: set[str] = set()
    uniq = []
    for p in props:
        if p["name"] in seen:
            continue
        seen.add(p["name"])
        uniq.append(p)

    return {
        "kind": "cpp",
        "name": qml_name,
        "path": path.relative_to(ROOT).as_posix(),
        "extends": extends,
        "singleton": False,
        "summary": summary,
        "enums": enums,
        "props": uniq,
        "signals": signals,
        "funcs": funcs,
    }


def parse_md3_cpp_bootstrap() -> dict:
    """Document Md3::RunOptions / C ABI from md3.h + md3_capi.h."""
    h = (SRC / "md3.h").read_text(encoding="utf-8", errors="ignore") if (SRC / "md3.h").is_file() else ""
    c = (SRC / "md3_capi.h").read_text(encoding="utf-8", errors="ignore") if (SRC / "md3_capi.h").is_file() else ""
    props = []
    # struct RunOptions fields
    m = re.search(r"struct\s+RunOptions\s*\{(.*?)\};", h, re.S)
    if m:
        for line in m.group(1).splitlines():
            line = strip_line_comment(line).strip().rstrip(";")
            if not line or line.startswith("RunOptions") or line.startswith("public"):
                continue
            # Type name = default
            mm = re.match(r"^([\w:<>,\s*&]+?)\s+(\w+)(?:\s*=\s*(.+))?$", line)
            if not mm:
                continue
            props.append(
                {
                    "readonly": False,
                    "required": False,
                    "default_prop": False,
                    "type": cpp_type_qmlish(mm.group(1).strip()),
                    "name": mm.group(2),
                    "default": truncate_default(mm.group(3) or ""),
                    "doc": infer_doc(mm.group(2)),
                }
            )
    funcs = []
    for rx in (
        r"\b(run|initialize|loadFonts|versionString)\s*\(",
        r"MD3_API\s+[\w\s*]+\s+(md3_\w+)\s*\(",
    ):
        for m in re.finditer(rx, h + "\n" + c):
            name = m.group(1)
            if name.startswith("md3_"):
                funcs.append(
                    {
                        "name": name,
                        "args": "…",
                        "ret": "int/string",
                        "doc": infer_doc(name, kind="func"),
                    }
                )
            else:
                funcs.append(
                    {
                        "name": f"Md3::{name}",
                        "args": "…",
                        "ret": "see header",
                        "doc": infer_doc(name, kind="func"),
                    }
                )
    # unique funcs
    seen: set[str] = set()
    uniq_f = []
    for f in funcs:
        if f["name"] in seen:
            continue
        seen.add(f["name"])
        uniq_f.append(f)

    return {
        "kind": "cpp",
        "name": "Md3_cpp",
        "path": "src/Md3/md3.h",
        "extends": "—",
        "singleton": False,
        "summary": "C++ bootstrap (`Md3::run` / `RunOptions`) and C ABI (`md3_capi.h`).",
        "enums": [],
        "props": props,
        "signals": [],
        "funcs": uniq_f,
    }


def md_escape(s: str) -> str:
    return s.replace("|", "\\|")


def collect_inherited_members(name: str, infos: dict[str, dict]) -> tuple[list, list, list, list]:
    props, signals, funcs, enums = [], [], [], []
    seen_p, seen_s, seen_f, seen_e = set(), set(), set(), set()
    cur = infos[name]["extends"]
    visited = set()
    while cur and cur in infos and cur not in visited:
        visited.add(cur)
        parent = infos[cur]
        for e in parent["enums"]:
            key = e["name"]
            if key not in seen_e:
                seen_e.add(key)
                enums.append({**e, "from": cur})
        for p in parent["props"]:
            if p["name"] not in seen_p:
                seen_p.add(p["name"])
                props.append({**p, "from": cur})
        for s in parent["signals"]:
            if s["name"] not in seen_s:
                seen_s.add(s["name"])
                signals.append({**s, "from": cur})
        for f in parent["funcs"]:
            if f["name"] not in seen_f:
                seen_f.add(f["name"])
                funcs.append({**f, "from": cur})
        cur = parent["extends"]
    return props, signals, funcs, enums


def access_label(p: dict) -> str:
    parts = []
    if p.get("default_prop"):
        parts.append("default")
    if p.get("required"):
        parts.append("required")
    if p.get("readonly"):
        parts.append("readonly")
    else:
        parts.append("read/write")
    return " ".join(parts)


def render(info: dict, infos: dict[str, dict], inheritance: dict[str, list[str]]) -> str:
    name = info["name"]
    lines = [f"# {name}", ""]
    if info["summary"]:
        lines += [info["summary"], ""]
    lines += [
        f"- **Source:** `{info['path']}`",
        f"- **Extends:** `{info['extends']}`",
    ]
    if info.get("kind") == "cpp":
        lines.append("- **Kind:** C++ / QML_ELEMENT (generated from header)")
    if info.get("singleton"):
        lines.append("- **Singleton:** `true` (`pragma Singleton`)")

    own_n = len(info["props"])
    sig_n = len(info["signals"])
    fn_n = len(info["funcs"])
    en_n = len(info["enums"])
    lines += [
        "",
        "## Overview",
        "",
        f"| Properties | Signals | Methods | Enums |",
        f"|------------|---------|---------|-------|",
        f"| {own_n} | {sig_n} | {fn_n} | {en_n} |",
        "",
    ]
    if info.get("kind") != "cpp" and info["extends"] not in infos:
        lines += [
            f"_Also inherits Qt Quick `{info['extends']}` members (not listed)._",
            "",
        ]

    lines += [
        "## Import",
        "",
        "```qml",
        "import Md3",
        "```",
        "",
    ]

    chain = inheritance.get(name, [])
    if chain:
        lines += [
            "## Inheritance",
            "",
            " → ".join(f"[`{c}`]({c}.md)" for c in [name] + chain),
            "",
        ]

    ih_props, ih_signals, ih_funcs, ih_enums = (
        collect_inherited_members(name, infos) if name in infos else ([], [], [], [])
    )

    all_enums = [{**e, "from": name} for e in info["enums"]] + ih_enums
    if all_enums:
        lines += ["## Enums", ""]
        for e in all_enums:
            src = e.get("from", name)
            vals = ", ".join(f"`{src}.{v}`" for v in e["values"])
            note = "" if src == name else f" _(from [{src}]({src}.md))_"
            lines += [f"### `{src}.{e['name']}`{note}", "", vals, ""]

    lines += ["## Properties", ""]
    own = info["props"]
    if not own and not ih_props:
        lines += ["_None._", ""]
    else:
        lines += [
            "| Name | Type | Default | Access | Defined in | Description |",
            "|------|------|---------|--------|------------|-------------|",
        ]
        for p in own:
            lines.append(
                "| `{n}` | `{t}` | `{d}` | {a} | `{src}` | {doc} |".format(
                    n=p["name"],
                    t=md_escape(p["type"] or "?"),
                    d=md_escape(p["default"] or "—"),
                    a=access_label(p),
                    src=name,
                    doc=md_escape(p["doc"] or "—"),
                )
            )
        for p in ih_props:
            if any(o["name"] == p["name"] for o in own):
                continue
            lines.append(
                "| `{n}` | `{t}` | `{d}` | {a} | [`{f}`]({f}.md) | {doc} |".format(
                    n=p["name"],
                    t=md_escape(p["type"] or "?"),
                    d=md_escape(p["default"] or "—"),
                    a=access_label(p),
                    f=p["from"],
                    doc=md_escape(p["doc"] or "—"),
                )
            )
        lines.append("")

    lines += ["## Signals", ""]
    if not info["signals"] and not ih_signals:
        lines += ["_None._", ""]
    else:
        lines += ["| Signal | Defined in | Description |", "|--------|------------|-------------|"]

        def sig_text(s: dict) -> str:
            if s.get("args"):
                return f"`{s['name']}({s['args']})`"
            return f"`{s['name']}()`"

        for s in info["signals"]:
            lines.append(f"| {sig_text(s)} | `{name}` | {md_escape(s['doc'] or '—')} |")
        for s in ih_signals:
            if any(x["name"] == s["name"] for x in info["signals"]):
                continue
            lines.append(
                f"| {sig_text(s)} | [`{s['from']}`]({s['from']}.md) | {md_escape(s['doc'] or '—')} |"
            )
        lines.append("")

    lines += ["## Methods", ""]
    if not info["funcs"] and not ih_funcs:
        lines += ["_None._", ""]
    else:
        lines += [
            "| Method | Returns | Defined in | Description |",
            "|--------|---------|------------|-------------|",
        ]

        def method_row(f: dict, defined: str) -> str:
            sig = f"`{f['name']}({f['args']})`"
            ret = md_escape(f.get("ret") or "—")
            return f"| {sig} | `{ret}` | {defined} | {md_escape(f['doc'] or '—')} |"

        for f in info["funcs"]:
            lines.append(method_row(f, f"`{name}`"))
        for f in ih_funcs:
            if any(x["name"] == f["name"] for x in info["funcs"]):
                continue
            lines.append(method_row(f, f"[`{f['from']}`]({f['from']}.md)"))
        lines.append("")

    lines += [
        "## Example",
        "",
        "```qml",
        "import Md3",
        "",
    ]
    if info.get("kind") == "cpp":
        lines += [
            f"// C++ / host type — typically used from QML as `{name} {{ }}`",
            f"{name} {{",
            "    // see properties / methods above",
            "}",
        ]
    elif info.get("singleton"):
        lines += [
            f"// Singleton — use as `{name}.…`",
            f"console.log({name})",
        ]
    else:
        lines.append(f"{name} {{")
        shown = 0
        for p in own + ih_props:
            if p.get("readonly") or p.get("required") or shown >= 6:
                continue
            if p["name"] in (
                "width",
                "height",
                "visible",
                "enabled",
                "opacity",
                "clip",
                "z",
                "x",
                "y",
                "anchors",
                "parent",
            ):
                continue
            if p["type"] == "alias":
                continue
            val = p["default"] if p["default"] and p["default"] not in ("{…}", "—") else "/* … */"
            lines.append(f"    {p['name']}: {val}")
            shown += 1
        if shown == 0:
            lines.append("    // see properties above")
        lines.append("}")
    lines += ["```", ""]
    return "\n".join(lines)


def build_inheritance(infos: dict[str, dict]) -> dict[str, list[str]]:
    out: dict[str, list[str]] = {}
    for name, info in infos.items():
        chain = []
        cur = info["extends"]
        seen = set()
        while cur and cur in infos and cur not in seen:
            seen.add(cur)
            chain.append(cur)
            cur = infos[cur]["extends"]
        out[name] = chain
    return out


def category_of(path: str, name: str = "", kind: str = "qml") -> str:
    if kind == "cpp" or name == "Md3_cpp":
        return "C++ / native"
    if "/foundation/" in path:
        return "Foundation"
    if "/primitives/" in path:
        return "Primitives"
    if "/window/" in path:
        return "Window"
    if "/layout/" in path:
        return "Layout"
    if "/components/" in path:
        n = name or Path(path).stem
        if "Chart" in n or n == "Md3CodeBlock":
            return "Charts"
        if any(
            x in n
            for x in (
                "Button",
                "Fab",
                "Chip",
                "Checkbox",
                "Radio",
                "Switch",
                "Slider",
                "Segmented",
                "Toggle",
                "SplitButton",
                "Hyperlink",
                "CommandBar",
            )
        ):
            return "Actions & selection"
        if any(
            x in n
            for x in (
                "TextField",
                "Search",
                "Form",
                "Date",
                "Time",
                "CommandPalette",
                "Select",
                "ColorPicker",
                "TagField",
                "Password",
                "Number",
                "Path",
                "KeySequence",
            )
        ):
            return "Input"
        if any(
            x in n
            for x in (
                "Nav",
                "Tab",
                "AppBar",
                "Drawer",
                "Rail",
                "Document",
                "Breadcrumb",
                "Scaffold",
            )
        ):
            return "Navigation"
        if any(
            x in n
            for x in (
                "ListView",
                "GridView",
                "ItemsView",
                "VirtualList",
                "TreeView",
                "DataTable",
                "Carousel",
                "PipsPager",
                "Swipe",
                "PullToRefresh",
                "Pagination",
            )
        ):
            return "Collections"
        if any(
            x in n
            for x in (
                "Card",
                "Dialog",
                "Sheet",
                "Snack",
                "Banner",
                "Tooltip",
                "Badge",
                "Divider",
                "Expansion",
                "Table",
                "Stepper",
                "Skeleton",
                "Menu",
                "Dropdown",
                "Option",
                "Tour",
                "SplitView",
                "Avatar",
                "EmptyState",
            )
        ):
            return "Containment & feedback"
        if "Progress" in n or "Loading" in n:
            return "Progress"
        return "Components"
    return "Other"


def append_manual(body: str, name: str) -> str:
    manual = MANUAL / f"{name}.md"
    if not manual.is_file():
        return body
    extra = manual.read_text(encoding="utf-8").strip()
    if not extra:
        return body
    return body.rstrip() + "\n\n" + extra + "\n"


def main() -> None:
    files: list[Path] = []
    for d in SCAN_DIRS:
        if not d.exists():
            continue
        for p in sorted(d.rglob("*.qml")):
            if p.stem.startswith("Md3WindowPlatform"):
                continue
            if p.stem in SKIP_NAMES:
                continue
            if "platforms" in p.parts:
                continue
            files.append(p)

    infos: dict[str, dict] = {}
    for p in files:
        info = parse_qml(p)
        infos[info["name"]] = info

    # C++ / native pages (overwrite previous hand KEEP pages)
    for qml_name, header, summary in CPP_SOURCES:
        info = parse_cpp_header(header, qml_name, summary)
        if info:
            infos[qml_name] = info

    infos["Md3_cpp"] = parse_md3_cpp_bootstrap()

    inheritance = build_inheritance(infos)

    OUT.mkdir(parents=True, exist_ok=True)
    for old in OUT.glob("*.md"):
        old.unlink()

    for name, info in sorted(infos.items()):
        body = append_manual(render(info, infos, inheritance), name)
        (OUT / f"{name}.md").write_text(body, encoding="utf-8", newline="\n")

    by_cat: dict[str, list[str]] = {}
    for name, info in infos.items():
        by_cat.setdefault(category_of(info["path"], name, info.get("kind", "qml")), []).append(name)

    qml_count = sum(1 for i in infos.values() if i.get("kind") != "cpp")
    cpp_count = sum(1 for i in infos.values() if i.get("kind") == "cpp")

    index = [
        "# Md3 API Reference",
        "",
        "每个控件一份完整 API：**属性（含继承）/ 枚举 / 信号 / 方法**（含 Overview 计数）。",
        "",
        "由 `tools/gen_api_docs.py` 从 QML + 选定 C++ 头生成；改完控件后请重跑该脚本。",
        "",
        "集成与 C++ 启动：[集成](../getting-started/integration.md) · "
        "主题令牌：[令牌](../guides/tokens.md) · "
        "按钮与命令：[按钮与命令](../guides/buttons-commands.md)",
        "",
        "手写附录（WinUI 对照等）放在 [`api-manual/`](../api-manual/README.md)；"
        "重新生成时会自动拼接到对应 API 页末尾。",
        "",
        f"**QML types:** {qml_count} · **C++ / native pages:** {cpp_count}",
        "",
    ]
    # Prefer stable category order
    cat_order = [
        "C++ / native",
        "Foundation",
        "Primitives",
        "Window",
        "Layout",
        "Actions & selection",
        "Input",
        "Navigation",
        "Collections",
        "Containment & feedback",
        "Progress",
        "Charts",
        "Components",
        "Other",
    ]
    for cat in cat_order:
        if cat not in by_cat:
            continue
        index += [f"## {cat}", ""]
        for n in sorted(by_cat[cat]):
            summary = infos[n]["summary"]
            singleton = " _(singleton)_" if infos[n].get("singleton") else ""
            extra = f" — {summary}" if summary else ""
            index.append(f"- [{n}]({n}.md){singleton}{extra}")
        index.append("")
    for cat in sorted(by_cat.keys()):
        if cat in cat_order:
            continue
        index += [f"## {cat}", ""]
        for n in sorted(by_cat[cat]):
            summary = infos[n]["summary"]
            singleton = " _(singleton)_" if infos[n].get("singleton") else ""
            extra = f" — {summary}" if summary else ""
            index.append(f"- [{n}]({n}.md){singleton}{extra}")
        index.append("")

    (OUT / "README.md").write_text("\n".join(index) + "\n", encoding="utf-8", newline="\n")
    print(f"Wrote {len(infos)} API docs → {OUT} (qml={qml_count}, cpp={cpp_count})")
    print(
        "Note: local only — do not auto-commit/push Document repo; "
        "commit docs/api only when intentionally shipping API docs."
    )


if __name__ == "__main__":
    main()
