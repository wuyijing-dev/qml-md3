#include "md3.h"

#include <QByteArray>

int main(int argc, char *argv[])
{
    // Gallery AccessibilityPage loads qrc:/gallery/data/*.json via XHR.
    qputenv("QML_XHR_ALLOW_FILE_READ", QByteArrayLiteral("1"));

    Md3::RunOptions opts;
    opts.organization = QStringLiteral("QML_MD3");
    opts.applicationName = QStringLiteral("Md3 Gallery");
    opts.applicationVersion = QStringLiteral("1.0.0");
#if defined(Q_OS_WIN)
    opts.appUserModelId = QStringLiteral("QML_MD3.Md3Gallery");
#endif
#if defined(Q_OS_LINUX)
    // XDG / Unity LauncherEntry object paths cannot contain spaces.
    opts.desktopFileName = QStringLiteral("Md3_Gallery");
#endif
    return Md3::run(argc, argv, QStringLiteral("Gallery"), QStringLiteral("Main"), opts);
}
