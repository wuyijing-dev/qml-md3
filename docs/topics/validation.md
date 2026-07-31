# 统一校验 API

表单与字段共享同一套错误语义，便于 `Md3Form`、读屏与 Gallery「模式」页一致。

## 字段约定

| 属性 | 含义 |
|------|------|
| `error: bool` | 是否处于错误态（红框 / 错误色） |
| `errorText: string` | 错误说明；非空时优先于 `supportingText` 展示 |
| `supportingText: string` | 正常辅助说明（无错误时） |
| `name: string` | `Md3Form` 收集 / 写回错误的键 |
| `Accessible.name` | 读屏名（可见 `label` 或 `accessibleName`） |
| `Accessible.role` | 通常 `EditableText` / `ComboBox` / `SpinBox` |

`Md3TextField.helper`：有错误时显示 `errorText`，否则 `supportingText`。

## Md3Form

```qml
Md3Form {
    id: form
    requiredFields: ["email"]
    Md3TextField { name: "email"; label: qsTr("Email") }
    Md3Button {
        text: qsTr("Save")
        enabled: form.canSubmit
        onClicked: form.submit()
    }
    onSubmitted: (values) => { /* … */ }
}
```

| API | 作用 |
|-----|------|
| `validate()` / `submit()` | 必填检查；失败写 `errorText` |
| `setError(name, msg)` | 业务校验（格式、冲突） |
| `clearErrors()` | 清空 |
| `canSubmit` / `hasErrors` | 提交门控 |
| `liveGate` | 输入时刷新门控 |

自定义规则：在 `submit` 前 `setError`；或字段 `onEditingFinished` 内校验后 `form.setError`。

## 无障碍

- 错误文案进 `errorText`，不要只改颜色。
- 提交失败：`Md3Accessibility.announceError(...)`。
- 成功：`announceSuccess`。

## 相关

- 路径：`Md3PathField`（`notFoundText` / `permissionDeniedText`）
- 日期：`Md3DateField`（`Qt.locale()` + `dateFormat`）见 [datetime.md](datetime.md)
- 设计模式：[design-guidelines.md](../guides/design-guidelines.md)
