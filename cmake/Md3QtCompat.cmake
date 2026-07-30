include_guard(GLOBAL)

# Md3 Qt major + optional-module resolution for 5.15 / 6.5 / 6.8 / 6.10+.
#
# Critical: find_package(Qt6) MUST run in macro (or directory) scope — NOT a
# function — so QT_KNOWN_POLICY_QTP000* from Qt6QmlConfig propagate. Otherwise
# qt_add_qml_module fatals with "QTP0005 is not a known Qt policy".

set(MD3_QT_VERSION "AUTO" CACHE STRING "Qt major version: AUTO, 5, or 6")
set_property(CACHE MD3_QT_VERSION PROPERTY STRINGS AUTO 5 6)

set(_md3_qt_pick "${MD3_QT_VERSION}")
string(TOUPPER "${_md3_qt_pick}" _md3_qt_pick)

if (_md3_qt_pick STREQUAL "AUTO")
    find_package(Qt6 QUIET COMPONENTS Core)
    if (Qt6_FOUND)
        set(MD3_QT_MAJOR 6)
    else()
        find_package(Qt5 REQUIRED COMPONENTS Core)
        set(MD3_QT_MAJOR 5)
    endif()
elseif (_md3_qt_pick STREQUAL "6")
    find_package(Qt6 REQUIRED COMPONENTS Core)
    set(MD3_QT_MAJOR 6)
elseif (_md3_qt_pick STREQUAL "5")
    find_package(Qt5 REQUIRED COMPONENTS Core)
    set(MD3_QT_MAJOR 5)
else()
    message(FATAL_ERROR "MD3_QT_VERSION must be AUTO, 5, or 6 (got: ${MD3_QT_VERSION})")
endif()

set(MD3_QT_MAJOR "${MD3_QT_MAJOR}" CACHE INTERNAL "Resolved Qt major version")
set(MD3_QT_PACKAGE "Qt${MD3_QT_MAJOR}" CACHE INTERNAL "Resolved Qt package prefix")

# Quiet "using private module headers" when we fall back to *Private targets.
set(QT_NO_PRIVATE_MODULE_WARNING ON)

# ---- find helpers (macros so policy vars / imported targets stay visible) ----

macro(md3_find_qt)
    if (NOT ${ARGC})
        message(FATAL_ERROR "md3_find_qt requires at least one Qt component")
    endif()
    find_package(${MD3_QT_PACKAGE} REQUIRED COMPONENTS ${ARGV})
endmacro()

macro(md3_find_qt_optional)
    # find_package OPTIONAL_COMPONENTS — missing modules are OK
    if (${ARGC})
        find_package(${MD3_QT_PACKAGE} COMPONENTS ${ARGV} QUIET)
    endif()
endmacro()

function(md3_qt_target out_var module_name)
    set(${out_var} "${MD3_QT_PACKAGE}::${module_name}" PARENT_SCOPE)
endfunction()

# Prefer public CMake target; fall back to *Private (Qt 6.5 / 6.8 kits).
function(md3_resolve_qt_target out_var)
    set(_candidates ${ARGN})
    foreach (_name IN LISTS _candidates)
        if (TARGET "${MD3_QT_PACKAGE}::${_name}")
            set(${out_var} "${MD3_QT_PACKAGE}::${_name}" PARENT_SCOPE)
            return()
        endif()
    endforeach()
    set(${out_var} "" PARENT_SCOPE)
endfunction()

# After Core+Qml are found, mark policies known in *this* directory scope and
# prefer NEW behavior (extra qmldirs, URI DEPENDENCIES, etc.).
macro(md3_setup_qt_qml_policies)
    if (MD3_QT_MAJOR EQUAL 6)
        foreach (_pol QTP0001 QTP0004 QTP0005)
            if (NOT DEFINED QT_KNOWN_POLICY_${_pol})
                # Older kits / find order: register so qt_policy / qt_add_qml_module
                # won't fatal. Safe no-op when Qt already registered the policy.
                set(QT_KNOWN_POLICY_${_pol} TRUE)
            endif()
            if (COMMAND qt_policy)
                qt_policy(SET ${_pol} NEW)
            elseif (COMMAND qt6_policy)
                qt6_policy(SET ${_pol} NEW)
            endif()
        endforeach()
    endif()
endmacro()

# Resolve QuickEffects / QuickShapes link targets used by Md3 + Gallery.
# Sets:
#   MD3_QT_HAS_EFFECTS, MD3_QT_EFFECTS_TARGET
#   MD3_QT_HAS_SHAPES,  MD3_QT_SHAPES_TARGET
#   MD3_QT_HAS_MULTIMEDIA, MD3_QT_MULTIMEDIA_TARGET
#   MD3_QT_HAS_DIALOGS2, MD3_QT_DIALOGS2_TARGET
macro(md3_resolve_optional_qt_modules)
    set(MD3_QT_HAS_EFFECTS FALSE)
    set(MD3_QT_EFFECTS_TARGET "")
    set(MD3_QT_HAS_SHAPES FALSE)
    set(MD3_QT_SHAPES_TARGET "")
    set(MD3_QT_HAS_MULTIMEDIA FALSE)
    set(MD3_QT_MULTIMEDIA_TARGET "")
    set(MD3_QT_HAS_DIALOGS2 FALSE)
    set(MD3_QT_DIALOGS2_TARGET "")

    if (MD3_QT_MAJOR EQUAL 6)
        # Public QuickEffects (6.10+); private-only on 6.5/6.8.
        find_package(Qt6 QUIET COMPONENTS QuickEffects)
        if (NOT TARGET Qt6::QuickEffects)
            find_package(Qt6 QUIET COMPONENTS QuickEffectsPrivate)
        endif()
        md3_resolve_qt_target(MD3_QT_EFFECTS_TARGET QuickEffects QuickEffectsPrivate)
        if (MD3_QT_EFFECTS_TARGET)
            set(MD3_QT_HAS_EFFECTS TRUE)
        endif()

        find_package(Qt6 QUIET COMPONENTS QuickShapes)
        if (NOT TARGET Qt6::QuickShapes)
            find_package(Qt6 QUIET COMPONENTS QuickShapesPrivate)
        endif()
        md3_resolve_qt_target(MD3_QT_SHAPES_TARGET QuickShapes QuickShapesPrivate)
        if (MD3_QT_SHAPES_TARGET)
            set(MD3_QT_HAS_SHAPES TRUE)
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

        message(STATUS "Md3 Qt6 optional: Effects=${MD3_QT_HAS_EFFECTS} (${MD3_QT_EFFECTS_TARGET}) "
                       "Shapes=${MD3_QT_HAS_SHAPES} (${MD3_QT_SHAPES_TARGET}) "
                       "Multimedia=${MD3_QT_HAS_MULTIMEDIA} Dialogs2=${MD3_QT_HAS_DIALOGS2}")
        if (NOT MD3_QT_HAS_EFFECTS)
            message(WARNING "Md3: QuickEffects not found — QtQuick.Effects/MultiEffect features need the "
                            "Qt Quick Effects module installed for this kit.")
        endif()
        if (NOT MD3_QT_HAS_SHAPES)
            message(WARNING "Md3: QuickShapes not found — Shape-based charts/progress may fail to link.")
        endif()
    endif()
endmacro()
