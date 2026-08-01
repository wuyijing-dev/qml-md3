include_guard(GLOBAL)

# Md3 Qt6 compatibility layer (6.5 / 6.8 / 6.10+).
# Isolates kit differences (Effects/Shapes public vs Private, version gates) so
# application code and QML keep one behavior path.
#
# Critical: find_package(Qt6) MUST run in macro (or directory) scope — NOT a
# function — so QT_KNOWN_POLICY_QTP000* from Qt6QmlConfig propagate.

set(MD3_QT_MIN_VERSION "6.5.0" CACHE STRING "Minimum Qt6 version for Md3")

# Kept for cache compatibility; only "6" / "AUTO" are accepted (Qt5 removed).
set(MD3_QT_VERSION "6" CACHE STRING "Qt major (Md3 is Qt6-only; AUTO≡6)")
set_property(CACHE MD3_QT_VERSION PROPERTY STRINGS AUTO 6)

set(_md3_qt_pick "${MD3_QT_VERSION}")
string(TOUPPER "${_md3_qt_pick}" _md3_qt_pick)
if (_md3_qt_pick STREQUAL "5")
    message(FATAL_ERROR
        "Md3 no longer supports Qt 5.15. Use Qt ${MD3_QT_MIN_VERSION}+ "
        "(recommended 6.8 / 6.10). Unset MD3_QT_VERSION=5.")
endif()
if (NOT (_md3_qt_pick STREQUAL "AUTO" OR _md3_qt_pick STREQUAL "6"))
    message(FATAL_ERROR "MD3_QT_VERSION must be AUTO or 6 (got: ${MD3_QT_VERSION})")
endif()

find_package(Qt6 ${MD3_QT_MIN_VERSION} REQUIRED COMPONENTS Core)
set(MD3_QT_MAJOR 6 CACHE INTERNAL "Resolved Qt major version")
set(MD3_QT_PACKAGE "Qt6" CACHE INTERNAL "Resolved Qt package prefix")

if (NOT DEFINED Qt6_VERSION)
    message(FATAL_ERROR "Qt6_VERSION unset after find_package(Qt6)")
endif()
set(MD3_QT_VERSION_STRING "${Qt6_VERSION}" CACHE INTERNAL "Resolved Qt6 version string")

# Parse minor/patch for feature gates (same semantics on 6.5 / 6.8 / 6.10).
if (Qt6_VERSION MATCHES "^([0-9]+)\\.([0-9]+)\\.([0-9]+)")
    set(MD3_QT_VERSION_MAJOR ${CMAKE_MATCH_1})
    set(MD3_QT_VERSION_MINOR ${CMAKE_MATCH_2})
    set(MD3_QT_VERSION_PATCH ${CMAKE_MATCH_3})
else()
    set(MD3_QT_VERSION_MAJOR 6)
    set(MD3_QT_VERSION_MINOR 5)
    set(MD3_QT_VERSION_PATCH 0)
endif()

# Quiet "using private module headers" when we fall back to *Private targets.
set(QT_NO_PRIVATE_MODULE_WARNING ON)

message(STATUS "Md3: Qt ${MD3_QT_VERSION_STRING} (min ${MD3_QT_MIN_VERSION}; "
               "Effects/Shapes: public preferred, Private fallback)")

# ---- find helpers (macros so policy vars / imported targets stay visible) ----

macro(md3_find_qt)
    if (NOT ${ARGC})
        message(FATAL_ERROR "md3_find_qt requires at least one Qt component")
    endif()
    find_package(Qt6 REQUIRED COMPONENTS ${ARGV})
endmacro()

macro(md3_find_qt_optional)
    if (${ARGC})
        find_package(Qt6 COMPONENTS ${ARGV} QUIET)
    endif()
endmacro()

function(md3_qt_target out_var module_name)
    set(${out_var} "Qt6::${module_name}" PARENT_SCOPE)
endfunction()

