cmake_minimum_required(VERSION 3.16)

project(QML_MD3 VERSION 0.1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick QuickControls2 QuickEffects QuickShapesPrivate)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_library(Md3 STATIC)

set_source_files_properties(
    src/Md3/foundation/Md3Theme.qml
    src/Md3/foundation/Md3Motion.qml
    src/Md3/window/Md3WindowCapabilities.qml
    PROPERTIES QT_QML_SINGLETON_TYPE TRUE
)

# Windows parallel qmlcachegen often hits ERROR_ACCESS_DENIED while writing
# .rcc/qmlcache (Defender / concurrent IDE builds). Disable AOT cache on Win.
set(MD3_QML_NO_CACHEGEN)
if (WIN32)
    set(MD3_QML_NO_CACHEGEN NO_CACHEGEN)
endif()

qt_add_qml_module(Md3
    URI Md3
    VERSION 1.0
    OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/Md3
    ${MD3_QML_NO_CACHEGEN}
    DEPENDENCIES
        QtQuick
        QtQuick.Shapes
    SOURCES
        src/Md3/window/md3windowhelper.h
        src/Md3/window/md3windowhelper.cpp
        src/Md3/window/md3graphics.h
        src/Md3/window/md3graphics.cpp
        src/Md3/charts/md3chartdata.h
        src/Md3/charts/md3chartdata.cpp
    QML_FILES
        src/Md3/foundation/Md3Theme.qml
        src/Md3/foundation/Md3Motion.qml
        src/Md3/foundation/Md3ColorScheme.qml
        src/Md3/foundation/Md3DynamicScheme.qml
        src/Md3/foundation/Md3Typography.qml
        src/Md3/foundation/Md3Shape.qml
        src/Md3/foundation/Md3Elevation.qml
        src/Md3/foundation/Md3StateLayer.qml
        src/Md3/primitives/Md3Surface.qml
        src/Md3/primitives/Md3Ripple.qml
        src/Md3/primitives/Md3StateOverlay.qml
        src/Md3/primitives/Md3FocusRing.qml
        src/Md3/primitives/Md3Icon.qml
        src/Md3/primitives/Md3Shadow.qml
        src/Md3/primitives/Md3Control.qml
        src/Md3/window/Md3WindowCapabilities.qml
        src/Md3/window/platforms/Md3WindowPlatformWindows.qml
        src/Md3/window/platforms/Md3WindowPlatformMacOS.qml
        src/Md3/window/platforms/Md3WindowPlatformLinux.qml
        src/Md3/window/platforms/Md3WindowPlatformMobile.qml
        src/Md3/window/Md3CaptionButtons.qml
        src/Md3/window/Md3TitleBarButton.qml
        src/Md3/window/Md3TitleBar.qml
        src/Md3/window/Md3PageHost.qml
        src/Md3/window/Md3WindowBody.qml
        src/Md3/window/Md3ApplicationWindow.qml
        src/Md3/window/Md3DialogWindow.qml
        src/Md3/layout/Md3AnimatedFlow.qml
        src/Md3/components/Md3Button.qml
        src/Md3/components/Md3IconButton.qml
        src/Md3/components/Md3ToggleIconButton.qml
        src/Md3/components/Md3SplitButton.qml
        src/Md3/components/Md3ButtonGroup.qml
        src/Md3/components/Md3Fab.qml
        src/Md3/components/Md3FabMenu.qml
        src/Md3/components/Md3ExtendedFab.qml
        src/Md3/components/Md3SegmentedButton.qml
        src/Md3/components/Md3Checkbox.qml
        src/Md3/components/Md3Radio.qml
        src/Md3/components/Md3Switch.qml
        src/Md3/components/Md3Slider.qml
        src/Md3/components/Md3RangeSlider.qml
        src/Md3/components/Md3AssistChip.qml
        src/Md3/components/Md3FilterChip.qml
        src/Md3/components/Md3InputChip.qml
        src/Md3/components/Md3SuggestionChip.qml
        src/Md3/components/Md3ChipGroup.qml
        src/Md3/components/Md3TextField.qml
        src/Md3/components/Md3Card.qml
        src/Md3/components/Md3Divider.qml
        src/Md3/components/Md3ListTile.qml
        src/Md3/components/Md3Dialog.qml
        src/Md3/components/Md3FullscreenDialog.qml
        src/Md3/components/Md3BottomSheet.qml
        src/Md3/components/Md3Badge.qml
        src/Md3/components/Md3LinearProgressIndicator.qml
        src/Md3/components/Md3CircularProgressIndicator.qml
        src/Md3/components/Md3LoadingIndicator.qml
        src/Md3/components/Md3Snackbar.qml
        src/Md3/components/Md3TopAppBar.qml
        src/Md3/components/Md3BottomAppBar.qml
        src/Md3/components/Md3NavigationBar.qml
        src/Md3/components/Md3NavigationRail.qml
        src/Md3/components/Md3NavigationDrawer.qml
        src/Md3/components/Md3TabBar.qml
        src/Md3/components/Md3DocumentTabBar.qml
        src/Md3/components/Md3Scaffold.qml
        src/Md3/components/Md3Menu.qml
        src/Md3/components/Md3MenuItem.qml
        src/Md3/components/Md3MenuDivider.qml
        src/Md3/components/Md3MenuBar.qml
        src/Md3/components/Md3DropdownMenu.qml
        src/Md3/components/Md3Option.qml
        src/Md3/components/Md3SearchBar.qml
        src/Md3/components/Md3SearchView.qml
        src/Md3/components/Md3DatePicker.qml
        src/Md3/components/Md3TimePicker.qml
        src/Md3/components/Md3Tooltip.qml
        src/Md3/components/Md3ExpansionTile.qml
        src/Md3/components/Md3DataTable.qml
        src/Md3/components/Md3Stepper.qml
        src/Md3/components/Md3Banner.qml
        src/Md3/components/Md3Carousel.qml
        src/Md3/components/Md3Form.qml
        src/Md3/components/Md3LineChart.qml
        src/Md3/components/Md3Skeleton.qml
        src/Md3/components/Md3SkeletonPane.qml
    RESOURCES
        resources/fonts/Roboto-Regular.ttf
        resources/fonts/Roboto-Medium.ttf
        resources/fonts/Roboto-Bold.ttf
        resources/fonts/MaterialIcons-Regular.ttf
        resources/fonts/MaterialIconsOutlined-Regular.otf
)

