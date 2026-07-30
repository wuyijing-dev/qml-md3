# Optional Gallery demo application (not part of the Md3 library).

if (NOT TARGET Md3)
    message(FATAL_ERROR "Gallery requires Md3 library target — add_subdirectory(src/Md3) first")
endif()

if (NOT DEFINED MD3_QT_MAJOR)
    include(${CMAKE_CURRENT_SOURCE_DIR}/../cmake/Md3QtCompat.cmake)
endif()

if (MD3_QT_MAJOR EQUAL 5)
    message(FATAL_ERROR "Gallery is stage2+ for Qt6 only. Use -DMD3_BUILD_GALLERY=OFF for Qt5.15 stage1.")
endif()

md3_find_qt(Core Qml Quick QuickControls2 QuickEffects Multimedia QuickDialogs2)
if (UNIX AND NOT APPLE)
    # PerformanceMonitor / Linux chrome helpers need Widgets + DBus
    md3_find_qt(Widgets DBus)
endif()

# Prefer parent option MD3_QML_CACHEGEN (default ON). Gallery-only override:
if (NOT DEFINED MD3_QML_CACHEGEN)
    set(MD3_QML_CACHEGEN ON)
endif()
set(MD3_QML_NO_CACHEGEN)
if (NOT MD3_QML_CACHEGEN)
    set(MD3_QML_NO_CACHEGEN NO_CACHEGEN)
endif()
# When OFF: avoids stale qmlcache after frequent Gallery QML edits without clean rebuild.

get_filename_component(MD3_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/.." ABSOLUTE)

qt_add_executable(appQML_MD3 ${MD3_ROOT}/src/main.cpp)

if (WIN32 AND MSVC)
    target_sources(appQML_MD3 PRIVATE ${MD3_ROOT}/resources/app.rc)
    target_link_options(appQML_MD3 PRIVATE "/MANIFEST:NO")
elseif (WIN32)
    target_sources(appQML_MD3 PRIVATE ${MD3_ROOT}/resources/app.rc)
endif()

# Fonts / icons ship inside the Md3 QML module (see src/Md3/CMakeLists.txt).
# Do NOT qt_add_resources them here — QT_RESOURCE_ALIAS + deferred IDE exposure
# incorrectly resolves basenames under gallery/ on MSVC/Qt Creator.
# Default window icons: qrc:/md3/icons/… via Md3AppIcons / Md3ApplicationWindow.

qt_add_resources(appQML_MD3 "gallery_data"
    PREFIX "/gallery"
    FILES
        data/a11y-scan.json
)

set(QT_KNOWN_POLICY_QTP0001 TRUE)
set(QT_KNOWN_POLICY_QTP0004 TRUE)
set(QT_KNOWN_POLICY_QTP0005 TRUE)
qt_add_qml_module(appQML_MD3
    URI Gallery
    VERSION 1.0
    ${MD3_QML_NO_CACHEGEN}
    QML_FILES
        Main.qml
        pages/TokensPage.qml
        pages/ButtonsPage.qml
        pages/FabPage.qml
        pages/SelectionPage.qml
        pages/TextFieldsPage.qml
        pages/ChipsPage.qml
        pages/ContainmentPage.qml
        pages/CommunicationPage.qml
        pages/NavigationPage.qml
        pages/MenusPage.qml
        pages/PickersPage.qml
        pages/SearchPage.qml
        pages/DesktopPatternsPage.qml
        pages/ExtrasPage.qml
        pages/MotionPage.qml
        pages/ThemePage.qml
        pages/AccessibilityPage.qml
        pages/ChartsPage.qml
        pages/WindowPage.qml
        pages/scenes/LoginScene.qml
        pages/scenes/SettingsScene.qml
        pages/scenes/ListDetailScene.qml
        pages/scenes/LaunchListScene.qml
        pages/scenes/LaunchDetailScene.qml
)

set_target_properties(appQML_MD3 PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_include_directories(appQML_MD3 PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${MD3_ROOT}/src/Md3/window
)
target_link_libraries(appQML_MD3 PRIVATE Qt6::Quick Qt6::QuickControls2 Qt6::QuickEffects Qt6::Multimedia Md3)
# Static QML module registration
if (TARGET Md3plugin)
    target_link_libraries(appQML_MD3 PRIVATE Md3plugin)
endif()
# Pull in static qml plugin + resource init objects (fonts, qmldir, …)
qt_import_qml_plugins(appQML_MD3)
if (UNIX AND NOT APPLE)
    target_link_libraries(appQML_MD3 PRIVATE Qt6::Widgets Qt6::DBus)
endif()

include(GNUInstallDirs)
install(TARGETS appQML_MD3
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

message(STATUS "Md3 Gallery: appQML_MD3 enabled")
