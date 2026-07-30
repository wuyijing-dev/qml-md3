# Md3AppToolBar

Compact desktop tool strip for `Md3ApplicationWindow.toolBar`.

- **Source:** `src/Md3/components/Md3AppToolBar.qml`
- **Extends:** `Rectangle`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `barHeight` | real | `44` | Strip height |
| `contentSpacing` | real | `8` | `Md3HStack` spacing |
| `horizontalPadding` | real | `12` | Left/right padding |
| `showDivider` | bool | `true` | Bottom hairline |
| `content` | alias | — | Children (default property) |

## Example

```qml
Md3ApplicationWindow {
    toolBar: Md3AppToolBar {
        Md3Button {
            text: qsTr("Reload")
            variant: Md3Button.Text
            onClicked: reloadCurrentPage()
        }
        Md3TextField {
            width: 280
            label: qsTr("Jump")
        }
    }
}
```
