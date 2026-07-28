# Md3FlowLayout

Wrapping flow — thin wrapper over `Md3AnimatedFlow` with `animate: false`. Same API as [Md3AnimatedFlow](Md3AnimatedFlow.md).

- **Source:** `src/Md3/layout/Md3FlowLayout.qml`

## Example

```qml
Md3FlowLayout {
    spacing: 8
    rowSpacing: 8
    Repeater {
        model: 8
        delegate: Md3SuggestionChip { text: "Chip " + (index + 1) }
    }
}
```
