#include "md3nativeshell_p.h"

namespace Md3NativeShellPlatform {

bool globalShortcutSupported() { return false; }
bool registerGlobalShortcut(Md3NativeShell *, const QString &, const QKeySequence &, int)
{
    return false;
}
bool unregisterGlobalShortcut(int) { return false; }
void shutdownGlobalShortcuts() {}
bool protocolClientSupported() { return false; }
bool setAsDefaultProtocolClient(const QString &, const QString &, const QStringList &, QString *)
{
    return false;
}
bool removeAsDefaultProtocolClient(const QString &, QString *) { return false; }
bool isDefaultProtocolClient(const QString &) { return false; }
void installSessionWatch(Md3NativeShell *) {}
void uninstallSessionWatch() {}

} // namespace Md3NativeShellPlatform
