# Md3WindowCapabilities — display server (hand appendix)

Auto-selects platform bags on Linux / Android. See [native-platforms.md](../topics/native-platforms.md).

```qml
import Md3

console.log(Md3WindowCapabilities.displayServer) // wayland | x11 | android | …
console.log(Md3WindowCapabilities.isWayland, Md3WindowCapabilities.isX11)
console.log(Md3WindowCapabilities.platformId)    // bag id (wayland/x11/android/…)
```

Native APIs remain on `Md3WindowHelper` / `Md3ApplicationWindow.windowNative`.

## System wrappers

Also see [native-platforms.md](../topics/native-platforms.md) for `openUrl`, `revealInFolder`, `shareText`, `vibrate`, `setImmersiveSystemUi`, `setVisibleInTaskbar`, etc.
