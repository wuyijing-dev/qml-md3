#include "md3.h"

int main(int argc, char *argv[])
{
    Md3::RunOptions opts;
    opts.organization = QStringLiteral("QML_MD3");
    opts.applicationName = QStringLiteral("Md3 Gallery");
    opts.applicationVersion = QStringLiteral("0.1.0");
#if defined(Q_OS_WIN)
    opts.appUserModelId = QStringLiteral("QML_MD3.Md3Gallery");
#endif
#if defined(Q_OS_LINUX)
    // XDG / Unity LauncherEntry object paths cannot contain spaces.
    opts.desktopFileName = QStringLiteral("Md3_Gallery");
#endif
    return Md3::run(argc, argv, QStringLiteral("Gallery"), QStringLiteral("Main"), opts);
}
