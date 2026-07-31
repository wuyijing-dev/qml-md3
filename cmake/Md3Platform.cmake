# Md3 platform helpers — detect WASM / Android before UNIX desktop.

if (NOT DEFINED MD3_IS_WASM)
    set(MD3_IS_WASM OFF)
    if (EMSCRIPTEN
            OR CMAKE_SYSTEM_NAME STREQUAL "Emscripten"
            OR CMAKE_SYSTEM_NAME STREQUAL "Wasm"
            OR CMAKE_SYSTEM_NAME STREQUAL "WASI")
        set(MD3_IS_WASM ON)
    endif()
    # qt-cmake WASM kits often set these
    if (DEFINED QT_QPA_DEFAULT_PLATFORM AND QT_QPA_DEFAULT_PLATFORM STREQUAL "wasm")
        set(MD3_IS_WASM ON)
    endif()
    if (DEFINED CMAKE_CXX_COMPILER)
        string(TOLOWER "${CMAKE_CXX_COMPILER}" _md3_cxx)
        if (_md3_cxx MATCHES "em\\+\\+" OR _md3_cxx MATCHES "emcc")
            set(MD3_IS_WASM ON)
        endif()
    endif()
endif()

if (NOT DEFINED MD3_IS_ANDROID)
    set(MD3_IS_ANDROID OFF)
    if (ANDROID OR CMAKE_SYSTEM_NAME STREQUAL "Android")
        set(MD3_IS_ANDROID ON)
    endif()
endif()

# WASM kit must not also be treated as Android / Linux desktop.
if (MD3_IS_WASM)
    set(MD3_IS_ANDROID OFF)
endif()

if (MD3_IS_WASM)
    message(STATUS "Md3: WebAssembly / Emscripten kit detected")
endif()
if (MD3_IS_ANDROID)
    message(STATUS "Md3: Android kit detected — native keep-screen-on / FLAG_SECURE / badge")
endif()
