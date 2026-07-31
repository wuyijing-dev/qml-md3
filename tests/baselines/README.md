# Visual baselines (manual first)

Store PNG baselines:

```text
tests/baselines/<component>/<variant>_<light|dark>.png
```

## Starter set (3–5 controls)

| Component | Variants |
|-----------|----------|
| `Md3Button` | filled, outlined × light/dark |
| `Md3TextField` | idle, focused × light |
| `Md3Dialog` | open × light |
| `Md3ListTile` | 1-line, selected × light |
| `Md3Switch` | on/off × light |

## Process (manual)

1. Run Gallery on a fixed window size (e.g. 1280×800) and theme.
2. Capture the control region; save under the path above.
3. On visual PRs, compare side-by-side before merging.
4. Automate later (screenshot + diff in CI) once baselines are stable.

Do not block P0 on automation — checklist existence is enough for now.
