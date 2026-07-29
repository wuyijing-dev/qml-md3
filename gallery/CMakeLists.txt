# Optional Gallery demo application (not part of the Md3 library).

if (NOT TARGET Md3)
    message(FATAL_ERROR "Gallery requires Md3 library target — add_subdirectory(src/Md3) first")
endif()

find_package(Qt6 REQUIRED COMPONENTS Quick QuickControls2 QuickEffects Multimedia QuickDialogs2)
if (UNIX AND NOT APPLE)
    # PerformanceMonitor / Linux chrome helpers need Widgets + DBus
    find_package(Qt6 REQUIRED COMPONENTS Widgets DBus)
endif()

set(MD3_QML_NO_CACHEGEN NO_CACHEGEN)
# Gallery QML changes often; cachegen can leave stale modules in build/ after git pull
# until a full rebuild — especially noticeable when switching between Windows and Linux.

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
        pages/LiquidGlassFusionPage.qml
        pages/CommunicationPage.qml
        pages/NavigationPage.qml
        pages/MenusPage.qml
        pages/PickersPage.qml
        pages/SearchPage.qml
        pages/DesktopPatternsPage.qml
        pages/ExtrasPage.qml
        pages/MotionPage.qml
        pages/ThemePage.qml
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
