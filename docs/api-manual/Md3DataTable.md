## 就地编辑

列定义 `editable: true`（文本列）。双击行或 **F2** 进入编辑；`cellEdited(sourceIndex, role, newValue, oldValue)`。

```qml
columns: [
    { title: "Notes", role: "notes", width: 160, editable: true }
]
```
