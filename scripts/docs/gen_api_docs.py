#!/usr/bin/env python3
"""Extract QML public API from Md3 sources and write docs/api/<Type>.md.

Parses top-level QML members (properties, aliases, enums, signals, functions),
file /// summaries, pragma Singleton, and Md3 inheritance chains.
"""

from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "src" / "Md3"
OUT = ROOT / "docs" / "api"
# Hand-written appendices (WinUI notes, richer examples). Survives regen.
MANUAL = ROOT / "docs" / "api-manual"

# Paths relative to SRC that are public API surface
SCAN_DIRS = [
    SRC / "components",
    SRC / "window",
    SRC / "foundation",
    SRC / "primitives",
    SRC / "layout",
]

# Internal / platform helpers — skip
SKIP_NAMES = {
    "Md3WindowBody",
    "Md3WindowPlatformWindows",
    "Md3WindowPlatformLinux",
    "Md3WindowPlatformMacOS",
    "Md3WindowPlatformMobile",
    "Md3ChartInteraction",  # documented via Md3Chart
}

ENUM_RE = re.compile(r"^\s*enum\s+(\w+)\s*\{([^}]*)\}", re.MULTILINE)

# property [default] [required] [readonly] Type name[: default]
# property [default] alias name: path
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
    r"\((?P<args>[^)]*)\)",
    re.MULTILINE,
)
DOC_LINE_RE = re.compile(r"^\s*///\s?(.*)$")
SINGLETON_RE = re.compile(r"^\s*pragma\s+Singleton\b", re.MULTILINE)


def strip_block_comments(text: str) -> str:
    return re.sub(r"/\*.*?\*/", "", text, flags=re.DOTALL)


def strip_line_comment(s: str) -> str:
    """Remove trailing // comment outside quotes (best-effort)."""
    out = []
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
    # First non-import, non-comment type { at file scope
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
    # Unbalanced braces/parens/brackets
    for a, b in (("(", ")"), ("[", "]"), ("{", "}")):
        if s.count(a) > s.count(b):
            return True
    return False


