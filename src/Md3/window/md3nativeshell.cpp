#include "md3nativeshell.h"

#include <QAbstractNativeEventFilter>
#include <QCoreApplication>
#include <QDir>
#include <QFile>
#include <QFileInfo>
#include <QGuiApplication>
#include <QKeyCombination>
#include <QKeySequence>
#include <QLocalServer>
#include <QLocalSocket>
#include <QProcess>
#include <QQmlEngine>
#include <QSharedMemory>
#include <QStandardPaths>
#include <QTextStream>
#include <QWindow>

#if defined(Q_OS_WIN)
#  ifndef NOMINMAX
#    define NOMINMAX
#  endif
#  include <windows.h>
#  include <wtsapi32.h>
#  pragma comment(lib, "Wtsapi32.lib")
#endif

namespace {

QString defaultLockId()
{
    const QString org = QCoreApplication::organizationName();
    const QString app = QCoreApplication::applicationName();
    QString id = (org.isEmpty() ? QStringLiteral("Md3") : org)
            + QLatin1Char('.')
            + (app.isEmpty() ? QStringLiteral("App") : app);
    id.replace(QLatin1Char(' '), QLatin1Char('_'));
    return id;
}

QString socketNameFor(const QString &id)
{
    return QStringLiteral("md3-si-") + id;
}

#if defined(Q_OS_WIN)
UINT qtModsToWin(Qt::KeyboardModifiers mods)
{
    UINT m = 0;
    if (mods & Qt::ShiftModifier)
        m |= MOD_SHIFT;
    if (mods & Qt::ControlModifier)
        m |= MOD_CONTROL;
    if (mods & Qt::AltModifier)
        m |= MOD_ALT;
    if (mods & Qt::MetaModifier)
        m |= MOD_WIN;
    return m;
}

UINT qtKeyToWinVk(int key)
{
    if (key >= Qt::Key_0 && key <= Qt::Key_9)
        return UINT('0' + (key - Qt::Key_0));
    if (key >= Qt::Key_A && key <= Qt::Key_Z)
        return UINT('A' + (key - Qt::Key_A));
    if (key >= Qt::Key_F1 && key <= Qt::Key_F24)
        return UINT(VK_F1 + (key - Qt::Key_F1));
    switch (key) {
    case Qt::Key_Space: return VK_SPACE;
    case Qt::Key_Tab: return VK_TAB;
    case Qt::Key_Escape: return VK_ESCAPE;
    case Qt::Key_Return:
    case Qt::Key_Enter: return VK_RETURN;
    case Qt::Key_Backspace: return VK_BACK;
    case Qt::Key_Delete: return VK_DELETE;
    case Qt::Key_Insert: return VK_INSERT;
    case Qt::Key_Home: return VK_HOME;
    case Qt::Key_End: return VK_END;
    case Qt::Key_PageUp: return VK_PRIOR;
    case Qt::Key_PageDown: return VK_NEXT;
    case Qt::Key_Left: return VK_LEFT;
    case Qt::Key_Right: return VK_RIGHT;
    case Qt::Key_Up: return VK_UP;
    case Qt::Key_Down: return VK_DOWN;
    case Qt::Key_Plus:
    case Qt::Key_Equal: return VK_OEM_PLUS;
    case Qt::Key_Minus: return VK_OEM_MINUS;
    case Qt::Key_Comma: return VK_OEM_COMMA;
    case Qt::Key_Period: return VK_OEM_PERIOD;
    default: return 0;
    }
}
#endif

} // namespace

#if defined(Q_OS_WIN)
namespace {
Md3NativeShell *g_shellForWnd = nullptr;
const wchar_t kMd3ShellWndClass[] = L"Md3NativeShellMsgWnd";

LRESULT CALLBACK md3ShellWndProc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam)
{
    if (g_shellForWnd) {
        if (msg == WM_HOTKEY) {
            g_shellForWnd->handleHotkey(int(wParam));
            return 0;
        }
        if (msg == WM_POWERBROADCAST) {
            g_shellForWnd->handlePowerBroadcast(quintptr(wParam));
            return TRUE;
        }
        if (msg == WM_WTSSESSION_CHANGE) {
            g_shellForWnd->handleSessionChange(quintptr(wParam));
            return 0;
        }
    }
    return DefWindowProcW(hwnd, msg, wParam, lParam);
}
} // namespace
#endif

