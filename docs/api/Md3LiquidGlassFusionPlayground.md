# Md3LiquidGlassFusionPlayground

Two draggable glass bodies rendered in a **single fused SDF pass** (real metaball-style merge).

- **Source:** `src/Md3/components/Md3LiquidGlassFusionPlayground.qml`
- **Extends:** `Item`
- **Stability:** **Experimental** (API and behavior may change)

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

## Notes

Liquid Glass 相关演示已从 Gallery 默认导航移除；该组件用于实验/验证场景，不保证长期 API 稳定性。
