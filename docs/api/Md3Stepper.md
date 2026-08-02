# Md3Stepper

Step indicator + optional step body pages and Next/Back actions.

- **Source:** `src/Md3/components/Md3Stepper.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `model` | `var` | `[]` | read/write | `Md3Stepper` | — |
| `currentStep` | `int` | `0` | read/write | `Md3Stepper` | — |
| `vertical` | `bool` | `false` | read/write | `Md3Stepper` | — |
| `showActions` | `bool` | `true` | read/write | `Md3Stepper` | When true, show Back / Next (or Finish on last step). |
| `backText` | `string` | `qsTr("Back")` | read/write | `Md3Stepper` | — |
| `nextText` | `string` | `qsTr("Next")` | read/write | `Md3Stepper` | — |
| `finishText` | `string` | `qsTr("Finish")` | read/write | `Md3Stepper` | — |
| `pages` | `alias` | `stepStack.data` | default read/write | `Md3Stepper` | Step body pages (synced with currentStep). Prefer over external StackLayout. |
| `hasPages` | `bool` | `stepStack.children.length > 0` | readonly | `Md3Stepper` | — |
| `isFirst` | `bool` | `currentStep <= 0` | readonly | `Md3Stepper` | — |
| `isLast` | `bool` | `currentStep >= Math.max(0, model.length - 1)` | readonly | `Md3Stepper` | — |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3Stepper` | Drop step-header Repeater while page is off-display (chrome height kept via preferredHeight). |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `stepChanged(int index)` | `Md3Stepper` | — |
| `finished()` | `Md3Stepper` | — |
| `backClicked()` | `Md3Stepper` | — |
| `nextClicked()` | `Md3Stepper` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `goNext()` | `Md3Stepper` | — |
| `goBack()` | `Md3Stepper` | — |

## Example

```qml
import Md3

Md3Stepper {
    model: []
    currentStep: 0
    vertical: false
    showActions: true
    backText: qsTr("Back")
}
```
