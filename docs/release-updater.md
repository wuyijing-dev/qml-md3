# Md3ReleaseUpdater 安全说明

组件从 GitHub Releases 拉取元数据、下载 ZIP 并解压。**默认不做签名校验或增量补丁**——生产环境必须由应用补强。

## 当前能力

- HTTPS 访问 `api.github.com`  
- 按 `assetNameContains` 选资源  
- 整包下载 + 解压到指定目录  
- 进度 / 错误字符串  

## 威胁与对策

| 风险 | 建议 |
|------|------|
| 供应链 / 篡改包 | 发布 **SHA-256**（Release body 或 `*.sha256`）；下载后校验再解压 |
| 中间人 | 仅 HTTPS；可钉扎证书（应用侧） |
| 权限 | 解压目录勿指向安装根；先解到临时目录再替换 |
| 自动执行 | 不要静默 `exec` 下载物；需用户确认 |
| 增量更新 | 本组件 **不提供** delta；需要时用独立差分工具或整包替换 |

## 推荐接入

```qml
Md3ReleaseUpdater {
    owner: "org"; repo: "app"; currentVersion: Qt.application.version
    onDownloadFinished: (path) => {
        if (!Backend.verifySha256(path, expectedHash)) {
            Md3Notify.snackbar(qsTr("校验失败"))
            clearDownloadedFile()
            return
        }
        extractTo(stagingDir)
    }
}
```

签名（Authenticode / codesign）在 **安装器或更新助手进程** 中完成，勿假设 QML 层已验证。