/// Fallback filter: also catch power/session on Qt-owned windows (e.g. main HWND).
class Md3NativeShellFilter : public QAbstractNativeEventFilter
{
public:
    explicit Md3NativeShellFilter(Md3NativeShell *owner)
        : m_owner(owner)
    {
    }

    bool nativeEventFilter(const QByteArray &eventType, void *message, qintptr *result) override
    {
#if defined(Q_OS_WIN)
        Q_UNUSED(eventType)
        auto *msg = static_cast<MSG *>(message);
        if (!msg || !m_owner)
            return false;
        if (msg->message == WM_POWERBROADCAST) {
            m_owner->handlePowerBroadcast(quintptr(msg->wParam));
            if (result)
                *result = TRUE;
            return false; // let Qt continue
        }
        if (msg->message == WM_WTSSESSION_CHANGE) {
            m_owner->handleSessionChange(quintptr(msg->wParam));
            if (result)
                *result = 0;
            return false;
        }
#else
        Q_UNUSED(eventType)
        Q_UNUSED(message)
        Q_UNUSED(result)
#endif
        return false;
    }

    Md3NativeShell *m_owner = nullptr;
};

Md3NativeShell::Md3NativeShell(QObject *parent)
    : QObject(parent)
{
    ensureNativeFilter();
    refreshBattery();

    if (qGuiApp) {
        QObject::connect(qGuiApp, &QGuiApplication::applicationStateChanged, this,
                         [this](Qt::ApplicationState state) {
            if (state == Qt::ApplicationSuspended)
                emit suspend();
            else if (state == Qt::ApplicationActive)
                emit resume();
        });
    }
}

Md3NativeShell::~Md3NativeShell()
{
    unregisterAllGlobalShortcuts();
    teardownSingleInstance();
#if defined(Q_OS_WIN)
    if (m_msgHwnd) {
        WTSUnRegisterSessionNotification(static_cast<HWND>(m_msgHwnd));
        DestroyWindow(static_cast<HWND>(m_msgHwnd));
        m_msgHwnd = nullptr;
    }
    if (g_shellForWnd == this)
        g_shellForWnd = nullptr;
#endif
    if (m_filter && qApp) {
        qApp->removeNativeEventFilter(m_filter);
        delete m_filter;
        m_filter = nullptr;
    }
}

Md3NativeShell *Md3NativeShell::create(QQmlEngine *, QJSEngine *)
{
    return new Md3NativeShell;
}

void Md3NativeShell::reportStatus(const QString &status)
{
    if (m_lastStatus == status)
        return;
    m_lastStatus = status;
    emit lastStatusChanged();
}

void Md3NativeShell::ensureNativeFilter()
{
    if (m_filter)
        return;
    m_filter = new Md3NativeShellFilter(this);
    if (qApp)
        qApp->installNativeEventFilter(m_filter);

#if defined(Q_OS_WIN)
    if (!m_msgHwnd) {
        static bool classRegistered = false;
        if (!classRegistered) {
            WNDCLASSW wc{};
            wc.lpfnWndProc = md3ShellWndProc;
            wc.hInstance = GetModuleHandleW(nullptr);
            wc.lpszClassName = kMd3ShellWndClass;
            RegisterClassW(&wc);
            classRegistered = true;
        }
        g_shellForWnd = this;
        m_msgHwnd = CreateWindowExW(0, kMd3ShellWndClass, L"Md3NativeShell",
                                    0, 0, 0, 0, 0, HWND_MESSAGE, nullptr, GetModuleHandleW(nullptr),
                                    nullptr);
        if (m_msgHwnd) {
            WTSRegisterSessionNotification(static_cast<HWND>(m_msgHwnd), NOTIFY_FOR_THIS_SESSION);
        }
    }
#endif
}

void Md3NativeShell::refreshBattery()
{
    bool battery = false;
#if defined(Q_OS_WIN)
    SYSTEM_POWER_STATUS sps{};
    if (GetSystemPowerStatus(&sps)) {
        // 0 = on battery, 1 = AC
        battery = (sps.ACLineStatus == 0);
    }
#endif
    if (m_onBattery == battery)
        return;
    m_onBattery = battery;
    emit powerSourceChanged();
    if (battery)
        emit onBatteryPower();
    else
        emit onAc();
}

