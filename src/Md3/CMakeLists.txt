# Md3 — Material Design 3 QML module (library only; no Gallery).
# Consumers: add_subdirectory(<repo>) then target_link_libraries(app PRIVATE Md3)
# Or: cmake -DMD3_BUILD_GALLERY=OFF and install / find_package(Md3)

if (NOT DEFINED MD3_QT_MAJOR)
    include(${CMAKE_CURRENT_SOURCE_DIR}/../../cmake/Md3QtCompat.cmake)
endif()
if (NOT DEFINED MD3_IS_WASM)
    include(${CMAKE_CURRENT_SOURCE_DIR}/../../cmake/Md3Platform.cmake)
endif()

if (MD3_QT_MAJOR EQUAL 6)
    if (NOT TARGET Qt6::Quick)
        md3_find_qt(Core Gui Qml Quick QuickControls2 Network)
        md3_resolve_optional_qt_modules()
        md3_setup_qt_qml_policies()
    elseif (NOT DEFINED MD3_QT_HAS_EFFECTS)
        md3_resolve_optional_qt_modules()
        md3_setup_qt_qml_policies()
    else()
        md3_setup_qt_qml_policies()
    endif()
else()
    if (NOT TARGET Qt5::Quick)
        md3_find_qt(Quick QuickControls2 Network)
    endif()
endif()

include(GNUInstallDirs)

