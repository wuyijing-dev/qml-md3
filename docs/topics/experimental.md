# Experimental Components

以下组件为 **Experimental**：默认不在 Gallery 导航中作为稳定能力展示，API/行为可能在后续版本调整。

## Liquid Glass

- `Md3LiquidGlass`：区域采样液态玻璃效果（非全局毛玻璃/全场景模糊）。
- `Md3LiquidGlassFusionPlayground`：双体 SDF 融合演示，用于验证液态融合视觉。

## 使用建议

- 仅建议在受控页面按需启用，不建议大面积、长列表同时实例化。
- 进入产品前需补齐平台兼容、性能压测与降级方案（禁用或回退为普通卡片）。
- 升级 Md3 版本时，需复测参数与视觉输出（Experimental 不承诺二进制/行为兼容）。
