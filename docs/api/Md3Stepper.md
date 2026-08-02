# Md3Stepper

Step indicator + optional step body pages and Next/Back actions.

- **Source:** `src/Md3/components/Md3Stepper.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 12 | 4 | 2 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `model` | `var` | `[]` | read/write | `Md3Stepper` | [{ title, subtitle }] |
| `currentStep` | `int` | `0` | read/write | `Md3Stepper` | Current Step. |
| `vertical` | `bool` | `false` | read/write | `Md3Stepper` | Vertical. |
| `showActions` | `bool` | `true` | read/write | `Md3Stepper` | When true, show Back / Next (or Finish on last step). |
| `backText` | `string` | `qsTr("Back")` | read/write | `Md3Stepper` | Back Text. |
| `nextText` | `string` | `qsTr("Next")` | read/write | `Md3Stepper` | Next Text. |
| `finishText` | `string` | `qsTr("Finish")` | read/write | `Md3Stepper` | Finish Text. |
| `pages` | `alias` | `stepStack.data` | default read/write | `Md3Stepper` | Step body pages (synced with currentStep). Prefer over external StackLayout. |
| `hasPages` | `bool` | `stepStack.children.length > 0` | readonly | `Md3Stepper` | Has Pages. |
| `isFirst` | `bool` | `currentStep <= 0` | readonly | `Md3Stepper` | Is First. |
| `isLast` | `bool` | `currentStep >= Math.max(0, model.length - 1)` | readonly | `Md3Stepper` | Is Last. |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3Stepper` | Drop step-header Repeater while page is off-display (chrome height kept via preferredHeight). |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `stepChanged(int index)` | `Md3Stepper` | Emitted when step Changed. |
| `finished()` | `Md3Stepper` | Emitted when finished. |
| `backClicked()` | `Md3Stepper` | Emitted when back Clicked. |
| `nextClicked()` | `Md3Stepper` | Emitted when next Clicked. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `goNext()` | `—` | `Md3Stepper` | Go Next. |
| `goBack()` | `—` | `Md3Stepper` | Go Back. |

## Example

```qml
import Md3

Md3Stepper {
    model: []
    currentStep: 0
    vertical: false
    showActions: true
    backText: qsTr("Back")
    nextText: qsTr("Next")
}
```
