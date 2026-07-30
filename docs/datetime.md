# 日期与时间

## 格式与本地化

```qml
Md3DateField {
    dateFormat: "yyyy-MM-dd"           // 或 "dd.MM.yyyy"
    // 解析：Date.fromLocaleString(Qt.locale(), text, dateFormat)
}
Md3TimeField {
    // 与 Md3TimePicker 共用 12h/24h 约定
}
```

- 展示：`Qt.formatDate` / `Qt.formatTime`  
- 输入：失焦时按 `Qt.locale()` + `dateFormat` 解析；失败则回退到上次合法值并保持 `error`/`errorText`（字段侧）  

## 键盘校验建议

1. 允许自由输入，在 `onEditingFinished` / Form `submit` 时解析。  
2. 非法：`errorText: qsTr("Invalid date")` + `Md3Accessibility.announceError`。  
3. `min`/`max`（若组件暴露）在解析成功后再夹紧。  
4. 范围选择用 `Md3DateRangePicker`，不要两个独立字段无交叉校验。

## 与 Form

```qml
Md3Form {
    requiredFields: ["due"]
    Md3DateField { name: "due"; label: qsTr("Due") }
}
```

`name` 走统一校验约定（[validation.md](validation.md)）。