target_link_libraries(Md3 PRIVATE Qt6::Quick Qt6::QuickControls2 Qt6::QuickEffects Qt6::QuickShapesPrivate)
target_include_directories(Md3 PRIVATE src/Md3/window src/Md3/charts)

# Exactly one platform native translation unit set — no cross-platform #else stubs.
set(MD3_PLATFORM_SOURCES)
if (WIN32)
    list(APPEND MD3_PLATFORM_SOURCES
        src/Md3/window/platforms/windows/md3win_p.h
        src/Md3/window/platforms/windows/md3win_p.cpp
        src/Md3/window/platforms/windows/md3win_host.cpp
        src/Md3/window/platforms/windows/md3winchrome.cpp
        src/Md3/window/platforms/windows/md3winicons.cpp
        src/Md3/window/platforms/windows/md3wintaskbar.cpp
        src/Md3/window/platforms/windows/md3wintray.cpp
    )
    target_include_directories(Md3 PRIVATE src/Md3/window/platforms/windows)
    target_link_libraries(Md3 PRIVATE dwmapi shell32 ole32 propsys advapi32)
elseif (APPLE)
    list(APPEND MD3_PLATFORM_SOURCES
        src/Md3/window/platforms/macos/md3macosnative.cpp
    )
elseif (UNIX)
    list(APPEND MD3_PLATFORM_SOURCES
        src/Md3/window/platforms/linux/md3linux_p.h
        src/Md3/window/platforms/linux/md3linux_dbus.cpp
        src/Md3/window/platforms/linux/md3linux_effects.cpp
        src/Md3/window/platforms/linux/md3linuxnative.cpp
        src/Md3/window/platforms/linux/md3linuxdock.cpp
        src/Md3/window/platforms/linux/md3linuxtray.cpp
    )
    target_include_directories(Md3 PRIVATE src/Md3/window/platforms/linux)
    find_package(Qt6 REQUIRED COMPONENTS DBus Widgets)
    target_link_libraries(Md3 PRIVATE Qt6::DBus Qt6::Widgets)

    # Real Wayland/X11 blur + KeepAbove when Plasma KF is present.
    find_package(KF6WindowSystem QUIET)
    if (KF6WindowSystem_FOUND)
        target_link_libraries(Md3 PRIVATE KF6::WindowSystem)
        target_compile_definitions(Md3 PRIVATE MD3_HAVE_KWINDOWSYSTEM=1)
        message(STATUS "Md3: KF6WindowSystem found — compositor blur/keep-above enabled")
    else()
        find_package(KF5WindowSystem QUIET)
        if (KF5WindowSystem_FOUND)
            target_link_libraries(Md3 PRIVATE KF5::WindowSystem)
            target_compile_definitions(Md3 PRIVATE MD3_HAVE_KWINDOWSYSTEM=1)
            message(STATUS "Md3: KF5WindowSystem found — compositor blur/keep-above enabled")
        else()
            message(STATUS "Md3: KF WindowSystem not found — soft backdrop is transparent only on Wayland")
        endif()
    endif()
