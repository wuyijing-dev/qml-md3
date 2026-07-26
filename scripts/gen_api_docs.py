#!/usr/bin/env python3
"""Extract QML public API from Md3 sources and write docs/api/<Type>.md."""

from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / "src" / "Md3"
OUT = ROOT / "docs" / "api"

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

EXTENDS_RE = re.compile(
    r"^(?:///.*\n)*(?:import .+\n)*([A-Za-z0-9_.]+)\s*\{",
    re.MULTILINE,
)
ENUM_RE = re.compile(r"^\s*enum\s+(\w+)\s*\{([^}]*)\}", re.MULTILINE)
PROP_RE = re.compile(
    r"^\s*(readonly\s+)?property\s+"
    r"(?:(?P<type>[A-Za-z0-9_.<>,\s*]+?)\s+)"
    r"(?P<name>[A-Za-z_][A-Za-z0-9_]*)"
    r"(?:\s*:\s*(?P<default>[^\n]+))?",
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


def strip_block_comments(text: str) -> str:
    return re.sub(r"/\*.*?\*/", "", text, flags=re.DOTALL)


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


def parse_qml(path: Path) -> dict:
    raw = path.read_text(encoding="utf-8")
    text = strip_block_comments(raw)
    lines = text.splitlines()
    name = path.stem
    extends = find_extends(text)

    file_doc = []
    for line in lines[:30]:
        m = DOC_LINE_RE.match(line)
        if m:
            file_doc.append(m.group(1).strip())
        elif line.strip() and not line.strip().startswith("import") and not line.strip().startswith("///"):
            if not line.strip().startswith("//"):
                break

    enums = []
    for m in ENUM_RE.finditer(text):
        values = [v.strip() for v in m.group(2).split(",") if v.strip()]
        enums.append({"name": m.group(1), "values": values})

    props = []
    for i, line in enumerate(lines):
        m = PROP_RE.match(line)
        if not m:
            continue
        # skip nested object properties deep inside (heuristic: indent > 4 and not top-level)
        indent = len(line) - len(line.lstrip(" "))
        if indent > 4:
            continue
        ptype = (m.group("type") or "").strip()
        pname = m.group("name")
        default = (m.group("default") or "").strip()
        if default.endswith("{"):
            default = "{…}"
        elif len(default) > 80:
            default = default[:77] + "…"
        props.append(
            {
                "readonly": bool(m.group(1)),
                "type": ptype,
                "name": pname,
                "default": default,
                "doc": leading_doc(lines, i),
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
        signals.append(
            {
                "name": m.group("name"),
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
            continue  # private
        funcs.append(
            {
                "name": fname,
                "args": (m.group("args") or "").strip(),
                "doc": leading_doc(lines, i),
            }
        )

    # de-dupe props by name (keep first)
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
        "summary": " ".join(file_doc).strip(),
        "enums": enums,
        "props": uniq_props,
        "signals": signals,
        "funcs": funcs,
    }


def md_escape(s: str) -> str:
    return s.replace("|", "\\|")


def collect_inherited_members(name: str, infos: dict[str, dict]) -> tuple[list, list, list, list]:
    """Flatten parent props/signals/funcs/enums (nearest parent wins on name clash for listing)."""
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


def render(info: dict, infos: dict[str, dict], inheritance: dict[str, list[str]]) -> str:
    name = info["name"]
    lines = [f"# {name}", ""]
    if info["summary"]:
        lines += [info["summary"], ""]
    lines += [
        f"- **Source:** `{info['path']}`",
        f"- **Extends:** `{info['extends']}`",
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

    # Enums: own + inherited
    all_enums = [{**e, "from": name} for e in info["enums"]] + ih_enums
    if all_enums:
        lines += ["## Enums", ""]
        for e in all_enums:
            src = e.get("from", name)
            vals = ", ".join(f"`{name if src == name else src}.{v}`" for v in e["values"])
            # Prefer documenting as Type.EnumValue using defining type
            vals = ", ".join(f"`{src}.{v}`" for v in e["values"])
            note = "" if src == name else f" _(from [{src}]({src}.md))_"
            lines += [f"### `{src}.{e['name']}`{note}", "", vals, ""]

    # Properties table: own first, then inherited
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
            access = "readonly" if p["readonly"] else "read/write"
            lines.append(
                "| `{n}` | `{t}` | `{d}` | {a} | `{src}` | {doc} |".format(
                    n=p["name"],
                    t=md_escape(p["type"] or "?"),
                    d=md_escape(p["default"] or "—"),
                    a=access,
                    src=name,
                    doc=md_escape(p["doc"] or "—"),
                )
            )
        for p in ih_props:
            if any(o["name"] == p["name"] for o in own):
                continue
            access = "readonly" if p["readonly"] else "read/write"
            lines.append(
                "| `{n}` | `{t}` | `{d}` | {a} | [`{f}`]({f}.md) | {doc} |".format(
                    n=p["name"],
                    t=md_escape(p["type"] or "?"),
                    d=md_escape(p["default"] or "—"),
                    a=access,
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
        f"{name} {{",
    ]
    shown = 0
    for p in own + ih_props:
        if p["readonly"] or shown >= 5:
            continue
        if p["name"] in ("width", "height", "visible", "enabled", "opacity", "clip", "z", "x", "y", "anchors", "parent"):
            continue
        val = p["default"] if p["default"] and p["default"] not in ("{…}", "—") else "/* … */"
        lines.append(f"    {p['name']}: {val}")
        shown += 1
    if shown == 0:
        lines.append("    // see properties above")
    lines += ["}", "```", ""]
    return "\n".join(lines)


def build_inheritance(infos: dict[str, dict]) -> dict[str, list[str]]:
    out: dict[str, list[str]] = {}
    for name, info in infos.items():
        chain = []
        cur = info["extends"]
        # strip QtQuick. prefix variants
        seen = set()
        while cur and cur in infos and cur not in seen:
            seen.add(cur)
            chain.append(cur)
            cur = infos[cur]["extends"]
        out[name] = chain
    return out


def category_of(path: str) -> str:
    if "/foundation/" in path:
        return "Foundation"
    if "/primitives/" in path:
        return "Primitives"
    if "/window/" in path:
        return "Window"
    if "/layout/" in path:
        return "Layout"
    if "/components/" in path:
        n = Path(path).stem
        if "Chart" in n or n == "Md3CodeBlock":
            return "Charts"
        if any(x in n for x in ("Button", "Fab", "Chip", "Checkbox", "Radio", "Switch", "Slider", "Segmented", "Toggle", "Split")):
            return "Actions & selection"
        if any(x in n for x in ("TextField", "Search", "Form", "Date", "Time")):
            return "Input"
        if any(x in n for x in ("Nav", "Tab", "AppBar", "Drawer", "List", "Rail", "Document")):
            return "Navigation"
        if any(x in n for x in ("Card", "Dialog", "Sheet", "Snack", "Banner", "Tooltip", "Badge", "Divider", "Expansion", "Carousel", "Table", "Stepper", "Skeleton", "Menu", "Dropdown", "Option")):
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
            # skip nested platforms folder qml already covered
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
    }
    for old in OUT.glob("*.md"):
        if old.name in KEEP:
            continue
        old.unlink()

    for name, info in sorted(infos.items()):
        (OUT / f"{name}.md").write_text(
            render(info, infos, inheritance), encoding="utf-8"
        )

    # Index
    by_cat: dict[str, list[str]] = {}
    for name, info in infos.items():
        by_cat.setdefault(category_of(info["path"]), []).append(name)

    index = [
        "# Md3 API Reference",
        "",
        "每个控件一份完整 API：**属性（含继承）/ 枚举 / 信号 / 方法**。",
        "",
        "由 `scripts/gen_api_docs.py` 从 QML 源码生成；改完控件后请重跑该脚本。",
        "",
        "集成与 C++ 启动：[../integration.md](../integration.md) · 主题令牌：[../tokens.md](../tokens.md)",
        "",
        "## C++ / native",
        "",
        "- [Md3::run / initialize](Md3_cpp.md) — 一键初始化",
        "- [Md3Graphics](Md3Graphics.md) — RHI / alpha buffer",
        "- [Md3WindowHelper](Md3WindowHelper.md) — 原生窗口能力",
        "- [Md3ChartData](Md3ChartData.md) — 大数据序列降采样",
        "",
        f"**QML types:** {len(infos)}",
        "",
    ]
    for cat in sorted(by_cat.keys()):
        index += [f"## {cat}", ""]
        for n in sorted(by_cat[cat]):
            summary = infos[n]["summary"]
            extra = f" — {summary}" if summary else ""
            index.append(f"- [{n}]({n}.md){extra}")
        index.append("")

    (OUT / "README.md").write_text("\n".join(index) + "\n", encoding="utf-8")
    print(f"Wrote {len(infos)} API docs → {OUT}")


if __name__ == "__main__":
    main()
