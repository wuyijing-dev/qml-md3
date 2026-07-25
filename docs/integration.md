# Integrating Md3

## Build dependency

Add the Md3 static QML module from this repo (or install artifacts) and link:

```cmake
add_subdirectory(path/to/QML_MD3) # or find_package if packaged
target_link_libraries(yourApp PRIVATE Md3 Qt6::Quick)
```

Import in QML:

```qml
import Md3

ApplicationWindow {
    color: Md3Theme.colorScheme.surface
    Md3Button { text: "OK"; onClicked: { } }
}
```

## Runtime import path

When not linking the module into the executable, set:

```
QML_IMPORT_PATH=<build-or-install>/Md3/..
```

so that `import Md3` resolves.

## Theme

```qml
Md3Theme.dark = true
Md3Theme.applySeed("#006A6A")
Md3Theme.textScale = 1.25
```

## Versioning

Semantic versioning. See [CHANGELOG.md](../CHANGELOG.md). Controls without a `stable` note in their `docs/md3` page are experimental.