else()
    list(APPEND MD3_PLATFORM_SOURCES
        src/Md3/window/platforms/mobile/md3mobilenative.cpp
    )
endif()
target_sources(Md3 PRIVATE ${MD3_PLATFORM_SOURCES})

qt_add_executable(appQML_MD3 src/main.cpp)

if (WIN32)
    target_sources(appQML_MD3 PRIVATE resources/app.rc)
    # Manifest is embedded via app.rc — disable the linker-generated one (avoids CVT1100).
    target_link_options(appQML_MD3 PRIVATE "/MANIFEST:NO")
endif()

# Bundle fonts on the executable so they are available before the Md3 QML
# module (static lib) registers its own qrc resources.
qt_add_resources(appQML_MD3 "md3_app_fonts"
    PREFIX "/md3/fonts"
    BASE resources/fonts
    FILES
        resources/fonts/Roboto-Regular.ttf
        resources/fonts/Roboto-Medium.ttf
        resources/fonts/Roboto-Bold.ttf
        resources/fonts/MaterialIcons-Regular.ttf
        resources/fonts/MaterialIconsOutlined-Regular.otf
)

qt_add_resources(appQML_MD3 "md3_app_icons"
    PREFIX "/md3/icons"
    BASE resources/icons
    FILES
        resources/icons/app-icon.png
        resources/icons/app-icon-16.png
        resources/icons/app-icon-32.png
        resources/icons/app-icon-48.png
        resources/icons/app-icon-256.png
)

qt_add_qml_module(appQML_MD3
    URI Gallery
    VERSION 1.0
    ${MD3_QML_NO_CACHEGEN}
    SOURCES
        gallery/performancemonitor.h
        gallery/performancemonitor.cpp
    QML_FILES
        gallery/Main.qml
        gallery/PerformancePanel.qml
        gallery/pages/TokensPage.qml
        gallery/pages/ButtonsPage.qml
        gallery/pages/FabPage.qml
        gallery/pages/SelectionPage.qml
        gallery/pages/TextFieldsPage.qml
        gallery/pages/ChipsPage.qml
        gallery/pages/ContainmentPage.qml
        gallery/pages/CommunicationPage.qml
        gallery/pages/NavigationPage.qml
        gallery/pages/MenusPage.qml
        gallery/pages/PickersPage.qml
        gallery/pages/SearchPage.qml
        gallery/pages/ExtrasPage.qml
        gallery/pages/MotionPage.qml
        gallery/pages/ThemePage.qml
        gallery/pages/ChartsPage.qml
        gallery/pages/WindowPage.qml
        gallery/pages/scenes/LoginScene.qml
        gallery/pages/scenes/SettingsScene.qml
        gallery/pages/scenes/ListDetailScene.qml
)

set_target_properties(appQML_MD3 PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_include_directories(appQML_MD3 PRIVATE gallery src/Md3/window)
target_link_libraries(appQML_MD3 PRIVATE Qt6::Quick Qt6::QuickControls2 Qt6::QuickEffects Md3)
if (WIN32)
    target_link_libraries(appQML_MD3 PRIVATE shell32 psapi)
elseif (UNIX AND NOT APPLE)
    target_link_libraries(appQML_MD3 PRIVATE Qt6::Widgets Qt6::DBus)
endif()

include(GNUInstallDirs)
install(TARGETS appQML_MD3
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
