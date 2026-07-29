# Md3Slider

Material 3 capsule slider with optional field label.

- **Source:** `src/Md3/components/Md3Slider.qml`

## Properties

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `from` / `to` / `value` / `stepSize` | real | `0`/`1`/`0.5`/`0` | Range |
| `label` | string | `""` | Header label above track |
| `leadingIcon` | string | `""` | Icon left of label (volume-row pattern) |
| `showValue` | bool | `false` | Inline value next to label |
| `valueDecimals` | int | `2` | Digits when not integer steps |
| `showLabel` | bool | `false` | Floating bubble while dragging |
| `trackHeight` / `handleWidth` / `handleHeight` | real | expressive defaults | Chrome |
| `discrete` | bool | `stepSize > 0` | Tick marks |
| `showStopIndicator` | bool | `true` | End stop on continuous |

## Signals / methods

`moved(real value)`, `setValue(v)`, `nudge(dir)`

## Example

```qml
Md3Slider {
    leadingIcon: "volume_up"
    label: qsTr("Volume")
    showValue: true
    from: 0; to: 100; value: 42
}
```