# Repo root (resources/fonts lives beside src/)
get_filename_component(MD3_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/../.." ABSOLUTE)
if (NOT DEFINED MD3_VERSION)
    if (DEFINED PROJECT_VERSION AND NOT PROJECT_VERSION STREQUAL "")
        set(MD3_VERSION "${PROJECT_VERSION}")
    else()
        set(MD3_VERSION "1.0.0")
    endif()
endif()

# Fonts live at repo resources/ — mirror under this module as relative RESOURCES.
# Default: Regular UI face only. Medium/Bold are optional (MD3_BUNDLE_EXTRA_UI_FONTS).
# Avoid QT_RESOURCE_ALIAS: Qt Creator MSVC finalize resolves the alias under
# CMAKE_CURRENT_SOURCE_DIR and fails (e.g. gallery/Roboto-Regular.ttf).
option(MD3_BUNDLE_EXTRA_UI_FONTS
    "Bundle HarmonyOS Sans SC Medium/Bold (apps can also drop faces into fonts/)" OFF)
set(_md3_font_dir "${CMAKE_CURRENT_SOURCE_DIR}/resources/fonts")
file(MAKE_DIRECTORY "${_md3_font_dir}")
set(MD3_FONT_NAMES
    HarmonyOS_SansSC_Regular.ttf
    MaterialIcons-Regular.ttf
    MaterialIconsOutlined-Regular.otf
)
if (MD3_BUNDLE_EXTRA_UI_FONTS)
    list(APPEND MD3_FONT_NAMES
        HarmonyOS_SansSC_Medium.ttf
        HarmonyOS_SansSC_Bold.ttf
    )
endif()
set(MD3_FONT_FILES "")
foreach (_md3_font_name IN LISTS MD3_FONT_NAMES)
    set(_src "${MD3_ROOT}/resources/fonts/${_md3_font_name}")
    set(_dst "${_md3_font_dir}/${_md3_font_name}")
    if (NOT EXISTS "${_src}")
        message(FATAL_ERROR "Missing font: ${_src}")
    endif()
    configure_file("${_src}" "${_dst}" COPYONLY)
    list(APPEND MD3_FONT_FILES "resources/fonts/${_md3_font_name}")
endforeach()

# App icons (title bar / taskbar / tray). Canonical: repo resources/icons/.
# Staged under src/Md3/icons/ → qrc:/md3/icons/app-icon.png (same path Gallery used).
set(_md3_icon_dir "${CMAKE_CURRENT_SOURCE_DIR}/icons")
file(MAKE_DIRECTORY "${_md3_icon_dir}")
set(MD3_ICON_NAMES
    app-icon.png
    app-icon-16.png
    app-icon-32.png
    app-icon-48.png
    app-icon-256.png
)
set(MD3_ICON_FILES "")
foreach (_md3_icon_name IN LISTS MD3_ICON_NAMES)
    set(_src "${MD3_ROOT}/resources/icons/${_md3_icon_name}")
    set(_dst "${_md3_icon_dir}/${_md3_icon_name}")
    if (NOT EXISTS "${_src}")
        message(FATAL_ERROR "Missing icon: ${_src}")
    endif()
    configure_file("${_src}" "${_dst}" COPYONLY)
    list(APPEND MD3_ICON_FILES "icons/${_md3_icon_name}")
endforeach()

option(MD3_BUILD_SHARED "Build Md3 as a shared library" OFF)
if (MD3_QT_MAJOR EQUAL 6)
    if (MD3_BUILD_SHARED)
        qt_add_library(Md3 SHARED)
        target_compile_definitions(Md3 PRIVATE MD3_BUILD_SHARED)
        target_compile_definitions(Md3 PUBLIC MD3_SHARED)
    else()
        qt_add_library(Md3 STATIC)
    endif()
else()
    if (MD3_BUILD_SHARED)
        add_library(Md3 SHARED)
        target_compile_definitions(Md3 PRIVATE MD3_BUILD_SHARED)
        target_compile_definitions(Md3 PUBLIC MD3_SHARED)
    else()
        add_library(Md3 STATIC)
    endif()
endif()

# Dedicated font qrc (not only via qt_add_qml_module). Static MSVC links can drop
# qml-module resource inits; Q_INIT_RESOURCE(md3_fonts) in loadFonts() is reliable.
# Paths: :/md3/fonts/resources/fonts/HarmonyOS_SansSC_Regular.ttf …
# (Avoid BASE=: Qt Creator MSVC finalize resolves basenames under src/Md3/.)
if (MD3_QT_MAJOR EQUAL 6)
    qt_add_resources(Md3 "md3_fonts"
        PREFIX "/md3/fonts"
        BIG_RESOURCES
        FILES
            ${MD3_FONT_FILES}
    )
else()
    message(STATUS "Md3 Qt5.15 stage1: skipping embedded font qrc")
endif()

# Paths: :/md3/icons/app-icon.png …
if (MD3_QT_MAJOR EQUAL 6)
    qt_add_resources(Md3 "md3_icons"
        PREFIX "/md3"
        FILES
            ${MD3_ICON_FILES}
    )
else()
    message(STATUS "Md3 Qt5.15 stage1: skipping embedded icon qrc")
endif()

# UI translations (.qm). Regenerate via lrelease — see docs/i18n.md.
set(MD3_I18N_QM
    i18n/md3_en.qm
    i18n/md3_zh_CN.qm
)
foreach (_qm IN LISTS MD3_I18N_QM)
    if (NOT EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${_qm}")
        # Touch empty placeholder so configure succeeds before first lrelease.
        file(WRITE "${CMAKE_CURRENT_SOURCE_DIR}/${_qm}" "")
    endif()
endforeach()
if (MD3_QT_MAJOR EQUAL 6)
    qt_add_resources(Md3 "md3_i18n"
        PREFIX "/md3"
        FILES
            ${MD3_I18N_QM}
    )
else()
    message(STATUS "Md3 Qt5.15 stage1: skipping embedded i18n qrc")
endif()
if (NOT TARGET Md3::Md3)
    add_library(Md3::Md3 ALIAS Md3)
endif()

if (MD3_QT_MAJOR EQUAL 5)
    target_sources(Md3 PRIVATE
        md3.h
        md3.cpp
        md3_capi.h
        md3_capi.cpp
        window/md3graphics.h
        window/md3graphics_qt5_stub.cpp
    )
    target_link_libraries(Md3
        PUBLIC Qt5::Quick
        PRIVATE Qt5::QuickControls2 Qt5::Network
    )
    message(STATUS "Md3 Qt5.15 stage1: built bootstrap-only library (no qt_add_qml_module/Gallery)")
    return()
endif()

set_source_files_properties(
    foundation/Md3Theme.qml
    foundation/Md3Motion.qml
    foundation/Md3Accessibility.qml
    foundation/Md3IconFonts.qml
    foundation/Md3AppIcons.qml
    foundation/Md3Notify.qml
    foundation/Md3TreeVisibility.qml
    foundation/Md3OverlayHost.qml
    window/Md3WindowCapabilities.qml
    PROPERTIES QT_QML_SINGLETON_TYPE TRUE
)

set(MD3_QML_NO_CACHEGEN)
# qmlcachegen speeds cold open (bytecode in binary) without raising live page RSS.
# Packaging must ship qmlcache init objects with static libs — see docs/packaging.md.
# Rapid QML iterate: -DMD3_QML_CACHEGEN=OFF
if (NOT MD3_QML_CACHEGEN)
    set(MD3_QML_NO_CACHEGEN NO_CACHEGEN)
endif()
message(STATUS "Md3 qmlcachegen: ${MD3_QML_CACHEGEN}")
md3_setup_qt_qml_policies()
qt_add_qml_module(Md3
    URI Md3
    VERSION 1.0
    OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/Md3
    OUTPUT_TARGETS md3_qml_output_targets
    ${MD3_QML_NO_CACHEGEN}
    DEPENDENCIES
        QtQuick
        QtQuick.Shapes
    SOURCES
        md3.h
        md3.cpp
        md3_capi.h
        md3_capi.cpp
        window/md3windowhelper.h
        window/md3windowhelper.cpp
        window/md3graphics.h
        window/md3graphics.cpp
        window/md3releaseupdaternative.h
        window/md3releaseupdaternative.cpp
        charts/md3chartdata.h
        charts/md3chartdata.cpp
        diagnostics/md3performancemonitor.h
        diagnostics/md3performancemonitor.cpp
        diagnostics/md3inspector.h
        diagnostics/md3inspector.cpp
        diagnostics/md3appsettings.h
        diagnostics/md3appsettings.cpp
        diagnostics/md3i18n.h
        diagnostics/md3i18n.cpp
        diagnostics/md3hotreload.h
        diagnostics/md3hotreload.cpp
    QML_FILES
        foundation/Md3Theme.qml
        foundation/Md3Motion.qml
        foundation/Md3Accessibility.qml
        foundation/Md3IconFonts.qml
        foundation/Md3AppIcons.qml
        foundation/Md3Notify.qml
        foundation/Md3TreeVisibility.qml
        foundation/Md3OverlayHost.qml
        foundation/Md3ColorScheme.qml
        foundation/Md3DynamicScheme.qml
        foundation/Md3Typography.qml
        foundation/Md3Shape.qml
        foundation/Md3Elevation.qml
        foundation/Md3StateLayer.qml
        primitives/Md3Surface.qml
        primitives/Md3Ripple.qml
        primitives/Md3StateOverlay.qml
        primitives/Md3FocusRing.qml
        primitives/Md3Icon.qml
        primitives/Md3Shadow.qml
        primitives/Md3Control.qml
        primitives/Md3AbstractButton.qml
        primitives/Md3SelectionControl.qml
        window/Md3WindowCapabilities.qml
        window/platforms/Md3WindowPlatformWindows.qml
        window/platforms/Md3WindowPlatformMacOS.qml
        window/platforms/Md3WindowPlatformLinux.qml
        window/platforms/Md3WindowPlatformMobile.qml
        window/Md3CaptionButtons.qml
        window/Md3TitleBarButton.qml
        window/Md3TitleBar.qml
        window/Md3Page.qml
        window/Md3PageHost.qml
        window/Md3WindowBody.qml
        window/Md3ApplicationWindow.qml
        window/Md3TabWindow.qml
        window/Md3DialogWindow.qml
        layout/Md3AnimatedFlow.qml
        layout/Md3VStack.qml
        layout/Md3HStack.qml
        layout/Md3FlowLayout.qml
        layout/Md3GridLayout.qml
        layout/Md3Spacer.qml
        layout/Md3PageSection.qml
        components/Md3Button.qml
        components/Md3IconButton.qml
        components/Md3ToggleButton.qml
        components/Md3ToggleIconButton.qml
        components/Md3SplitButton.qml
        components/Md3DropDownButton.qml
        components/Md3Hyperlink.qml
        components/Md3AppBarButton.qml
        components/Md3AppBarToggleButton.qml
        components/Md3CommandBar.qml
        components/Md3ButtonGroup.qml
        components/Md3Fab.qml
        components/Md3FabMenu.qml
        components/Md3ExtendedFab.qml
        components/Md3SegmentedButton.qml
        components/Md3Checkbox.qml
        components/Md3Radio.qml
        components/Md3RadioGroup.qml
        components/Md3Switch.qml
        components/Md3Slider.qml
        components/Md3RangeSlider.qml
        components/Md3AssistChip.qml
        components/Md3FilterChip.qml
        components/Md3InputChip.qml
        components/Md3SuggestionChip.qml
        components/Md3ChipGroup.qml
        components/Md3TagField.qml
        components/Md3Text.qml
        components/Md3TextField.qml
        components/Md3PasswordField.qml
        components/Md3NumberField.qml
        components/Md3Select.qml
        components/Md3Card.qml
        components/Md3AdaptiveContainer.qml
        components/Md3ContainerBody.qml
        components/Md3LiquidGlass.qml
        components/Md3LiquidGlassFusionPlayground.qml
        components/Md3Divider.qml
        components/Md3ListTile.qml
        components/Md3Avatar.qml
        components/Md3AvatarGroup.qml
        components/Md3EmptyState.qml
        components/Md3ColorPicker.qml
        components/Md3Dialog.qml
        components/Md3FullscreenDialog.qml
        components/Md3BottomSheet.qml
        components/Md3SideSheet.qml
        components/Md3SplitView.qml
        components/Md3Breadcrumb.qml
        components/Md3CommandPalette.qml
        components/Md3SnackbarHost.qml
        components/Md3Badge.qml
        components/Md3Badged.qml
        components/Md3LinearProgressIndicator.qml
        components/Md3CircularProgressIndicator.qml
        components/Md3LoadingIndicator.qml
        components/Md3MorphLoadingIndicator.qml
        components/Md3Snackbar.qml
        components/Md3TopAppBar.qml
        components/Md3BottomAppBar.qml
        components/Md3AppToolBar.qml
        components/Md3NavigationBar.qml
        components/Md3NavigationRail.qml
        components/Md3NavigationDrawer.qml
        components/Md3NavigationView.qml
        components/Md3TabBar.qml
        components/Md3DocumentTabBar.qml
        components/Md3Scaffold.qml
        components/Md3Menu.qml
        components/Md3MenuItem.qml
        components/Md3MenuDivider.qml
        components/Md3MenuBar.qml
        components/Md3ContextMenuArea.qml
        components/Md3TrayHost.qml
        components/Md3DropdownMenu.qml
        components/Md3Flyout.qml
        components/Md3Option.qml
        components/Md3SearchBar.qml
        components/Md3SearchView.qml
        components/Md3DatePicker.qml
        components/Md3DateRangePicker.qml
        components/Md3DateField.qml
        components/Md3TimePicker.qml
        components/Md3TimeField.qml
        components/Md3Tooltip.qml
        components/Md3ExpansionTile.qml
        components/Md3DataTable.qml
        components/Md3StatusBar.qml
        components/Md3TreeView.qml
        components/Md3PathField.qml
        components/Md3KeySequenceField.qml
        components/Md3FileDropZone.qml
        components/Md3ReleaseUpdater.qml
        components/Md3VirtualList.qml
        components/Md3ListView.qml
        components/Md3GridView.qml
        components/Md3ItemsView.qml
        components/Md3PipsPager.qml
        components/Md3SwipeReveal.qml
        components/Md3PullToRefresh.qml
        components/Md3Pagination.qml
        components/Md3Stepper.qml
        components/Md3Banner.qml
        components/Md3InfoBar.qml
        components/Md3Toast.qml
        components/Md3ToastHost.qml
        components/Md3ScrollBar.qml
        components/Md3ScrollView.qml
        components/Md3Carousel.qml
        components/Md3Form.qml
        components/Md3Chart.qml
        components/Md3ChartInteraction.qml
        components/Md3LineChart.qml
        components/Md3BarChart.qml
        components/Md3ScatterChart.qml
        components/Md3PieChart.qml
        components/Md3HeatmapChart.qml
        components/Md3Gauge.qml
        components/Md3RingGauge.qml
        components/Md3NeedleGauge.qml
        components/Md3SegmentGauge.qml
        components/Md3MultiRingGauge.qml
        components/Md3DotsGauge.qml
        components/Md3HalfGauge.qml
        components/Md3WaveGauge.qml
        components/Md3TickRingGauge.qml
        components/Md3ArcBandGauge.qml
        components/Md3KnobGauge.qml
        components/Md3CompassGauge.qml
        components/Md3RadarChart.qml
        components/Md3FunnelChart.qml
        components/Md3RadialBarChart.qml
        components/Md3AreaChart.qml
        components/Md3WaterfallChart.qml
        components/Md3BulletChart.qml
        components/Md3Sparkline.qml
        components/Md3CodeBlock.qml
        components/Md3Skeleton.qml
        components/Md3SkeletonPane.qml
        components/Md3DeferredSection.qml
        components/Md3Tour.qml
        diagnostics/Md3ElementPicker.qml
        diagnostics/Md3PerformancePanel.qml
    RESOURCES
        ${MD3_FONT_FILES}
        ${MD3_ICON_FILES}
)

target_link_libraries(Md3
    PUBLIC Qt6::Quick
    PRIVATE Qt6::QuickControls2 Qt6::Network
)
if (MD3_QT_EFFECTS_TARGET)
    target_link_libraries(Md3 PRIVATE ${MD3_QT_EFFECTS_TARGET})
endif()
if (MD3_QT_SHAPES_TARGET)
    target_link_libraries(Md3 PRIVATE ${MD3_QT_SHAPES_TARGET})
endif()
if (MD3_QT_DIALOGS2_TARGET)
    target_link_libraries(Md3 PRIVATE ${MD3_QT_DIALOGS2_TARGET})
endif()

# Prebuilt Liquid Glass shaders (qsb). Avoids requiring fxc.exe / ShaderTools at build time.
qt_add_resources(Md3 "md3_liquid_glass_shaders"
    PREFIX "/qt/qml/Md3"
    FILES
        shaders/md3liquidglass.vert.qsb
        shaders/md3liquidglass.frag.qsb
        shaders/md3liquidglass_mask.vert.qsb
        shaders/md3liquidglass_mask.frag.qsb
        shaders/md3squircle_mask.vert.qsb
        shaders/md3squircle_mask.frag.qsb
)

target_include_directories(Md3
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/window>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/charts>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/diagnostics>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/Md3>
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/window
        ${CMAKE_CURRENT_SOURCE_DIR}/charts
        ${CMAKE_CURRENT_SOURCE_DIR}/diagnostics
)

set(MD3_PLATFORM_SOURCES)
# Emscripten reports as UNIX — detect WASM first and use mobile stubs (no DBus/Widgets).
if (MD3_IS_WASM)
    list(APPEND MD3_PLATFORM_SOURCES
        window/platforms/mobile/md3mobilenative.cpp
    )
    target_compile_definitions(Md3 PUBLIC MD3_PLATFORM_WASM=1)
elseif (WIN32)
    list(APPEND MD3_PLATFORM_SOURCES
        window/platforms/windows/md3win_p.h
        window/platforms/windows/md3win_p.cpp
        window/platforms/windows/md3win_host.cpp
        window/platforms/windows/md3winchrome.cpp
        window/platforms/windows/md3winicons.cpp
        window/platforms/windows/md3wintaskbar.cpp
        window/platforms/windows/md3wintray.cpp
    )
    target_include_directories(Md3 PRIVATE window/platforms/windows)
    target_link_libraries(Md3 PRIVATE dwmapi shell32 shlwapi ole32 propsys advapi32 psapi pdh)
elseif (APPLE)
    list(APPEND MD3_PLATFORM_SOURCES
        window/platforms/macos/md3macosnative.cpp
    )
elseif (UNIX)
    list(APPEND MD3_PLATFORM_SOURCES
        window/platforms/linux/md3linux_p.h
        window/platforms/linux/md3linux_dbus.cpp
        window/platforms/linux/md3linux_effects.cpp
        window/platforms/linux/md3linuxnative.cpp
        window/platforms/linux/md3linuxdock.cpp
        window/platforms/linux/md3linuxtray.cpp
    )
    target_include_directories(Md3 PRIVATE window/platforms/linux)
    find_package(Qt6 REQUIRED COMPONENTS DBus Widgets)
    target_link_libraries(Md3 PRIVATE Qt6::DBus Qt6::Widgets)

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
        window/platforms/mobile/md3mobilenative.cpp
    )
endif()
target_sources(Md3 PRIVATE ${MD3_PLATFORM_SOURCES})

install(FILES
    md3.h
    md3_capi.h
    window/md3windowhelper.h
    window/md3graphics.h
    charts/md3chartdata.h
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/Md3
)

set(_md3_install_targets Md3)
if (TARGET Md3plugin)
    list(APPEND _md3_install_targets Md3plugin)
endif()
if (md3_qml_output_targets)
    list(APPEND _md3_install_targets ${md3_qml_output_targets})
endif()

# Install binaries/headers for local prefix use. Prefer add_subdirectory for apps.
install(TARGETS ${_md3_install_targets}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    OBJECTS DESTINATION ${CMAKE_INSTALL_LIBDIR}/objects/Md3
)

install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/Md3
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/qml
    OPTIONAL
)