void Md3NativeShell::handleHotkey(int nativeId)
{
    const QString id = m_hotkeyToId.value(nativeId);
    if (!id.isEmpty())
        emit globalShortcutActivated(id);
}

void Md3NativeShell::handlePowerBroadcast(quintptr wParam)
{
#if defined(Q_OS_WIN)
    switch (wParam) {
    case PBT_APMSUSPEND:
        emit suspend();
        break;
    case PBT_APMRESUMEAUTOMATIC:
    case PBT_APMRESUMESUSPEND:
        emit resume();
        refreshBattery();
        break;
    case PBT_APMPOWERSTATUSCHANGE:
        refreshBattery();
        break;
    default:
        break;
    }
#else
    Q_UNUSED(wParam)
#endif
}

void Md3NativeShell::handleSessionChange(quintptr wParam)
{
#if defined(Q_OS_WIN)
    switch (wParam) {
    case WTS_SESSION_LOCK:
        emit lockScreen();
        break;
    case WTS_SESSION_UNLOCK:
        emit unlockScreen();
        break;
    default:
        break;
    }
#else
    Q_UNUSED(wParam)
#endif
}

bool Md3NativeShell::requestSingleInstanceLock(const QString &id)
{
    teardownSingleInstance();
    m_singleId = id.trimmed().isEmpty() ? defaultLockId() : id.trimmed();
    const QString key = socketNameFor(m_singleId);

    m_shared = new QSharedMemory(key, this);
    if (!m_shared->create(1)) {
        // Another instance holds the lock — notify it and fail.
        QLocalSocket sock;
        sock.connectToServer(key);
        if (sock.waitForConnected(800)) {
            QByteArray payload = QCoreApplication::arguments().join(QChar(0x1e)).toUtf8();
            sock.write(payload);
            sock.flush();
            sock.waitForBytesWritten(500);
        }
        delete m_shared;
        m_shared = nullptr;
        m_singlePrimary = false;
        emit singleInstanceChanged();
        reportStatus(QStringLiteral("single-instance: secondary (lock held by primary)"));
        return false;
    }

    QLocalServer::removeServer(key);
    m_server = new QLocalServer(this);
    if (!m_server->listen(key)) {
        reportStatus(QStringLiteral("single-instance: listen failed — %1").arg(m_server->errorString()));
    }
    QObject::connect(m_server, &QLocalServer::newConnection, this, [this]() {
        while (m_server && m_server->hasPendingConnections()) {
            QLocalSocket *sock = m_server->nextPendingConnection();
            if (!sock)
                continue;
            QObject::connect(sock, &QLocalSocket::readyRead, this, [this, sock]() {
                const QByteArray data = sock->readAll();
                const QStringList argv = QString::fromUtf8(data).split(QChar(0x1e));
                emit secondInstance(argv);
                focusMainWindow();
                sock->disconnectFromServer();
                sock->deleteLater();
            });
            QObject::connect(sock, &QLocalSocket::disconnected, sock, &QObject::deleteLater);
        }
    });

    m_singlePrimary = true;
    emit singleInstanceChanged();
    reportStatus(QStringLiteral("single-instance: primary (%1)").arg(m_singleId));
    return true;
}

void Md3NativeShell::teardownSingleInstance()
{
    if (m_server) {
        m_server->close();
        m_server->deleteLater();
        m_server = nullptr;
    }
    if (m_shared) {
        if (m_shared->isAttached())
            m_shared->detach();
        delete m_shared;
        m_shared = nullptr;
    }
    if (m_singlePrimary) {
        m_singlePrimary = false;
        emit singleInstanceChanged();
    }
}

void Md3NativeShell::releaseSingleInstanceLock()
{
    teardownSingleInstance();
    reportStatus(QStringLiteral("single-instance: released"));
}