# Prefer public CMake target; fall back to *Private (Qt 6.5 / 6.8 kits).
function(md3_resolve_qt_target out_var)
    set(_candidates ${ARGN})
    foreach (_name IN LISTS _candidates)
        if (TARGET "Qt6::${_name}")
            set(${out_var} "Qt6::${_name}" PARENT_SCOPE)
            return()
        endif()
    endforeach()
    set(${out_var} "" PARENT_SCOPE)
endfunction()

# After Core+Qml are found, mark policies known and prefer NEW behavior.
macro(md3_setup_qt_qml_policies)
    foreach (_pol QTP0001 QTP0004 QTP0005)
        if (NOT DEFINED QT_KNOWN_POLICY_${_pol})
            set(QT_KNOWN_POLICY_${_pol} TRUE)
        endif()
        if (COMMAND qt_policy)
            qt_policy(SET ${_pol} NEW)
        elseif (COMMAND qt6_policy)
            qt6_policy(SET ${_pol} NEW)
        endif()
    endforeach()
endmacro()

# Resolve QuickEffects / QuickShapes / Multimedia / Dialogs2.
# Public targets on 6.10+; Private package names on many 6.5/6.8 kits.
macro(md3_resolve_optional_qt_modules)
    set(MD3_QT_HAS_EFFECTS FALSE)
    set(MD3_QT_EFFECTS_TARGET "")
    set(MD3_QT_HAS_SHAPES FALSE)
    set(MD3_QT_SHAPES_TARGET "")
    set(MD3_QT_HAS_MULTIMEDIA FALSE)
    set(MD3_QT_MULTIMEDIA_TARGET "")
    set(MD3_QT_HAS_DIALOGS2 FALSE)
    set(MD3_QT_DIALOGS2_TARGET "")
    set(MD3_QT_EFFECTS_BACKEND "")
    set(MD3_QT_SHAPES_BACKEND "")

    find_package(Qt6 QUIET COMPONENTS QuickEffects)
    if (NOT TARGET Qt6::QuickEffects)
        find_package(Qt6 QUIET COMPONENTS QuickEffectsPrivate)
    endif()
    md3_resolve_qt_target(MD3_QT_EFFECTS_TARGET QuickEffects QuickEffectsPrivate)
    if (MD3_QT_EFFECTS_TARGET)
        set(MD3_QT_HAS_EFFECTS TRUE)
        if (MD3_QT_EFFECTS_TARGET STREQUAL "Qt6::QuickEffects")
            set(MD3_QT_EFFECTS_BACKEND "public")
        else()
            set(MD3_QT_EFFECTS_BACKEND "private")
        endif()
    endif()

    find_package(Qt6 QUIET COMPONENTS QuickShapes)
    if (NOT TARGET Qt6::QuickShapes)
        find_package(Qt6 QUIET COMPONENTS QuickShapesPrivate)
    endif()
    md3_resolve_qt_target(MD3_QT_SHAPES_TARGET QuickShapes QuickShapesPrivate)
    if (MD3_QT_SHAPES_TARGET)
        set(MD3_QT_HAS_SHAPES TRUE)
        if (MD3_QT_SHAPES_TARGET STREQUAL "Qt6::QuickShapes")
            set(MD3_QT_SHAPES_BACKEND "public")
        else()
            set(MD3_QT_SHAPES_BACKEND "private")
        endif()
    endif()

    find_package(Qt6 QUIET COMPONENTS Multimedia)
    if (TARGET Qt6::Multimedia)
        set(MD3_QT_HAS_MULTIMEDIA TRUE)
        set(MD3_QT_MULTIMEDIA_TARGET Qt6::Multimedia)
    endif()

    find_package(Qt6 QUIET COMPONENTS QuickDialogs2)
    if (TARGET Qt6::QuickDialogs2)
        set(MD3_QT_HAS_DIALOGS2 TRUE)
        set(MD3_QT_DIALOGS2_TARGET Qt6::QuickDialogs2)
    endif()

    message(STATUS "Md3 Qt6 optional: Effects=${MD3_QT_HAS_EFFECTS} (${MD3_QT_EFFECTS_TARGET}/${MD3_QT_EFFECTS_BACKEND}) "
                   "Shapes=${MD3_QT_HAS_SHAPES} (${MD3_QT_SHAPES_TARGET}/${MD3_QT_SHAPES_BACKEND}) "
                   "Multimedia=${MD3_QT_HAS_MULTIMEDIA} Dialogs2=${MD3_QT_HAS_DIALOGS2}")
    if (NOT MD3_QT_HAS_EFFECTS)
        message(WARNING "Md3: QuickEffects not found — install Qt Quick Effects for this kit.")
    endif()
    if (NOT MD3_QT_HAS_SHAPES)
        message(WARNING "Md3: QuickShapes not found — Shape-based charts/progress may fail to link.")
    endif()
