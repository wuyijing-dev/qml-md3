# Optional Gallery demo application (not part of the Md3 library).

if (NOT TARGET Md3)
    message(FATAL_ERROR "Gallery requires Md3 library target — add_subdirectory(src/Md3) first")
endif()

find_package(Qt6 REQUIRED COMPONENTS Quick QuickControls2 QuickEffects)

set(MD3_QML_NO_CACHEGEN)
if (WIN32)
    set(MD3_QML_NO_CACHEGEN NO_CACHEGEN)
endif()

get_filename_component(MD3_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/.." ABSOLUTE)

qt_add_executable(appQML_MD3 ${MD3_ROOT}/src/main.cpp)

if (WIN32 AND MSVC)
    target_sources(appQML_MD3 PRIVATE ${MD3_ROOT}/resources/app.rc)
    target_link_options(appQML_MD3 PRIVATE "/MANIFEST:NO")
elseif (WIN32)
    target_sources(appQML_MD3 PRIVATE ${MD3_ROOT}/resources/app.rc)
endif()

# Fonts ship inside the Md3 QML module (see src/Md3/CMakeLists.txt).
# Do NOT qt_add_resources them here — QT_RESOURCE_ALIAS + deferred IDE exposure
# incorrectly resolves basenames under gallery/ on MSVC/Qt Creator.

# Icons: files must live under gallery/ at the same relative path used in qrc.
# QT_RESOURCE_ALIAS / BASE+basename make MSVC finalize look for gallery/<basename>
# and fail. PREFIX "/" + relative FILES "md3/icons/..." matches :/md3/icons/...
set(_gallery_icon_dir "${CMAKE_CURRENT_SOURCE_DIR}/md3/icons")
file(MAKE_DIRECTORY "${_gallery_icon_dir}")
set(GALLERY_ICON_NAMES
    app-icon.png
    app-icon-16.png
    app-icon-32.png
    app-icon-48.png
    app-icon-256.png
)
set(GALLERY_ICON_FILES "")
foreach (_n IN LISTS GALLERY_ICON_NAMES)
    set(_src "${MD3_ROOT}/resources/icons/${_n}")
    set(_dst "${_gallery_icon_dir}/${_n}")
    if (NOT EXISTS "${_src}")
        message(FATAL_ERROR "Missing icon: ${_src}")
    endif()
    configure_file("${_src}" "${_dst}" COPYONLY)
    list(APPEND GALLERY_ICON_FILES "md3/icons/${_n}")
endforeach()

qt_add_resources(appQML_MD3 "md3_app_icons"
    PREFIX "/"
    FILES ${GALLERY_ICON_FILES}
)

qt_add_qml_module(appQML_MD3
    URI Gallery
    VERSION 1.0
    ${MD3_QML_NO_CACHEGEN}
    SOURCES
        performancemonitor.h
        performancemonitor.cpp
    QML_FILES
        Main.qml
        PerformancePanel.qml
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
        pages/ExtrasPage.qml
        pages/MotionPage.qml
        pages/ThemePage.qml
        pages/ChartsPage.qml
        pages/WindowPage.qml
        pages/scenes/LoginScene.qml
        pages/scenes/SettingsScene.qml
        pages/scenes/ListDetailScene.qml
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
target_link_libraries(appQML_MD3 PRIVATE Qt6::Quick Qt6::QuickControls2 Qt6::QuickEffects Md3)
# Static QML module registration
if (TARGET Md3plugin)
    target_link_libraries(appQML_MD3 PRIVATE Md3plugin)
endif()
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

message(STATUS "Md3 Gallery: appQML_MD3 enabled")