bool Md3NativeShell::openAtLoginSupported() const
{
#if defined(Q_OS_WIN) || defined(Q_OS_LINUX) || defined(Q_OS_MACOS)
#  if defined(Q_OS_ANDROID) || defined(Q_OS_WASM) || defined(Q_OS_IOS)
    return false;
#  else
    return true;
#  endif
#else
    return false;
#endif
}

QString Md3NativeShell::autostartKey() const
{
    return defaultLockId();
}

bool Md3NativeShell::isOpenAtLogin() const
{
#if defined(Q_OS_WIN)
    HKEY key = nullptr;
    if (RegOpenKeyExW(HKEY_CURRENT_USER,
                      L"Software\\Microsoft\\Windows\\CurrentVersion\\Run",
                      0, KEY_READ, &key)
        != ERROR_SUCCESS)
        return false;
    const QString name = autostartKey();
    DWORD type = 0;
    DWORD size = 0;
    const LONG rc = RegQueryValueExW(key, reinterpret_cast<LPCWSTR>(name.utf16()), nullptr, &type,
                                     nullptr, &size);
    RegCloseKey(key);
    return rc == ERROR_SUCCESS && type == REG_SZ;
#elif defined(Q_OS_LINUX) && !defined(Q_OS_ANDROID)
    const QString path = QDir(QStandardPaths::writableLocation(QStandardPaths::ConfigLocation))
                                 .filePath(QStringLiteral("autostart/%1.desktop").arg(autostartKey()));
    return QFileInfo::exists(path);
#elif defined(Q_OS_MACOS)
    const QString path = QDir::home().filePath(
            QStringLiteral("Library/LaunchAgents/%1.plist").arg(autostartKey()));
    return QFileInfo::exists(path);
#else
    return false;
#endif
}

void Md3NativeShell::setOpenAtLogin(bool enabled)
{
    setOpenAtLoginEnabled(enabled, m_openAsHidden);
}

bool Md3NativeShell::setOpenAtLoginEnabled(bool enabled, bool openAsHidden)
{
    m_openAsHidden = openAsHidden;
    if (!openAtLoginSupported()) {
        reportStatus(QStringLiteral("open-at-login: unsupported on this platform"));
        return false;
    }

    const QString exe = QDir::toNativeSeparators(QCoreApplication::applicationFilePath());
#if defined(Q_OS_WIN)
    HKEY key = nullptr;
    if (RegOpenKeyExW(HKEY_CURRENT_USER,
                      L"Software\\Microsoft\\Windows\\CurrentVersion\\Run",
                      0, KEY_SET_VALUE | KEY_QUERY_VALUE, &key)
        != ERROR_SUCCESS) {
        reportStatus(QStringLiteral("open-at-login: cannot open Run key"));
        return false;
    }
    const QString name = autostartKey();
    bool ok = false;
    if (enabled) {
        QString cmd = QStringLiteral("\"%1\"").arg(exe);
        if (openAsHidden)
            cmd += QStringLiteral(" --hidden");
        const std::wstring w = cmd.toStdWString();
        ok = RegSetValueExW(key, reinterpret_cast<LPCWSTR>(name.utf16()), 0, REG_SZ,
                            reinterpret_cast<const BYTE *>(w.c_str()),
                            DWORD((w.size() + 1) * sizeof(wchar_t)))
                == ERROR_SUCCESS;
    } else {
        RegDeleteValueW(key, reinterpret_cast<LPCWSTR>(name.utf16()));
        ok = true;
    }
    RegCloseKey(key);
    emit openAtLoginChanged();
    reportStatus(ok ? (enabled ? QStringLiteral("open-at-login: enabled")
                               : QStringLiteral("open-at-login: disabled"))
                    : QStringLiteral("open-at-login: registry write failed"));
    return ok;
#elif defined(Q_OS_LINUX) && !defined(Q_OS_ANDROID)
    const QString dir = QDir(QStandardPaths::writableLocation(QStandardPaths::ConfigLocation))
                                .filePath(QStringLiteral("autostart"));
    QDir().mkpath(dir);
    const QString path = QDir(dir).filePath(autostartKey() + QStringLiteral(".desktop"));
    if (!enabled) {
        QFile::remove(path);
        emit openAtLoginChanged();
        reportStatus(QStringLiteral("open-at-login: disabled"));
        return true;
    }
    QFile f(path);
    if (!f.open(QIODevice::WriteOnly | QIODevice::Truncate | QIODevice::Text)) {
        reportStatus(QStringLiteral("open-at-login: cannot write desktop file"));
        return false;
    }
    QTextStream out(&f);
    out << "[Desktop Entry]\n";
    out << "Type=Application\n";
    out << "Name=" << QCoreApplication::applicationName() << "\n";
    out << "Exec=" << exe;
    if (openAsHidden)
        out << " --hidden";
    out << "\n";
    out << "X-GNOME-Autostart-enabled=true\n";
    out << "Hidden=false\n";
    f.close();
    emit openAtLoginChanged();
    reportStatus(QStringLiteral("open-at-login: enabled"));
    return true;
#elif defined(Q_OS_MACOS)
    const QString agents = QDir::home().filePath(QStringLiteral("Library/LaunchAgents"));
    QDir().mkpath(agents);
    const QString path = QDir(agents).filePath(autostartKey() + QStringLiteral(".plist"));
    if (!enabled) {
        QFile::remove(path);
        emit openAtLoginChanged();
        reportStatus(QStringLiteral("open-at-login: disabled"));
        return true;
    }
    QFile f(path);
    if (!f.open(QIODevice::WriteOnly | QIODevice::Truncate | QIODevice::Text)) {
        reportStatus(QStringLiteral("open-at-login: cannot write LaunchAgent"));
        return false;
    }
    QTextStream out(&f);
    out << "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
           "<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" "
           "\"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">\n"
           "<plist version=\"1.0\"><dict>\n"
           "<key>Label</key><string>"
        << autostartKey()
        << "</string>\n"
           "<key>ProgramArguments</key><array><string>"
        << exe << "</string>";
    if (openAsHidden)
        out << "<string>--hidden</string>";
    out << "</array>\n"
           "<key>RunAtLoad</key><true/>\n"
           "</dict></plist>\n";
    f.close();
    emit openAtLoginChanged();
    reportStatus(QStringLiteral("open-at-login: enabled"));
    return true;
#else
    Q_UNUSED(enabled)
    Q_UNUSED(openAsHidden)
    return false;
#endif
}

