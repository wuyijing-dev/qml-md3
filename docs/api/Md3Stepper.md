# Md3Stepper

- **Source:** `src/Md3/components/Md3Stepper.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `model` | `var` | `[]` | read/write | `Md3Stepper` | `[{ title, subtitle }]` |
| `currentStep` | `int` | `0` | read/write | `Md3Stepper` | — |
| `vertical` | `bool` | `false` | read/write | `Md3Stepper` | — |
| `showActions` | `bool` | `true` | read/write | `Md3Stepper` | Back / Next / Finish when pages exist |
| `backText` / `nextText` / `finishText` | `string` | localized | read/write | `Md3Stepper` | — |
| `pages` | `alias` | `stepStack.data` | default read/write | `Md3Stepper` | Step body pages synced to `currentStep` |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `stepChanged(int index)` | `Md3Stepper` | — |
| `finished()` | `Md3Stepper` | Fired when Finish is clicked on the last step |
| `backClicked()` / `nextClicked()` | `Md3Stepper` | — |

## Methods

| Method | Description |
|--------|-------------|
| `goNext()` / `goBack()` | Advance or retreat |

## Example

```qml
import Md3

Md3Stepper {
    model: [{ title: "Details" }, { title: "Confirm" }]
    onFinished: console.log("done")
    Item { /* step 0 */ }
    Item { /* step 1 */ }
}
```
