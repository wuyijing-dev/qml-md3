#pragma once

#include <QtGlobal>

/// Unified Qt version feature gates for Md3 (6.5 baseline → 6.10+).
/// Prefer these over raw QT_VERSION checks so CMake and sources stay aligned.
///
/// When built via md3_apply_qt_compat_definitions(), MD3_QT_AT_LEAST_* are
/// injected from the configured kit. Fallbacks below cover standalone TU builds.

#ifndef MD3_QT_AT_LEAST_65
#  if QT_VERSION >= QT_VERSION_CHECK(6, 5, 0)
#    define MD3_QT_AT_LEAST_65 1
#  else
#    define MD3_QT_AT_LEAST_65 0
#  endif
#endif

#ifndef MD3_QT_AT_LEAST_66
#  if QT_VERSION >= QT_VERSION_CHECK(6, 6, 0)
#    define MD3_QT_AT_LEAST_66 1
#  else
#    define MD3_QT_AT_LEAST_66 0
#  endif
#endif

#ifndef MD3_QT_AT_LEAST_67
#  if QT_VERSION >= QT_VERSION_CHECK(6, 7, 0)
#    define MD3_QT_AT_LEAST_67 1
#  else
#    define MD3_QT_AT_LEAST_67 0
#  endif
#endif

#ifndef MD3_QT_AT_LEAST_68
#  if QT_VERSION >= QT_VERSION_CHECK(6, 8, 0)
#    define MD3_QT_AT_LEAST_68 1
#  else
#    define MD3_QT_AT_LEAST_68 0
#  endif
#endif

#ifndef MD3_QT_AT_LEAST_69
#  if QT_VERSION >= QT_VERSION_CHECK(6, 9, 0)
#    define MD3_QT_AT_LEAST_69 1
#  else
#    define MD3_QT_AT_LEAST_69 0
#  endif
#endif

#ifndef MD3_QT_AT_LEAST_610
#  if QT_VERSION >= QT_VERSION_CHECK(6, 10, 0)
#    define MD3_QT_AT_LEAST_610 1
#  else
#    define MD3_QT_AT_LEAST_610 0
#  endif
#endif

#ifndef MD3_HAS_QUICK_EFFECTS
#  define MD3_HAS_QUICK_EFFECTS 0
#endif

#ifndef MD3_HAS_QUICK_SHAPES
#  define MD3_HAS_QUICK_SHAPES 0
#endif