bool Md3NativeShell::globalShortcutSupported() const
{
#if defined(Q_OS_WIN)
    return true;
#else
    return false;
#endif
}

bool Md3NativeShell::registerGlobalShortcut(const QString &id, const QString &accelerator)
{
    if (id.isEmpty() || accelerator.trimmed().isEmpty()) {
        reportStatus(QStringLiteral("global-shortcut: empty id/accelerator"));
        return false;
    }
    if (!globalShortcutSupported()) {
        reportStatus(QStringLiteral("global-shortcut: unsupported (Windows RegisterHotKey only for now)"));
        return false;
    }
    unregisterGlobalShortcut(id);

#if defined(Q_OS_WIN)
    ensureNativeFilter();
    if (!m_msgHwnd) {
        reportStatus(QStringLiteral("global-shortcut: no message HWND"));
        return false;
    }
    const QKeySequence seq(accelerator, QKeySequence::PortableText);
    if (seq.isEmpty()) {
        reportStatus(QStringLiteral("global-shortcut: invalid accelerator"));
        return false;
    }
    const QKeyCombination comb = seq[0];
    const UINT vk = qtKeyToWinVk(int(comb.key()));
    const UINT winMods = qtModsToWin(comb.keyboardModifiers());
    if (!vk) {
        reportStatus(QStringLiteral("global-shortcut: unsupported key"));
        return false;
    }
    const int nativeId = m_nextHotkeyId++;
    if (!RegisterHotKey(static_cast<HWND>(m_msgHwnd), nativeId, winMods, vk)) {
        reportStatus(QStringLiteral("global-shortcut: RegisterHotKey failed (in use?)"));
        return false;
    }
    m_shortcutIds.insert(id, nativeId);
    m_hotkeyToId.insert(nativeId, id);
    reportStatus(QStringLiteral("global-shortcut: registered %1 → %2").arg(id, accelerator));
    return true;
#else
    Q_UNUSED(id)
    Q_UNUSED(accelerator)
    return false;
#endif
}

