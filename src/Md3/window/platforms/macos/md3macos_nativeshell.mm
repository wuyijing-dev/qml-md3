#include "md3nativeshell_p.h"
#include "md3nativeshell.h"

#include <QCoreApplication>
#include <QHash>
#include <QKeyCombination>
#include <QKeySequence>

#import <AppKit/AppKit.h>
#import <Carbon/Carbon.h>
#import <CoreServices/CoreServices.h>

namespace {

CFStringRef toCf(const QString &s)
{
    return CFStringCreateWithCharacters(kCFAllocatorDefault,
                                        reinterpret_cast<const UniChar *>(s.utf16()),
                                        CFIndex(s.size()));
}

Md3NativeShell *g_owner = nullptr;
QHash<int, EventHotKeyRef> g_hotkeys;
EventHandlerRef g_handler = nullptr;

UInt32 qtKeyToMacVirtual(int key)
{
    if (key >= Qt::Key_A && key <= Qt::Key_Z) {
        static const UInt32 letters[26] = {
            kVK_ANSI_A, kVK_ANSI_B, kVK_ANSI_C, kVK_ANSI_D, kVK_ANSI_E, kVK_ANSI_F, kVK_ANSI_G,
            kVK_ANSI_H, kVK_ANSI_I, kVK_ANSI_J, kVK_ANSI_K, kVK_ANSI_L, kVK_ANSI_M, kVK_ANSI_N,
            kVK_ANSI_O, kVK_ANSI_P, kVK_ANSI_Q, kVK_ANSI_R, kVK_ANSI_S, kVK_ANSI_T, kVK_ANSI_U,
            kVK_ANSI_V, kVK_ANSI_W, kVK_ANSI_X, kVK_ANSI_Y, kVK_ANSI_Z
        };
        return letters[key - Qt::Key_A];
    }
    if (key >= Qt::Key_0 && key <= Qt::Key_9) {
        static const UInt32 digits[] = { kVK_ANSI_0, kVK_ANSI_1, kVK_ANSI_2, kVK_ANSI_3, kVK_ANSI_4,
                                         kVK_ANSI_5, kVK_ANSI_6, kVK_ANSI_7, kVK_ANSI_8, kVK_ANSI_9 };
        return digits[key - Qt::Key_0];
    }
    if (key >= Qt::Key_F1 && key <= Qt::Key_F12) {
        static const UInt32 fk[] = { kVK_F1, kVK_F2, kVK_F3, kVK_F4, kVK_F5, kVK_F6,
                                     kVK_F7, kVK_F8, kVK_F9, kVK_F10, kVK_F11, kVK_F12 };
        return fk[key - Qt::Key_F1];
    }
    switch (key) {
    case Qt::Key_Space: return kVK_Space;
    case Qt::Key_Tab: return kVK_Tab;
    case Qt::Key_Escape: return kVK_Escape;
    case Qt::Key_Return:
    case Qt::Key_Enter: return kVK_Return;
    case Qt::Key_Delete: return kVK_ForwardDelete;
    case Qt::Key_Backspace: return kVK_Delete;
    case Qt::Key_Left: return kVK_LeftArrow;
    case Qt::Key_Right: return kVK_RightArrow;
    case Qt::Key_Up: return kVK_UpArrow;
    case Qt::Key_Down: return kVK_DownArrow;
    default: return 0;
    }
}

UInt32 qtModsToMac(Qt::KeyboardModifiers mods)
{
    UInt32 m = 0;
    if (mods & Qt::ShiftModifier)
        m |= shiftKey;
    if (mods & Qt::ControlModifier)
        m |= controlKey;
    if (mods & Qt::AltModifier)
        m |= optionKey;
    if (mods & Qt::MetaModifier)
        m |= cmdKey;
    return m;
}

OSStatus hotKeyHandler(EventHandlerCallRef, EventRef event, void *)
{
    EventHotKeyID hid{};
    GetEventParameter(event, kEventParamDirectObject, typeEventHotKeyID, nullptr, sizeof(hid),
                      nullptr, &hid);
    if (g_owner)
        g_owner->handleHotkey(int(hid.id));
    return noErr;
}

bool ensureHandler()
{
    if (g_handler)
        return true;
    EventTypeSpec spec = { kEventClassKeyboard, kEventHotKeyPressed };
    return InstallEventHandler(GetApplicationEventTarget(), hotKeyHandler, 1, &spec, nullptr,
                               &g_handler)
            == noErr;
}

QString bundleId()
{
    @autoreleasepool {
        NSString *bid = [[NSBundle mainBundle] bundleIdentifier];
        if (bid && bid.length)
            return QString::fromNSString(bid);
    }
    const QString org = QCoreApplication::organizationName();
    const QString app = QCoreApplication::applicationName();
    return QStringLiteral("com.%1.%2")
            .arg(org.isEmpty() ? QStringLiteral("md3") : org.toLower().replace(QLatin1Char(' '), QLatin1Char('.')))
            .arg(app.isEmpty() ? QStringLiteral("app") : app.toLower().replace(QLatin1Char(' '), QLatin1Char('.')));
}

} // namespace

