cmake_minimum_required(VERSION 3.16)

project(QML_MD3 VERSION 0.1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick QuickControls2 QuickEffects)

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
    SOURCES
        src/Md3/window/md3windowhelper.h
        src/Md3/window/md3windowhelper.cpp
        src/Md3/window/md3win_p.h
        src/Md3/window/md3win_p.cpp
        src/Md3/window/md3winchrome.cpp
        src/Md3/window/md3winicons.cpp
        src/Md3/window/md3wintaskbar.cpp
        src/Md3/window/md3wintray.cpp
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
        src/Md3/window/Md3TabWindow.qml
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

target_link_libraries(Md3 PRIVATE Qt6::Quick Qt6::QuickControls2 Qt6::QuickEffects)
target_include_directories(Md3 PRIVATE src/Md3/window)

if (WIN32)
    target_link_libraries(Md3 PRIVATE dwmapi shell32 ole32 propsys advapi32)
endif()

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

target_include_directories(appQML_MD3 PRIVATE gallery)
target_link_libraries(appQML_MD3 PRIVATE Qt6::Quick Qt6::QuickControls2 Qt6::QuickEffects Md3)
if (WIN32)
    target_link_libraries(appQML_MD3 PRIVATE shell32 psapi)
endif()

include(GNUInstallDirs)
install(TARGETS appQML_MD3
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