bool Md3NativeShell::unregisterGlobalShortcut(const QString &id)
{
    if (!m_shortcutIds.contains(id))
        return false;
#if defined(Q_OS_WIN)
    const int nativeId = m_shortcutIds.take(id);
    m_hotkeyToId.remove(nativeId);
    if (m_msgHwnd)
        UnregisterHotKey(static_cast<HWND>(m_msgHwnd), nativeId);
    reportStatus(QStringLiteral("global-shortcut: unregistered %1").arg(id));
    return true;
#else
    m_shortcutIds.remove(id);
    return true;
#endif
}

void Md3NativeShell::unregisterAllGlobalShortcuts()
{
    const QStringList ids = m_shortcutIds.keys();
    for (const QString &id : ids)
        unregisterGlobalShortcut(id);
}

bool Md3NativeShell::protocolClientSupported() const
{
#if defined(Q_OS_WIN) || (defined(Q_OS_LINUX) && !defined(Q_OS_ANDROID))
    return true;
#else
    return false;
#endif
}

QString Md3NativeShell::sanitizeScheme(const QString &scheme) const
{
    QString s = scheme.trimmed().toLower();
    if (s.endsWith(QLatin1Char(':')))
        s.chop(1);
    for (QChar &c : s) {
        const ushort u = c.unicode();
        const bool ok = (u >= 'a' && u <= 'z') || (u >= '0' && u <= '9') || u == '+' || u == '.'
                || u == '-';
        if (!ok)
            return {};
    }
    return s;
}

bool Md3NativeShell::setAsDefaultProtocolClient(const QString &scheme, const QString &path,
                                                const QStringList &args)
{
    const QString s = sanitizeScheme(scheme);
    if (s.isEmpty()) {
        reportStatus(QStringLiteral("protocol: invalid scheme"));
        return false;
    }
    const QString exe = path.trimmed().isEmpty()
            ? QDir::toNativeSeparators(QCoreApplication::applicationFilePath())
            : QDir::toNativeSeparators(path);
#if defined(Q_OS_WIN)
    const QString root = QStringLiteral("Software\\Classes\\%1").arg(s);
    HKEY key = nullptr;
    if (RegCreateKeyExW(HKEY_CURRENT_USER, reinterpret_cast<LPCWSTR>(root.utf16()), 0, nullptr, 0,
                        KEY_SET_VALUE, nullptr, &key, nullptr)
        != ERROR_SUCCESS) {
        reportStatus(QStringLiteral("protocol: cannot create Classes key"));
        return false;
    }
    const QString proto = QStringLiteral("URL:%1 Protocol").arg(s);
    RegSetValueExW(key, nullptr, 0, REG_SZ, reinterpret_cast<const BYTE *>(proto.utf16()),
                   DWORD((proto.size() + 1) * sizeof(wchar_t)));
    const wchar_t empty[] = L"";
    RegSetValueExW(key, L"URL Protocol", 0, REG_SZ, reinterpret_cast<const BYTE *>(empty),
                   sizeof(wchar_t));
    RegCloseKey(key);

    const QString cmdKeyPath = root + QStringLiteral("\\shell\\open\\command");
    if (RegCreateKeyExW(HKEY_CURRENT_USER, reinterpret_cast<LPCWSTR>(cmdKeyPath.utf16()), 0, nullptr,
                        0, KEY_SET_VALUE, nullptr, &key, nullptr)
        != ERROR_SUCCESS) {
        reportStatus(QStringLiteral("protocol: cannot create command key"));
        return false;
    }
    QString cmd = QStringLiteral("\"%1\"").arg(exe);
    for (const QString &a : args) {
        cmd += QLatin1Char(' ');
        cmd += a.contains(QLatin1Char(' ')) ? QStringLiteral("\"%1\"").arg(a) : a;
    }
    cmd += QStringLiteral(" \"%1\"");
    const std::wstring wcmd = cmd.toStdWString();
    const bool ok = RegSetValueExW(key, nullptr, 0, REG_SZ,
                                   reinterpret_cast<const BYTE *>(wcmd.c_str()),
                                   DWORD((wcmd.size() + 1) * sizeof(wchar_t)))
            == ERROR_SUCCESS;
    RegCloseKey(key);
    reportStatus(ok ? QStringLiteral("protocol: registered %1://").arg(s)
                    : QStringLiteral("protocol: write failed"));
    return ok;
#elif defined(Q_OS_LINUX) && !defined(Q_OS_ANDROID)
    const QString apps = QDir(QStandardPaths::writableLocation(QStandardPaths::ApplicationsLocation))
                                 .path();
    QDir().mkpath(apps);
    const QString desktopPath =
            QDir(apps).filePath(QStringLiteral("md3-%1-handler.desktop").arg(s));
    QFile f(desktopPath);
    if (!f.open(QIODevice::WriteOnly | QIODevice::Truncate | QIODevice::Text)) {
        reportStatus(QStringLiteral("protocol: cannot write desktop handler"));
        return false;
    }
    QTextStream out(&f);
    out << "[Desktop Entry]\nType=Application\nName="
        << QCoreApplication::applicationName() << " (" << s << ")\n";
    out << "Exec=" << exe;
    for (const QString &a : args)
        out << ' ' << a;
    out << " %u\n";
    out << "MimeType=x-scheme-handler/" << s << ";\n";
    out << "NoDisplay=true\n";
    f.close();
    QProcess::startDetached(QStringLiteral("xdg-mime"),
                            { QStringLiteral("default"), QFileInfo(desktopPath).fileName(),
                              QStringLiteral("x-scheme-handler/%1").arg(s) });
    reportStatus(QStringLiteral("protocol: registered %1://").arg(s));
    return true;
#else
    Q_UNUSED(args)
    Q_UNUSED(exe)
    reportStatus(QStringLiteral("protocol: unsupported on this platform"));
    return false;
#endif
}

