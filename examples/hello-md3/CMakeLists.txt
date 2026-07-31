cmake_minimum_required(VERSION 3.16)

project(hello_md3 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# --- Resolve Md3 -----------------------------------------------------------
# 1) In-tree: parent build already has target Md3 (MD3_BUILD_EXAMPLES=ON)
# 2) Packaged: copy dist/Md3 next to this CMakeLists as ./Md3
# 3) Standalone: add_subdirectory the library repo

if (NOT TARGET Md3)
    set(_hello_pkg "${CMAKE_CURRENT_SOURCE_DIR}/Md3")
    if (EXISTS "${_hello_pkg}/lib/cmake/Md3/Md3Config.cmake")
        list(APPEND CMAKE_PREFIX_PATH "${_hello_pkg}")
        find_package(Md3 REQUIRED CONFIG)
    elseif (EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/../../src/Md3/CMakeLists.txt")
        set(MD3_BUILD_GALLERY OFF CACHE BOOL "" FORCE)
        set(MD3_BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)
        add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/../.." "${CMAKE_BINARY_DIR}/_md3_lib")
    else()
        message(FATAL_ERROR
            "Md3 not found. Copy dist/Md3 → examples/hello-md3/Md3, "
            "or configure the repo with -DMD3_BUILD_EXAMPLES=ON.")
    endif()
endif()

include("${CMAKE_CURRENT_SOURCE_DIR}/../../cmake/Md3QtCompat.cmake" OPTIONAL)
if (COMMAND md3_find_qt)
    md3_find_qt(Core Gui Qml Quick QuickControls2)
    md3_setup_qt_qml_policies()
else()
    find_package(Qt6 6.5 REQUIRED COMPONENTS Core Gui Qml Quick QuickControls2)
endif()

if (COMMAND qt_standard_project_setup)
    qt_standard_project_setup(REQUIRES 6.5)
endif()

qt_add_executable(hello_md3 main.cpp)

qt_add_qml_module(hello_md3
    URI HelloMd3
    VERSION 1.0
    QML_FILES Main.qml
)

target_link_libraries(hello_md3 PRIVATE Md3::Md3 Qt6::Quick Qt6::QuickControls2)

if (TARGET Md3plugin)
    target_link_libraries(hello_md3 PRIVATE Md3plugin)
endif()
if (TARGET Md3::QmlPlugin)
    target_link_libraries(hello_md3 PRIVATE Md3::QmlPlugin)
endif()

set_target_properties(hello_md3 PROPERTIES
    WIN32_EXECUTABLE TRUE
    MACOSX_BUNDLE TRUE
)

install(TARGETS hello_md3 BUNDLE DESTINATION . RUNTIME DESTINATION bin)
