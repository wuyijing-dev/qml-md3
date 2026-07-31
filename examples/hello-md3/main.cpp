#include "md3.h"

#include <QtQml/qqmlextensionplugin.h>

// Required for static Md3 packages; harmless with shared.
Q_IMPORT_QML_PLUGIN(Md3Plugin)

int main(int argc, char *argv[])
{
    Md3::RunOptions opts;
    opts.organization = QStringLiteral("QML_MD3");
    opts.applicationName = QStringLiteral("Hello Md3");
    opts.applicationVersion = QStringLiteral("1.0.0");
    return Md3::run(argc, argv, QStringLiteral("HelloMd3"), QStringLiteral("Main"), opts);
}
