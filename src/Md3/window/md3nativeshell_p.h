#pragma once

#include <QKeySequence>
#include <QString>
#include <QStringList>

class Md3NativeShell;

/// Platform hooks for Md3NativeShell (implemented per OS).
namespace Md3NativeShellPlatform {

bool globalShortcutSupported();
/// Register OS hotkey; on success owner maps id↔nativeId itself.
bool registerGlobalShortcut(Md3NativeShell *owner, const QString &id, const QKeySequence &seq,
                            int nativeId);
bool unregisterGlobalShortcut(int nativeId);
void shutdownGlobalShortcuts();

bool protocolClientSupported();
bool setAsDefaultProtocolClient(const QString &scheme, const QString &exePath,
                                const QStringList &args, QString *statusOut);
bool removeAsDefaultProtocolClient(const QString &scheme, QString *statusOut);
bool isDefaultProtocolClient(const QString &scheme);

/// Optional: session lock / unlock via OS (macOS / Linux logind).
void installSessionWatch(Md3NativeShell *owner);
void uninstallSessionWatch();

} // namespace Md3NativeShellPlatform
