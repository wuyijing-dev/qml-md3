#include "md3nativeshell_p.h"
#include "md3nativeshell.h"

#include <QAbstractNativeEventFilter>
#include <QCoreApplication>
#include <QEventLoop>
#include <QGuiApplication>
#include <QHash>
#include <QKeyCombination>
#include <QTimer>
#include <QUuid>
#include <QVariantMap>

#include <QDBusArgument>
#include <QDBusConnection>
#include <QDBusInterface>
#include <QDBusMessage>
#include <QDBusMetaType>
#include <QDBusObjectPath>
#include <QDBusReply>

#include <cstdlib>

#if __has_include(<xcb/xcb.h>)
#  define MD3_HAVE_XCB 1
#  include <xcb/xcb.h>
#endif

namespace {

Md3NativeShell *g_owner = nullptr;

#if defined(MD3_HAVE_XCB)
struct GrabbedKey {
    uint16_t keycode = 0;
    uint16_t modifiers = 0;
};
QHash<int, GrabbedKey> g_grabs;

class Md3XcbHotkeyFilter : public QAbstractNativeEventFilter
{
public:
    bool nativeEventFilter(const QByteArray &eventType, void *message, qintptr *) override
    {
        if (eventType != "xcb_generic_event_t" || !message || !g_owner)
            return false;
        auto *ev = static_cast<xcb_generic_event_t *>(message);
        if ((ev->response_type & 0x7f) != XCB_KEY_PRESS)
            return false;
        auto *kp = reinterpret_cast<xcb_key_press_event_t *>(ev);
        const uint16_t mods = uint16_t(kp->state)
                & uint16_t(XCB_MOD_MASK_SHIFT | XCB_MOD_MASK_CONTROL | XCB_MOD_MASK_1 | XCB_MOD_MASK_4);
        for (auto it = g_grabs.cbegin(); it != g_grabs.cend(); ++it) {
            if (it->keycode == kp->detail && it->modifiers == mods) {
                g_owner->handleHotkey(it.key());
                return true;
            }
        }
        return false;
    }
};
Md3XcbHotkeyFilter *g_xcbFilter = nullptr;

xcb_connection_t *xcbConn()
{
    if (!qGuiApp)
        return nullptr;
    if (auto *x11 = qGuiApp->nativeInterface<QNativeInterface::QX11Application>())
        return x11->connection();
    return nullptr;
}

xcb_window_t xcbRootWindow(xcb_connection_t *c)
{
    const xcb_setup_t *setup = xcb_get_setup(c);
    xcb_screen_iterator_t it = xcb_setup_roots_iterator(setup);
    return it.data ? it.data->root : 0;
}

uint16_t qtModsToXcb(Qt::KeyboardModifiers mods)
{
    uint16_t m = 0;
    if (mods & Qt::ShiftModifier)
        m |= XCB_MOD_MASK_SHIFT;
    if (mods & Qt::ControlModifier)
        m |= XCB_MOD_MASK_CONTROL;
    if (mods & Qt::AltModifier)
        m |= XCB_MOD_MASK_1;
    if (mods & Qt::MetaModifier)
        m |= XCB_MOD_MASK_4;
    return m;
}

uint8_t qtKeyToKeycode(xcb_connection_t *c, int key)
{
    xcb_keycode_t minKc = xcb_get_setup(c)->min_keycode;
    xcb_keycode_t maxKc = xcb_get_setup(c)->max_keycode;
    auto cookie = xcb_get_keyboard_mapping(c, minKc, uint8_t(maxKc - minKc + 1));
    xcb_get_keyboard_mapping_reply_t *reply = xcb_get_keyboard_mapping_reply(c, cookie, nullptr);
    if (!reply)
        return 0;
    const int per = reply->keysyms_per_keycode;
    xcb_keysym_t *syms = xcb_get_keyboard_mapping_keysyms(reply);
    xcb_keysym_t want = 0;
    if (key >= Qt::Key_A && key <= Qt::Key_Z)
        want = xcb_keysym_t('a' + (key - Qt::Key_A));
    else if (key >= Qt::Key_0 && key <= Qt::Key_9)
        want = xcb_keysym_t('0' + (key - Qt::Key_0));
    else if (key >= Qt::Key_F1 && key <= Qt::Key_F12)
        want = 0xffbe + uint32_t(key - Qt::Key_F1);
    else {
        switch (key) {
        case Qt::Key_Space: want = 0x20; break;
        case Qt::Key_Escape: want = 0xff1b; break;
        case Qt::Key_Return:
        case Qt::Key_Enter: want = 0xff0d; break;
        case Qt::Key_Tab: want = 0xff09; break;
        case Qt::Key_Backspace: want = 0xff08; break;
        case Qt::Key_Delete: want = 0xffff; break;
        case Qt::Key_Left: want = 0xff51; break;
        case Qt::Key_Up: want = 0xff52; break;
        case Qt::Key_Right: want = 0xff53; break;
        case Qt::Key_Down: want = 0xff54; break;
        default: break;
        }
    }
    uint8_t found = 0;
    if (want) {
        const int n = (maxKc - minKc + 1) * per;
        for (int i = 0; i < n; ++i) {
            if (syms[i] == want) {
                found = uint8_t(minKc + i / per);
                break;
            }
        }
    }
    free(reply);
    return found;
}

bool grabX11(int nativeId, const QKeySequence &seq)
{
    xcb_connection_t *c = xcbConn();
    if (!c || seq.isEmpty())
        return false;
    const xcb_window_t root = xcbRootWindow(c);
    const QKeyCombination comb = seq[0];
    const uint8_t kc = qtKeyToKeycode(c, int(comb.key()));
    const uint16_t mods = qtModsToXcb(comb.keyboardModifiers());
    if (!kc || !root)
        return false;
    const uint16_t extras[] = { 0, XCB_MOD_MASK_LOCK, XCB_MOD_MASK_2,
                                uint16_t(XCB_MOD_MASK_LOCK | XCB_MOD_MASK_2) };
    for (uint16_t extra : extras) {
        auto cookie = xcb_grab_key_checked(c, 1, root, uint16_t(mods | extra), kc,
                                           XCB_GRAB_MODE_ASYNC, XCB_GRAB_MODE_ASYNC);
        if (xcb_generic_error_t *err = xcb_request_check(c, cookie)) {
            free(err);
            return false;
        }
    }
    g_grabs.insert(nativeId, { kc, mods });
    if (!g_xcbFilter) {
        g_xcbFilter = new Md3XcbHotkeyFilter;
        qApp->installNativeEventFilter(g_xcbFilter);
    }
    return true;
}

void ungrabX11(int nativeId)
{
    if (!g_grabs.contains(nativeId))
        return;
    const GrabbedKey g = g_grabs.take(nativeId);
    xcb_connection_t *c = xcbConn();
    if (!c)
        return;
    const xcb_window_t root = xcbRootWindow(c);
    const uint16_t extras[] = { 0, XCB_MOD_MASK_LOCK, XCB_MOD_MASK_2,
                                uint16_t(XCB_MOD_MASK_LOCK | XCB_MOD_MASK_2) };
    for (uint16_t extra : extras)
        xcb_ungrab_key(c, g.keycode, root, uint16_t(g.modifiers | extra));
    xcb_flush(c);
}
#else
bool grabX11(int, const QKeySequence &) { return false; }
void ungrabX11(int) {}
#endif

QDBusObjectPath g_portalSession;

class PortalRequestWaiter : public QObject
{
    Q_OBJECT
public:
    explicit PortalRequestWaiter(QEventLoop *loop)
        : QObject(loop)
        , m_loop(loop)
    {
    }

