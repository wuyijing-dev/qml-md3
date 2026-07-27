#pragma once

#include <QString>
#include <QtGlobal>

class QCoreApplication;
class QQmlApplicationEngine;

/// One-call bootstrap for Md3 apps (fonts, Basic style, RHI early setup).
namespace Md3 {

struct RunOptions {
    QString organization = QStringLiteral("Md3");
    QString applicationName = QStringLiteral("Md3 App");
    QString applicationVersion = QStringLiteral("0.1.0");
    QString style = QStringLiteral("Basic");
    bool loadFonts = true;
    /// Windows: enable translucent frames (Mica/Acrylic). Safe default.
    bool alphaBuffer = true;
#if defined(Q_OS_WIN)
    QString appUserModelId;
#endif
};

/// Call before QGuiApplication (alpha buffer + optional RHI). Also invoked by run().
void applyEarly(int &argc, char **argv, const RunOptions &opts = {});

/// Load HarmonyOS Sans SC + Material Icons from the Md3 module qrc and set app font.
int loadFonts();

/// After QGuiApplication: style + fonts. Idempotent-ish (safe to call once).
void initialize(QCoreApplication &app, const RunOptions &opts = {});

/**
 * Full startup in one call:
 * @code
 * int main(int argc, char *argv[]) {
 *     return Md3::run(argc, argv, "MyApp"); // loads MyApp/Main.qml
 * }
 * @endcode
 */
int run(int argc, char **argv,
        const QString &moduleUri,
        const QString &mainComponent = QStringLiteral("Main"),
        const RunOptions &opts = {});

} // namespace Md3