def expand_multiline_default(lines: list[str], start_idx: int, default: str) -> str:
    """Join following indented continuation lines into a property default."""
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
        if not piece or piece.startswith("property ") or piece.startswith("function ") or piece.startswith("signal "):
            break
        parts.append(piece)
        joined = " ".join(parts)
        if not looks_incomplete_default(joined):
            return truncate_default(joined)
        j += 1
    return truncate_default(" ".join(parts))


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
            # enum Entry = 1 → Entry
            values.append(v.split("=")[0].strip())
        if values:
            enums.append({"name": m.group(1), "values": values})

    props = []
    for i, line in enumerate(lines):
        m = PROP_RE.match(line)
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
            props.append(
                {
                    "readonly": False,
                    "required": False,
                    "default_prop": is_default,
                    "type": "alias",
                    "name": pname,
                    "default": target,
                    "doc": leading_doc(lines, i)
                    or (("Default property → " if is_default else "Alias → ") + f"`{target}`"),
                }
            )
            continue

        pname = m.group("name")
        if not pname or pname.startswith("_"):
            continue
        ptype = (m.group("type") or "").strip()
        raw_default = (m.group("default") or "").strip()
        default = truncate_default(expand_multiline_default(lines, i, raw_default))
        doc = leading_doc(lines, i)
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
        m = SIGNAL_RE.match(line)
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
                "doc": leading_doc(lines, i),
            }
        )

    funcs = []
    for i, line in enumerate(lines):
        m = FUNC_RE.match(line)
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
                "doc": leading_doc(lines, i),
            }
        )

    seen = set()
    uniq_props = []
    for p in props:
        if p["name"] in seen:
            continue
        seen.add(p["name"])
        uniq_props.append(p)

    return {
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


def md_escape(s: str) -> str:
    return s.replace("|", "\\|")


def collect_inherited_members(name: str, infos: dict[str, dict]) -> tuple[list, list, list, list]:
    """Flatten parent props/signals/funcs/enums (nearest parent wins on name clash)."""
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
    if info.get("singleton"):
        lines.append("- **Singleton:** `true` (`pragma Singleton`)")
    lines += [
        "",
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

    ih_props, ih_signals, ih_funcs, ih_enums = collect_inherited_members(name, infos)

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
        lines += ["| Method | Defined in | Description |", "|--------|------------|-------------|"]
        for f in info["funcs"]:
            sig = f"`{f['name']}({f['args']})`"
            lines.append(f"| {sig} | `{name}` | {md_escape(f['doc'] or '—')} |")
        for f in ih_funcs:
            if any(x["name"] == f["name"] for x in info["funcs"]):
                continue
            sig = f"`{f['name']}({f['args']})`"
            lines.append(
                f"| {sig} | [`{f['from']}`]({f['from']}.md) | {md_escape(f['doc'] or '—')} |"
            )
        lines.append("")

    lines += [
        "## Example",
        "",
        "```qml",
        "import Md3",
        "",
    ]
    if info.get("singleton"):
        lines += [
            f"// Singleton — use as `{name}.…`",
            f"console.log({name})",
        ]
    else:
        lines.append(f"{name} {{")
        shown = 0
        for p in own + ih_props:
            if p.get("readonly") or p.get("required") or shown >= 5:
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
            if p["type"] == "alias" and p.get("default_prop"):
                continue
            val = p["default"] if p["default"] and p["default"] not in ("{…}", "—") else "/* … */"
            if p["type"] == "alias":
                continue
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


def category_of(path: str, name: str = "") -> str:
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
        if any(x in n for x in ("TextField", "Search", "Form", "Date", "Time", "CommandPalette", "Select", "ColorPicker", "TagField", "Password", "Number", "Path", "KeySequence")):
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
                "Carousel",
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

    inheritance = build_inheritance(infos)

    OUT.mkdir(parents=True, exist_ok=True)
    # Keep hand-written C++ pages; regenerate everything else.
    KEEP = {
        "Md3_cpp.md",
        "Md3Graphics.md",
        "Md3WindowHelper.md",
        "Md3ChartData.md",
        "Md3AppSettings.md",
        "Md3HotReload.md",
    }
    for old in OUT.glob("*.md"):
        if old.name in KEEP:
            continue
        old.unlink()

    for name, info in sorted(infos.items()):
        body = render(info, infos, inheritance)
        manual = MANUAL / f"{name}.md"
        if manual.is_file():
            extra = manual.read_text(encoding="utf-8").strip()
            if extra:
                body = body.rstrip() + "\n\n" + extra + "\n"
        (OUT / f"{name}.md").write_text(body, encoding="utf-8")

    by_cat: dict[str, list[str]] = {}
    for name, info in infos.items():
        by_cat.setdefault(category_of(info["path"], name), []).append(name)

    index = [
        "# Md3 API Reference",
        "",
        "每个控件一份完整 API：**属性（含继承）/ 枚举 / 信号 / 方法**。",
        "",
        "由 `scripts/docs/gen_api_docs.py` 从 QML 源码生成；改完控件后请重跑该脚本。",
        "",
        "集成与 C++ 启动：[../integration.md](../integration.md) · 主题令牌：[../tokens.md](../tokens.md) · 按钮与命令：[../buttons-commands.md](../buttons-commands.md)",
        "",
        "手写附录（WinUI 对照等）放在 [`docs/api-manual/`](../api-manual/)；重新生成时会自动拼接到对应 API 页末尾。",
        "",
        "## C++ / native",
        "",
        "- [Md3::run / initialize](Md3_cpp.md) — 一键初始化",
        "- [Md3Graphics](Md3Graphics.md) — RHI / alpha buffer",
        "- [Md3WindowHelper](Md3WindowHelper.md) — 原生窗口能力",
        "- [Md3ChartData](Md3ChartData.md) — 大数据序列降采样",
        "- [Md3AppSettings](Md3AppSettings.md) — QSettings facade",
        "- [Md3HotReload](Md3HotReload.md) — QML hot reload watcher",
        "",
        f"**QML types:** {len(infos)}",
        "",
    ]
    for cat in sorted(by_cat.keys()):
        index += [f"## {cat}", ""]
        for n in sorted(by_cat[cat]):
            summary = infos[n]["summary"]
            singleton = " _(singleton)_" if infos[n].get("singleton") else ""
            extra = f" — {summary}" if summary else ""
            index.append(f"- [{n}]({n}.md){singleton}{extra}")
        index.append("")

    (OUT / "README.md").write_text("\n".join(index) + "\n", encoding="utf-8")
    print(f"Wrote {len(infos)} API docs → {OUT}")


if __name__ == "__main__":
    main()