    uint code = 2;
    QVariantMap map;

public slots:
    void onResponse(uint response, const QVariantMap &results)
    {
        code = response;
        map = results;
        if (m_loop)
            m_loop->quit();
    }

private:
    QEventLoop *m_loop = nullptr;
};

bool waitRequestResponse(const QDBusObjectPath &requestPath, QVariantMap *results, int timeoutMs)
{
    QEventLoop loop;
    PortalRequestWaiter waiter(&loop);
    const bool okConn = QDBusConnection::sessionBus().connect(
            QStringLiteral("org.freedesktop.portal.Desktop"), requestPath.path(),
            QStringLiteral("org.freedesktop.portal.Request"), QStringLiteral("Response"),
            &waiter, SLOT(onResponse(uint,QVariantMap)));
    if (!okConn)
        return false;
    QTimer::singleShot(timeoutMs, &loop, &QEventLoop::quit);
    loop.exec();
    QDBusConnection::sessionBus().disconnect(
            QStringLiteral("org.freedesktop.portal.Desktop"), requestPath.path(),
            QStringLiteral("org.freedesktop.portal.Request"), QStringLiteral("Response"),
            &waiter, SLOT(onResponse(uint,QVariantMap)));
    if (waiter.code != 0)
        return false;
    if (results)
        *results = waiter.map;
    return true;
}

QString senderToken()
{
    QString s = QDBusConnection::sessionBus().baseService();
    s.remove(QLatin1Char(':'));
    s.replace(QLatin1Char('.'), QLatin1Char('_'));
    return s;
}

bool ensurePortalSession()
{
    if (!g_portalSession.path().isEmpty())
        return true;
    QDBusInterface portal(QStringLiteral("org.freedesktop.portal.Desktop"),
                          QStringLiteral("/org/freedesktop/portal/desktop"),
                          QStringLiteral("org.freedesktop.portal.GlobalShortcuts"),
                          QDBusConnection::sessionBus());
    if (!portal.isValid())
        return false;
    const QString handleToken = QLatin1String("md3_") + QUuid::createUuid().toString(QUuid::Id128);
    const QString sessionToken = QLatin1String("md3s_") + QUuid::createUuid().toString(QUuid::Id128);
    QVariantMap options{ { QStringLiteral("handle_token"), handleToken },
                         { QStringLiteral("session_handle_token"), sessionToken } };
    QDBusReply<QDBusObjectPath> reply = portal.call(QStringLiteral("CreateSession"), options);
    if (!reply.isValid())
        return false;
    QVariantMap results;
    if (waitRequestResponse(reply.value(), &results, 10000)
        && results.contains(QStringLiteral("session_handle"))) {
        g_portalSession = qvariant_cast<QDBusObjectPath>(results.value(QStringLiteral("session_handle")));
    } else {
        g_portalSession = QDBusObjectPath(
                QStringLiteral("/org/freedesktop/portal/desktop/session/%1/%2")
                        .arg(senderToken(), sessionToken));
    }
    return !g_portalSession.path().isEmpty();
}

bool bindPortal(const QString &id, const QKeySequence &seq)
{
    if (!ensurePortalSession())
        return false;

    // a(sa{sv}) via QDBusArgument
    QDBusArgument shortcuts;
    shortcuts.beginArray();
    shortcuts.beginStructure();
    shortcuts << id;
    {
        QVariantMap meta;
        meta.insert(QStringLiteral("description"),
                    QStringLiteral("%1 — %2").arg(id, seq.toString(QKeySequence::NativeText)));
        meta.insert(QStringLiteral("preferred_trigger"), seq.toString(QKeySequence::PortableText));
        shortcuts << meta;
    }
    shortcuts.endStructure();
    shortcuts.endArray();

    QVariantMap options;
    options.insert(QStringLiteral("handle_token"),
                   QLatin1String("md3b_") + QUuid::createUuid().toString(QUuid::Id128));

    QDBusMessage msg = QDBusMessage::createMethodCall(
            QStringLiteral("org.freedesktop.portal.Desktop"),
            QStringLiteral("/org/freedesktop/portal/desktop"),
            QStringLiteral("org.freedesktop.portal.GlobalShortcuts"),
            QStringLiteral("BindShortcuts"));
    msg << QVariant::fromValue(g_portalSession) << QVariant::fromValue(shortcuts) << QString()
        << options;
    const QDBusMessage ret = QDBusConnection::sessionBus().call(msg, QDBus::Block, 5000);
    if (ret.type() == QDBusMessage::ErrorMessage)
        return false;
    if (!ret.arguments().isEmpty()) {
        const auto req = qvariant_cast<QDBusObjectPath>(ret.arguments().at(0));
        QVariantMap results;
        waitRequestResponse(req, &results, 60000);
    }
    return true;
}

class Md3PortalRelay : public QObject
{
    Q_OBJECT
public:
    explicit Md3PortalRelay(Md3NativeShell *owner)
        : m_owner(owner)
    {
        QDBusConnection::sessionBus().connect(
                QStringLiteral("org.freedesktop.portal.Desktop"),
                QStringLiteral("/org/freedesktop/portal/desktop"),
                QStringLiteral("org.freedesktop.portal.GlobalShortcuts"),
                QStringLiteral("Activated"), this,
                SLOT(onActivated(QDBusObjectPath,QString,qulonglong,QVariantMap)));
    }
public slots:
    void onActivated(const QDBusObjectPath &, const QString &shortcutId, qulonglong,
                     const QVariantMap &)
    {
        if (m_owner)
            m_owner->handlePortalShortcut(shortcutId);
    }

private:
    Md3NativeShell *m_owner = nullptr;
};
Md3PortalRelay *g_portalRelay = nullptr;

class Md3LogindWatch : public QObject
{
    Q_OBJECT
public:
    explicit Md3LogindWatch(Md3NativeShell *owner)
        : m_owner(owner)
    {
        QDBusConnection::systemBus().connect(
                QStringLiteral("org.freedesktop.login1"),
                QStringLiteral("/org/freedesktop/login1"),
                QStringLiteral("org.freedesktop.login1.Manager"),
                QStringLiteral("PrepareForSleep"), this, SLOT(onSleep(bool)));
        QDBusInterface manager(QStringLiteral("org.freedesktop.login1"),
                               QStringLiteral("/org/freedesktop/login1"),
                               QStringLiteral("org.freedesktop.login1.Manager"),
                               QDBusConnection::systemBus());
        if (manager.isValid()) {
            QDBusReply<QDBusObjectPath> byPid = manager.call(
                    QStringLiteral("GetSessionByPID"),
                    uint(QCoreApplication::applicationPid()));
            if (byPid.isValid()) {
                m_session = byPid.value().path();
                QDBusConnection::systemBus().connect(
                        QStringLiteral("org.freedesktop.login1"), m_session,
                        QStringLiteral("org.freedesktop.DBus.Properties"),
                        QStringLiteral("PropertiesChanged"), this,
                        SLOT(onProps(QString,QVariantMap,QStringList)));
            }
        }
    }
public slots:
    void onSleep(bool starting)
    {
        if (!m_owner)
            return;
        if (starting)
            emit m_owner->suspend();
        else
            emit m_owner->resume();
    }
    void onProps(const QString &iface, const QVariantMap &changed, const QStringList &)
    {
        if (!m_owner || iface != QLatin1String("org.freedesktop.login1.Session"))
            return;
        if (!changed.contains(QStringLiteral("LockedHint")))
            return;
        if (changed.value(QStringLiteral("LockedHint")).toBool())
            emit m_owner->lockScreen();
        else
            emit m_owner->unlockScreen();
    }

private:
    Md3NativeShell *m_owner = nullptr;
    QString m_session;
};
Md3LogindWatch *g_logind = nullptr;

} // namespace

