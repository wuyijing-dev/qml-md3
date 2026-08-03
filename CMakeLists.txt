cmake_minimum_required(VERSION 3.16)

project(QML_MD3 VERSION 1.1.4 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

include(cmake/Md3QtCompat.cmake)
include(cmake/Md3Platform.cmake)

# Required baseline for full library + Gallery (Qt 6.5+; see docs/topics/qt-version-matrix.md).
md3_find_qt(Core Gui Qml Quick QuickControls2 Network)
md3_resolve_optional_qt_modules()
md3_setup_qt_qml_policies()
if (COMMAND qt_standard_project_setup)
    qt_standard_project_setup(REQUIRES 6.5)
endif()

# Top-level repo build → Gallery ON by default (OFF on WASM — browser demo is optional).
# add_subdirectory(this-repo) from another project → Gallery OFF (library only).
set(_md3_gallery_default ON)
if (NOT CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
    set(_md3_gallery_default OFF)
endif()
if (MD3_IS_WASM)
    set(_md3_gallery_default OFF)
endif()
option(MD3_BUILD_GALLERY "Build the Md3 Gallery demo application" ${_md3_gallery_default})
option(MD3_BUILD_EXAMPLES "Build examples/hello-md3" OFF)
option(MD3_BUILD_SHARED "Build Md3 as a shared library" OFF)
option(MD3_BUILD_TESTS "Build qml smoke tests" OFF)
# qmlcachegen: faster cold page open (bytecode in binary). Default ON for all configs.
# Turn OFF only while iterating QML without clean rebuilds: -DMD3_QML_CACHEGEN=OFF
option(MD3_QML_CACHEGEN "Compile QML with qmlcachegen (faster cold open)" ON)

# WASM: prefer static; Gallery stays opt-in (large download).
if (MD3_IS_WASM)
    set(MD3_BUILD_SHARED OFF CACHE BOOL "Build Md3 as a shared library" FORCE)
endif()

# ----- Library (URI Md3) — always built -----
add_subdirectory(src/Md3)

# ----- Optional Gallery -----
if (MD3_BUILD_GALLERY)
    add_subdirectory(gallery)
else()
    message(STATUS "Md3: MD3_BUILD_GALLERY=OFF — building library only")
endif()

# ----- Optional examples -----
if (MD3_BUILD_EXAMPLES)
    add_subdirectory(examples/hello-md3)
endif()

# ----- Optional smoke tests -----
if (MD3_BUILD_TESTS)
    enable_testing()
    add_subdirectory(tests/smoke)
endif()