# Static-plugin / rcc init stubs — required when linking prebuilt static Md3
install(CODE "
    set(_md3_bin \"${CMAKE_CURRENT_BINARY_DIR}\")
    set(_stub_dest \"\${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}/Md3/stubs\")
    file(MAKE_DIRECTORY \"\${_stub_dest}\")
    set(_stub_files \"\")
    if (EXISTS \"\${_md3_bin}/Md3plugin_init.cpp\")
        list(APPEND _stub_files \"\${_md3_bin}/Md3plugin_init.cpp\")
    endif()
    file(GLOB _rcc_inits \"\${_md3_bin}/.qt/rcc/*_init.cpp\")
    list(APPEND _stub_files \${_rcc_inits})
    foreach (_s IN LISTS _stub_files)
        if (EXISTS \"\${_s}\")
            file(INSTALL DESTINATION \"\${_stub_dest}\" TYPE FILE FILES \"\${_s}\")
        endif()
    endforeach()
")

# Build-tree helper package (add_subdirectory remains a valid integration path)
include(CMakePackageConfigHelpers)

# Consumers of a static package must also link KF WindowSystem when we built with it
set(MD3_PACKAGE_NEEDS_KWINDOWSYSTEM 0)
set(MD3_PACKAGE_IS_WASM 0)
if (MD3_IS_WASM)
    set(MD3_PACKAGE_IS_WASM 1)
elseif (UNIX AND NOT APPLE)
    if (KF6WindowSystem_FOUND OR KF5WindowSystem_FOUND)
        set(MD3_PACKAGE_NEEDS_KWINDOWSYSTEM 1)
    endif()
endif()

# Recorded for find_package consumers (shared vs static package layout)
if (MD3_BUILD_SHARED)
    set(MD3_PACKAGE_SHARED 1)
else()
    set(MD3_PACKAGE_SHARED 0)
endif()
# Effects/Shapes may be public or *Private depending on the Qt kit used to build.
set(MD3_PACKAGE_EFFECTS_TARGET "${MD3_QT_EFFECTS_TARGET}")
set(MD3_PACKAGE_SHAPES_TARGET "${MD3_QT_SHAPES_TARGET}")
set(MD3_PACKAGE_DIALOGS2_TARGET "${MD3_QT_DIALOGS2_TARGET}")

configure_package_config_file(
    ${MD3_ROOT}/cmake/Md3Config.cmake.in
    ${CMAKE_CURRENT_BINARY_DIR}/Md3Config.cmake
    INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/Md3
)
write_basic_package_version_file(
    ${CMAKE_CURRENT_BINARY_DIR}/Md3ConfigVersion.cmake
    VERSION ${MD3_VERSION}
    COMPATIBILITY SameMajorVersion
)
install(FILES
    ${CMAKE_CURRENT_BINARY_DIR}/Md3Config.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/Md3ConfigVersion.cmake
    ${MD3_ROOT}/cmake/Md3DeployShared.cmake
    ${MD3_ROOT}/cmake/Md3StripQmldirPrefer.cmake
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/Md3
)

message(STATUS "Md3 ${MD3_VERSION}: library URI=Md3 (Gallery excluded from this target)")
