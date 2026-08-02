# Md3DeferredSection

Within-page progressive load: placeholder first, then create `sourceComponent`. Honors Md3Theme.progressiveContent (default on). Set forceImmediate to always load now. When `unloadWhenPageInactive`, disarms while ancestor `md3PageActive` is false (PageHost injects).

- **Source:** `src/Md3/components/Md3DeferredSection.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 11 | 0 | 3 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `sourceComponent` | `Component` | `null` | read/write | `Md3DeferredSection` | Source Component. |
| `delayMs` | `int` | `0` | read/write | `Md3DeferredSection` | Delay before arming when progressiveContent is on (ms). 0 = next event-loop tick. |
| `preferredHeight` | `real` | `120` | read/write | `Md3DeferredSection` | Height reserved while empty / loading (also used as Layout.preferredHeight hint). |
| `asynchronous` | `bool` | `false` | read/write | `Md3DeferredSection` | Prefer sync create to avoid "destroyed during incubation" on fast page switches. |
| `forceImmediate` | `bool` | `false` | read/write | `Md3DeferredSection` | Ignore Md3Theme.progressiveContent and load immediately. |
| `requireNearViewport` | `bool` | `true` | read/write | `Md3DeferredSection` | When progressive, also wait until near a parent Flickable viewport. |
| `viewportMargin` | `real` | `240` | read/write | `Md3DeferredSection` | Extra pixels around the viewport before arming. |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3DeferredSection` | Drop Loader while page is off-display (keep preferredHeight shell). |
| `progressive` | `bool` | `Md3Theme.progressiveContent && !forceImmediate` | readonly | `Md3DeferredSection` | Progressive. |
| `ready` | `bool` | `loader.status === Loader.Ready` | readonly | `Md3DeferredSection` | Ready. |
| `item` | `Item` | `loader.item` | readonly | `Md3DeferredSection` | Item. |

## Signals

_None._

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `arm()` | `—` | `Md3DeferredSection` | Arm. |
| `disarm()` | `—` | `Md3DeferredSection` | Destroy heavy Loader item; keep placeholder height. |
| `rearm()` | `—` | `Md3DeferredSection` | Re-arm after page return — delay already satisfied; viewport gate still applies. |

## Example

```qml
import Md3

Md3DeferredSection {
    sourceComponent: null
    delayMs: 0
    preferredHeight: 120
    asynchronous: false
    forceImmediate: false
    requireNearViewport: true
}
```
