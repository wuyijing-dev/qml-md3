# Md3LiquidGlassFusionPlayground

Two draggable glass bodies rendered in a **single fused SDF pass** (real metaball-style merge).

- **Source:** `src/Md3/components/Md3LiquidGlassFusionPlayground.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `sourceItem` | `Item` | `null` | Backdrop to sample; uses built-in gradient demo when null. |
| `fusionStrength` | `real` | `0.14` | Smooth-min radius between body A and body B (higher = softer bridge). |

## Example

```qml
import Md3

Md3LiquidGlassFusionPlayground {
    width: 720
    height: 420
    fusionStrength: 0.14
}
```

## Gallery

Open **液态玻璃** in the Md3 Gallery. Drag **Glass A** and **Glass B** together to see the liquid bridge and edge spectral highlights.