namespace Md3NativeShellPlatform {

bool globalShortcutSupported()
{
    return true;
}

bool registerGlobalShortcut(Md3NativeShell *owner, const QString &id, const QKeySequence &seq,
                            int nativeId)
{
    g_owner = owner;
    const QString p = QGuiApplication::platformName();
    if (p.contains(QLatin1String("xcb"), Qt::CaseInsensitive) && grabX11(nativeId, seq))
        return true;
    if (!g_portalRelay)
        g_portalRelay = new Md3PortalRelay(owner);
    return bindPortal(id, seq);
}

bool unregisterGlobalShortcut(int nativeId)
{
    ungrabX11(nativeId);
    return true;
}

void shutdownGlobalShortcuts()
{
#if defined(MD3_HAVE_XCB)
    const auto ids = g_grabs.keys();
    for (int id : ids)
        ungrabX11(id);
    if (g_xcbFilter && qApp) {
        qApp->removeNativeEventFilter(g_xcbFilter);
        delete g_xcbFilter;
        g_xcbFilter = nullptr;
    }
#endif
    delete g_portalRelay;
    g_portalRelay = nullptr;
    g_portalSession = {};
    g_owner = nullptr;
}

bool protocolClientSupported()
{
    return false; // main cpp owns Linux .desktop handlers
}

bool setAsDefaultProtocolClient(const QString &, const QString &, const QStringList &, QString *)
{
    return false;
}

bool removeAsDefaultProtocolClient(const QString &, QString *)
{
    return false;
}

bool isDefaultProtocolClient(const QString &)
{
    return false;
}

void installSessionWatch(Md3NativeShell *owner)
{
    if (!g_logind)
        g_logind = new Md3LogindWatch(owner);
}

void uninstallSessionWatch()
{
    delete g_logind;
    g_logind = nullptr;
}

} // namespace Md3NativeShellPlatform

#include "md3linux_nativeshell.moc"
