#include "md3_capi.h"

#include <QString>
#include <QStringList>

namespace {

Md3::RunOptions optionsFromC(const Md3RunConfig *config)
{
    Md3::RunOptions opts;
    if (!config)
        return opts;

    if (config->organization)
        opts.organization = QString::fromUtf8(config->organization);
    if (config->application_name)
        opts.applicationName = QString::fromUtf8(config->application_name);
    if (config->application_version)
        opts.applicationVersion = QString::fromUtf8(config->application_version);
    if (config->style)
        opts.style = QString::fromUtf8(config->style);
    if (config->desktop_file_name)
        opts.desktopFileName = QString::fromUtf8(config->desktop_file_name);
#if defined(Q_OS_WIN)
    if (config->app_user_model_id)
        opts.appUserModelId = QString::fromUtf8(config->app_user_model_id);
#endif
    if (config->qml_import_path && config->qml_import_path[0] != '\0')
        opts.qmlImportPaths = QStringList{QString::fromUtf8(config->qml_import_path)};
    opts.alphaBuffer = config->alpha_buffer != 0;
    opts.loadFonts = config->load_fonts != 0;
    opts.printBanner = config->print_banner != 0;
    return opts;
}

} // namespace

extern "C" {

int md3_run_qml_file(int argc, char **argv, const char *qml_file, const Md3RunConfig *config)
{
    if (!qml_file || !qml_file[0])
        return 2;
    const Md3::RunOptions opts = optionsFromC(config);
    return Md3::runQmlFile(argc, argv, QString::fromUtf8(qml_file), opts);
}

int md3_run_qml_module(int argc, char **argv, const char *module_uri,
                       const char *main_component, const Md3RunConfig *config)
{
    if (!module_uri || !module_uri[0])
        return 2;
    const char *comp = (main_component && main_component[0]) ? main_component : "Main";
    const Md3::RunOptions opts = optionsFromC(config);
    return Md3::run(argc, argv, QString::fromUtf8(module_uri), QString::fromUtf8(comp), opts);
}

const char *md3_version_string(void)
{
    return "1.0.0";
}

} // extern "C"