bool Md3NativeShell::removeAsDefaultProtocolClient(const QString &scheme)
{
    const QString s = sanitizeScheme(scheme);
    if (s.isEmpty())
        return false;
#if defined(Q_OS_WIN)
    const QString root = QStringLiteral("Software\\Classes\\%1").arg(s);
    // RegDeleteTree is Vista+
    const LONG rc = RegDeleteTreeW(HKEY_CURRENT_USER, reinterpret_cast<LPCWSTR>(root.utf16()));
    const bool ok = (rc == ERROR_SUCCESS || rc == ERROR_FILE_NOT_FOUND);
    reportStatus(ok ? QStringLiteral("protocol: removed %1://").arg(s)
                    : QStringLiteral("protocol: remove failed"));
    return ok;
#elif defined(Q_OS_LINUX) && !defined(Q_OS_ANDROID)
    const QString apps = QDir(QStandardPaths::writableLocation(QStandardPaths::ApplicationsLocation))
                                 .path();
    const QString desktopPath =
            QDir(apps).filePath(QStringLiteral("md3-%1-handler.desktop").arg(s));
    QFile::remove(desktopPath);
    reportStatus(QStringLiteral("protocol: removed %1://").arg(s));
    return true;
#else
    return false;
#endif
}

bool Md3NativeShell::isDefaultProtocolClient(const QString &scheme) const
{
    const QString s = sanitizeScheme(scheme);
    if (s.isEmpty())
        return false;
#if defined(Q_OS_WIN)
    const QString cmdKeyPath =
            QStringLiteral("Software\\Classes\\%1\\shell\\open\\command").arg(s);
    HKEY key = nullptr;
    if (RegOpenKeyExW(HKEY_CURRENT_USER, reinterpret_cast<LPCWSTR>(cmdKeyPath.utf16()), 0, KEY_READ,
                      &key)
        != ERROR_SUCCESS)
        return false;
    wchar_t buf[1024];
    DWORD size = sizeof(buf);
    DWORD type = 0;
    const LONG rc = RegQueryValueExW(key, nullptr, nullptr, &type, reinterpret_cast<LPBYTE>(buf),
                                     &size);
    RegCloseKey(key);
    if (rc != ERROR_SUCCESS || type != REG_SZ)
        return false;
    const QString cmd = QString::fromWCharArray(buf);
    const QString exe = QDir::toNativeSeparators(QCoreApplication::applicationFilePath());
    return cmd.contains(exe, Qt::CaseInsensitive);
#elif defined(Q_OS_LINUX) && !defined(Q_OS_ANDROID)
    const QString apps = QDir(QStandardPaths::writableLocation(QStandardPaths::ApplicationsLocation))
                                 .path();
    return QFileInfo::exists(
            QDir(apps).filePath(QStringLiteral("md3-%1-handler.desktop").arg(s)));
#else
    return false;
#endif
}

