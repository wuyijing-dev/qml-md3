#pragma once

#include "md3.h"

#ifdef __cplusplus
extern "C" {
#endif

/// Plain C config for Python ctypes / Rust / other hosts. All pointers may be NULL.
/// Field layout must stay ABI-compatible across language hosts.
typedef struct Md3RunConfig {
    const char *organization;
    const char *application_name;
    const char *application_version;
    const char *style;
    const char *desktop_file_name;
    const char *app_user_model_id;
    /// Extra QML import path (single directory, typically `…/lib/qml`).
    const char *qml_import_path;
    int alpha_buffer;  /* default 1 if config is NULL */
    int load_fonts;    /* default 1 if config is NULL */
    int print_banner;  /* default 0; Release-only banner via Md3::printBanner */
} Md3RunConfig;

/// Load a filesystem `.qml` that `import Md3`. Returns process exit code (0 ok).
MD3_API int md3_run_qml_file(int argc, char **argv,
                             const char *qml_file,
                             const Md3RunConfig *config);

/// Load QML module URI + component (same as Md3::run).
MD3_API int md3_run_qml_module(int argc, char **argv,
                               const char *module_uri,
                               const char *main_component,
                               const Md3RunConfig *config);

MD3_API const char *md3_version_string(void);

/// Load HarmonyOS Sans SC + Material Icons (same as ``Md3::loadFonts``).
/// Call after QGuiApplication exists. Returns number of faces loaded (may be 0).
MD3_API int md3_load_fonts(void);

#ifdef __cplusplus
}
#endif
