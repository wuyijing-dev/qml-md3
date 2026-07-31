# 文件与路径 UX

## Md3PathField

| 开关 | 失败文案属性 | 默认 |
|------|--------------|------|
| `validateExtension` + `allowedExtensions` | — | `Extension not allowed` |
| `validateExists` + `existsProbe` | `notFoundText` | Path does not exist |
| `validateWritable` + `writableProbe` | `permissionDeniedText` | No write permission… |
| `pathValidator` | 返回 `message` | Invalid path |

```qml
Md3PathField {
    validateExists: true
    validateWritable: true
    existsProbe: (p) => Backend.pathExists(p)
    writableProbe: (p) => Backend.pathWritable(p)
    permissionDeniedText: qsTr("需要写入权限，请选择其他目录")
    announceValidationErrors: true   // Md3Accessibility.announceError
    onValidationChanged: (ok, msg) => {
        if (!ok)
            Md3Notify.snackbar(msg)  // 可选：再给一条非模态反馈
    }
}
```

权限失败：**字段 error + 读屏 announce**；不要只 `console.warn`。

## Md3FileDropZone

- `acceptedExtensions`：不匹配时 `rejected(message)` + `lastRejectMessage`  
- `announceRejections`：默认读屏报错  
- 成功：`filesDropped(items)`  

与 PathField 同一原则：拒绝原因可见、可读屏。