endmacro()

# Apply version / backend compile definitions so C++ uses one feature matrix.
function(md3_apply_qt_compat_definitions target_name)
    if (NOT TARGET "${target_name}")
        message(FATAL_ERROR "md3_apply_qt_compat_definitions: unknown target ${target_name}")
    endif()
    target_compile_definitions(${target_name}
        PRIVATE
            MD3_QT_VERSION_MAJOR=${MD3_QT_VERSION_MAJOR}
            MD3_QT_VERSION_MINOR=${MD3_QT_VERSION_MINOR}
            MD3_QT_VERSION_PATCH=${MD3_QT_VERSION_PATCH}
            "MD3_QT_VERSION_STRING=\"${MD3_QT_VERSION_STRING}\""
    )
    # Always-on for min 6.5; keep macros for readable #if in sources.
    target_compile_definitions(${target_name} PRIVATE MD3_QT_AT_LEAST_65=1)
    if (MD3_QT_VERSION_MINOR GREATER_EQUAL 6)
        target_compile_definitions(${target_name} PRIVATE MD3_QT_AT_LEAST_66=1)
    else()
        target_compile_definitions(${target_name} PRIVATE MD3_QT_AT_LEAST_66=0)
    endif()
    if (MD3_QT_VERSION_MINOR GREATER_EQUAL 7)
        target_compile_definitions(${target_name} PRIVATE MD3_QT_AT_LEAST_67=1)
    else()
        target_compile_definitions(${target_name} PRIVATE MD3_QT_AT_LEAST_67=0)
    endif()
    if (MD3_QT_VERSION_MINOR GREATER_EQUAL 8)
        target_compile_definitions(${target_name} PRIVATE MD3_QT_AT_LEAST_68=1)
    else()
        target_compile_definitions(${target_name} PRIVATE MD3_QT_AT_LEAST_68=0)
    endif()
    if (MD3_QT_VERSION_MINOR GREATER_EQUAL 9)
        target_compile_definitions(${target_name} PRIVATE MD3_QT_AT_LEAST_69=1)
    else()
        target_compile_definitions(${target_name} PRIVATE MD3_QT_AT_LEAST_69=0)
    endif()
    if (MD3_QT_VERSION_MINOR GREATER_EQUAL 10)
        target_compile_definitions(${target_name} PRIVATE MD3_QT_AT_LEAST_610=1)
    else()
        target_compile_definitions(${target_name} PRIVATE MD3_QT_AT_LEAST_610=0)
    endif()
    if (MD3_QT_HAS_EFFECTS)
        target_compile_definitions(${target_name} PRIVATE MD3_HAS_QUICK_EFFECTS=1)
        if (MD3_QT_EFFECTS_BACKEND STREQUAL "private")
            target_compile_definitions(${target_name} PRIVATE MD3_QUICK_EFFECTS_PRIVATE=1)
        endif()
    else()
        target_compile_definitions(${target_name} PRIVATE MD3_HAS_QUICK_EFFECTS=0)
    endif()
    if (MD3_QT_HAS_SHAPES)
        target_compile_definitions(${target_name} PRIVATE MD3_HAS_QUICK_SHAPES=1)
    else()
        target_compile_definitions(${target_name} PRIVATE MD3_HAS_QUICK_SHAPES=0)
    endif()
endfunction()
