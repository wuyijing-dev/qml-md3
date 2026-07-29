# Md3MultiRingGauge

- **Source:** `src/Md3/components/Md3MultiRingGauge.qml`

Concentric rings — each ring is an independent progress value.

## Properties

| Name | Type | Default |
|------|------|---------|
| `rings` | `var` | `[]` — `[{ value, from?, to?, color?, label? }]` |
| `strokeWidth` / `ringGap` | `real` | `10` / `6` |
| `centerValue` / `centerLabel` | `string` | |
| `size` | `real` | `160` |

```qml
Md3MultiRingGauge {
    size: 140
    centerValue: "81%"
    centerLabel: qsTr("Health")
    rings: [
        { value: 81, color: Md3Theme.colorScheme.primary },
        { value: 64, color: Md3Theme.colorScheme.tertiary },
        { value: 42, color: Md3Theme.colorScheme.secondary }
    ]
}
```