bool Md3NativeShell::powerMonitorSupported() const
{
#if defined(Q_OS_WIN)
    return true;
#else
    return true; // applicationStateChanged at minimum
#endif
}

bool Md3NativeShell::onBattery() const
{
    return m_onBattery;
}

QString Md3NativeShell::userDataPath() const
{
    return getPath(QStringLiteral("userData"));
}

QString Md3NativeShell::cachePath() const
{
    return getPath(QStringLiteral("cache"));
}

QString Md3NativeShell::logsPath() const
{
    return getPath(QStringLiteral("logs"));
}

QString Md3NativeShell::tempPath() const
{
    return getPath(QStringLiteral("temp"));
}

QString Md3NativeShell::exePath() const
{
    return getPath(QStringLiteral("exe"));
}

QString Md3NativeShell::homePath() const
{
    return getPath(QStringLiteral("home"));
}

QString Md3NativeShell::getPath(const QString &name) const
{
    const QString n = name.trimmed().toLower();
    auto appDir = [](QStandardPaths::StandardLocation loc) {
        QString base = QStandardPaths::writableLocation(loc);
        const QString org = QCoreApplication::organizationName();
        const QString app = QCoreApplication::applicationName();
        if (!org.isEmpty())
            base = QDir(base).filePath(org);
        if (!app.isEmpty())
            base = QDir(base).filePath(app);
        QDir().mkpath(base);
        return QDir::toNativeSeparators(base);
    };

    if (n == QLatin1String("home"))
        return QDir::toNativeSeparators(QDir::homePath());
    if (n == QLatin1String("temp") || n == QLatin1String("tmpdir"))
        return QDir::toNativeSeparators(QDir::tempPath());
    if (n == QLatin1String("exe") || n == QLatin1String("execpath"))
        return QDir::toNativeSeparators(QCoreApplication::applicationFilePath());
    if (n == QLatin1String("desktop"))
        return QDir::toNativeSeparators(
                QStandardPaths::writableLocation(QStandardPaths::DesktopLocation));
    if (n == QLatin1String("documents"))
        return QDir::toNativeSeparators(
                QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation));
    if (n == QLatin1String("downloads"))
        return QDir::toNativeSeparators(
                QStandardPaths::writableLocation(QStandardPaths::DownloadLocation));
    if (n == QLatin1String("music"))
        return QDir::toNativeSeparators(
                QStandardPaths::writableLocation(QStandardPaths::MusicLocation));
    if (n == QLatin1String("pictures"))
        return QDir::toNativeSeparators(
                QStandardPaths::writableLocation(QStandardPaths::PicturesLocation));
    if (n == QLatin1String("videos"))
        return QDir::toNativeSeparators(
                QStandardPaths::writableLocation(QStandardPaths::MoviesLocation));
    if (n == QLatin1String("appdata") || n == QLatin1String("userdata")
        || n == QLatin1String("sessiondata"))
        return appDir(QStandardPaths::AppDataLocation);
    if (n == QLatin1String("cache"))
        return appDir(QStandardPaths::CacheLocation);
    if (n == QLatin1String("logs")) {
        const QString p = QDir(appDir(QStandardPaths::AppDataLocation)).filePath(QStringLiteral("logs"));
        QDir().mkpath(p);
        return QDir::toNativeSeparators(p);
    }
    if (n == QLatin1String("crashdumps")) {
        const QString p =
                QDir(appDir(QStandardPaths::AppDataLocation)).filePath(QStringLiteral("Crashpad"));
        QDir().mkpath(p);
        return QDir::toNativeSeparators(p);
    }
    return {};
}

void Md3NativeShell::focusMainWindow()
{
    const auto windows = QGuiApplication::topLevelWindows();
    for (QWindow *w : windows) {
        if (!w || !w->isVisible())
            continue;
        w->show();
        w->raise();
        w->requestActivate();
        return;
    }
}