namespace Md3NativeShellPlatform {

bool globalShortcutSupported()
{
    return true;
}

bool registerGlobalShortcut(Md3NativeShell *owner, const QString &, const QKeySequence &seq,
                            int nativeId)
{
    g_owner = owner;
    if (seq.isEmpty() || !ensureHandler())
        return false;
    const QKeyCombination comb = seq[0];
    const UInt32 vk = qtKeyToMacVirtual(int(comb.key()));
    const UInt32 mods = qtModsToMac(comb.keyboardModifiers());
    if (!vk)
        return false;
    EventHotKeyID hid{ 'md3h', UInt32(nativeId) };
    EventHotKeyRef ref = nullptr;
    if (RegisterEventHotKey(vk, mods, hid, GetApplicationEventTarget(), 0, &ref) != noErr)
        return false;
    g_hotkeys.insert(nativeId, ref);
    return true;
}

bool unregisterGlobalShortcut(int nativeId)
{
    if (!g_hotkeys.contains(nativeId))
        return false;
    EventHotKeyRef ref = g_hotkeys.take(nativeId);
    UnregisterEventHotKey(ref);
    return true;
}

void shutdownGlobalShortcuts()
{
    const auto ids = g_hotkeys.keys();
    for (int id : ids)
        unregisterGlobalShortcut(id);
    if (g_handler) {
        RemoveEventHandler(g_handler);
        g_handler = nullptr;
    }
    g_owner = nullptr;
}

bool protocolClientSupported()
{
    return true;
}

bool setAsDefaultProtocolClient(const QString &scheme, const QString &, const QStringList &,
                                QString *statusOut)
{
    CFStringRef schemeRef = toCf(scheme);
    CFStringRef bid = toCf(bundleId());
    OSStatus st = LSSetDefaultHandlerForURLScheme(schemeRef, bid);
    CFRelease(schemeRef);
    CFRelease(bid);
    if (statusOut) {
        *statusOut = (st == noErr) ? QStringLiteral("protocol: registered %1:// (LS)").arg(scheme)
                                   : QStringLiteral("protocol: LSSetDefaultHandler failed (%1)").arg(int(st));
    }
    return st == noErr;
}

bool removeAsDefaultProtocolClient(const QString &scheme, QString *statusOut)
{
    // macOS has no clean per-app remove; clearing means setting another handler.
    // Best-effort: register Safari/Chrome is wrong — just report unsupported remove.
    if (statusOut)
        *statusOut = QStringLiteral("protocol: macOS cannot fully unregister %1:// (reset in System Settings)")
                             .arg(scheme);
    return false;
}

bool isDefaultProtocolClient(const QString &scheme)
{
    CFStringRef schemeRef = toCf(scheme);
    CFStringRef handler = LSCopyDefaultHandlerForURLScheme(schemeRef);
    CFRelease(schemeRef);
    if (!handler)
        return false;
    const QString h = QString::fromCFString(handler);
    CFRelease(handler);
    return h.compare(bundleId(), Qt::CaseInsensitive) == 0;
}

void installSessionWatch(Md3NativeShell *owner)
{
    g_owner = owner;
    @autoreleasepool {
        NSWorkspace *ws = [NSWorkspace sharedWorkspace];
        NSNotificationCenter *nc = [ws notificationCenter];
        [nc addObserverForName:NSWorkspaceWillSleepNotification
                        object:nil
                         queue:[NSOperationQueue mainQueue]
                    usingBlock:^(NSNotification *) {
                        if (g_owner)
                            emit g_owner->suspend();
                    }];
        [nc addObserverForName:NSWorkspaceDidWakeNotification
                        object:nil
                         queue:[NSOperationQueue mainQueue]
                    usingBlock:^(NSNotification *) {
                        if (g_owner)
                            emit g_owner->resume();
                    }];
        [nc addObserverForName:NSWorkspaceScreensDidSleepNotification
                        object:nil
                         queue:[NSOperationQueue mainQueue]
                    usingBlock:^(NSNotification *) {
                        if (g_owner)
                            emit g_owner->lockScreen();
                    }];
        [nc addObserverForName:NSWorkspaceScreensDidWakeNotification
                        object:nil
                         queue:[NSOperationQueue mainQueue]
                    usingBlock:^(NSNotification *) {
                        if (g_owner)
                            emit g_owner->unlockScreen();
                    }];
    }
}

void uninstallSessionWatch()
{
    // Observers are process-lifetime; acceptable for singleton shell.
}

} // namespace Md3NativeShellPlatform
