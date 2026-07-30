# DataTable：列宽、导出与大数据

## 列宽持久化

```qml
Md3DataTable {
    id: table
    columnWidthsPersistKey: "app/table/mainColumns"  // Md3AppSettings
    // 启动时 loadColumnWidths()；拖拽列宽后自动 save
}
```

- `columnWidths`：当前像素宽数组  
- `setColumnWidth(i, w)`：写入并（若有 key）延迟保存  
- `loadColumnWidths()` / `saveColumnWidths()`：手动调用  

## 导出钩子

```qml
Md3DataTable {
    onExportRequested: (format, payload) => {
        // format: "csv" | "json" — 自行写盘 / 剪贴板
        Md3Notify.snackbar(qsTr("Exported %1").arg(format))
    }
}
const csv = table.exportCsv()      // 含表头；过滤后的可见行
const json = table.exportJson()
```

不直接写文件系统；由应用接 `exportRequested` 或使用返回值。

## 大数据 / 虚拟化

| 手段 | 说明 |
|------|------|
| `serverSidePagination: true` | 只喂当前页 `rows`；`pageRequested` 拉数据 |
| 客户端分页 | 默认过滤后分页；适合中等行数 |
| `Md3VirtualList` | 非表格的超长列表用虚拟列表 |
| 避免 | 每行 `layer.enabled` / 重阴影（见 [performance.md](performance.md)） |

宽表：`frozenColumnCount` + `density: Md3Theme.density`（与主题紧凑档对齐）。
