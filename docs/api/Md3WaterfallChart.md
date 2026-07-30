# Md3WaterfallChart

Waterfall / bridge chart for stepwise contributions. Source: `src/Md3/components/Md3WaterfallChart.qml`.

```qml
Md3WaterfallChart {
    values: [
        { label: "Start", value: 100 },
        { label: "+Sales", value: 40 },
        { label: "-Cost", value: -25 },
        { label: "End", value: 115, isTotal: true }
    ]
}
```
