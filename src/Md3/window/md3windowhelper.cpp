#include "md3windowhelper.h"

#if defined(Q_OS_LINUX) && !defined(Q_OS_ANDROID)
#  include "md3linux_p.h"
#endif

#include <QGuiApplication>
#include <QQuickWindow>
#include <QScreen>
#include <QWindow>
#include <QCursor>
#include <QPointF>

Md3WindowHelper::Md3WindowHelper(QObject *parent)
    : QObject(parent)
{
}

Md3WindowHelper::~Md3WindowHelper()
{
    shutdownNative();
}

QString Md3WindowHelper::platformId() const
{
#if defined(Q_OS_WASM) || defined(MD3_PLATFORM_WASM)
    return QStringLiteral("wasm");
#elif defined(Q_OS_ANDROID) || defined(MD3_PLATFORM_ANDROID)
    return QStringLiteral("android");
#elif defined(Q_OS_IOS)
    return QStringLiteral("ios");
#elif defined(Q_OS_WIN)
    return QStringLiteral("windows");
#elif defined(Q_OS_MACOS)
    return QStringLiteral("macos");
#elif defined(Q_OS_LINUX)
    return QStringLiteral("linux");
#else
    return QStringLiteral("unknown");
#endif
}

bool Md3WindowHelper::wayland() const
{
    const QString platform = QGuiApplication::platformName();
    return platform.contains(QLatin1String("wayland"), Qt::CaseInsensitive);
}

bool Md3WindowHelper::xcb() const
{
    const QString platform = QGuiApplication::platformName();
    return platform.contains(QLatin1String("xcb"), Qt::CaseInsensitive)
           || platform.contains(QLatin1String("x11"), Qt::CaseInsensitive);
}

QString Md3WindowHelper::displayServer() const
{
#if defined(Q_OS_LINUX) && !defined(Q_OS_ANDROID)
    if (wayland())
        return QStringLiteral("wayland");
    if (xcb())
        return QStringLiteral("x11");
#endif
    return platformId();
}

qreal Md3WindowHelper::trafficLightsInset() const
{
#if defined(Q_OS_MACOS)
    return 78.0;
#else
    return 0.0;
#endif
}

bool Md3WindowHelper::customChromeRecommended() const
{
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    return false;
#else
    return true;
#endif
}

bool Md3WindowHelper::captionButtonsRecommended() const
{
#if defined(Q_OS_MACOS) || defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    return false;
#else
    return true;
#endif
}

qreal Md3WindowHelper::windowCornerRadius() const
{
#if defined(Q_OS_WIN)
    return 12.0;
#elif defined(Q_OS_MACOS)
    return 10.0;
#elif defined(Q_OS_LINUX)
    return 12.0;
#else
    return 0.0;
#endif
}

bool Md3WindowHelper::roundedCornersRecommended() const
{
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    return false;
#else
    return true;
#endif
}

#define MD3_WIN_ONLY_CAP(name) \
bool Md3WindowHelper::name() const \
{ \
    return platformId() == QLatin1String("windows"); \
}

#define MD3_WIN_OR_LINUX_CAP(name) \
bool Md3WindowHelper::name() const \
{ \
    const QString id = platformId(); \
    return id == QLatin1String("windows") || id == QLatin1String("linux"); \
}

MD3_WIN_ONLY_CAP(snapLayoutsSupported)
MD3_WIN_OR_LINUX_CAP(systemMenuSupported)
MD3_WIN_OR_LINUX_CAP(taskbarProgressSupported)
MD3_WIN_ONLY_CAP(taskbarOverlaySupported)
MD3_WIN_ONLY_CAP(jumpListSupported)
MD3_WIN_ONLY_CAP(thumbBarSupported)
MD3_WIN_ONLY_CAP(iconicThumbnailSupported)
MD3_WIN_OR_LINUX_CAP(perMonitorDpiV2Supported)
MD3_WIN_ONLY_CAP(thumbnailClipSupported)
MD3_WIN_ONLY_CAP(applicationRestartSupported)
MD3_WIN_ONLY_CAP(windowCloakSupported)
MD3_WIN_OR_LINUX_CAP(systemTraySupported)

#undef MD3_WIN_ONLY_CAP
#undef MD3_WIN_OR_LINUX_CAP

bool Md3WindowHelper::systemBackdropSupported() const
{
#if defined(Q_OS_WIN) || defined(Q_OS_MACOS) || (defined(Q_OS_LINUX) && !defined(Q_OS_ANDROID))
    return true;
#else
    return false;
#endif
}

bool Md3WindowHelper::immersiveDarkModeSupported() const
{
#if defined(Q_OS_WIN) || defined(Q_OS_MACOS) || (defined(Q_OS_LINUX) && !defined(Q_OS_ANDROID))
    return true;
#else
    return false;
#endif
}

bool Md3WindowHelper::alwaysOnTopSupported() const
{
#if defined(Q_OS_IOS)
    return false;
#else
    // Android: Qt::WindowStaysOnTopHint (OEM may still ignore).
    return true;
#endif
}

bool Md3WindowHelper::preferredAppModeSupported() const
{
#if defined(Q_OS_WIN) || defined(Q_OS_MACOS) || (defined(Q_OS_LINUX) && !defined(Q_OS_ANDROID))
    return true;
#else
    return false;
#endif
}

bool Md3WindowHelper::systemAccentSupported() const
{
#if defined(Q_OS_WIN) || defined(Q_OS_MACOS) || (defined(Q_OS_LINUX) && !defined(Q_OS_ANDROID))
    return true;
#else
    return false;
#endif
}

qreal Md3WindowHelper::devicePixelRatio(QObject *window) const
{
    auto *qw = qobject_cast<QWindow *>(window);
    return qw ? qw->devicePixelRatio() : qreal(1);
}

int Md3WindowHelper::windowDpi(QObject *window) const
{
    auto *qw = qobject_cast<QWindow *>(window);
    if (!qw || !qw->screen())
        return 96;
#if defined(Q_OS_WIN)
    // Win DPI override lives in platforms/windows (md3GetDpiForWindow) via linkage —
    // keep portable path here; Windows host may refine later if needed.
#endif
    return qRound(qw->screen()->logicalDotsPerInch());
}

void Md3WindowHelper::setPersistentSceneGraph(QObject *window, bool persistent)
{
    auto *qw = qobject_cast<QQuickWindow *>(window);
    if (!qw)
        return;
    qw->setPersistentSceneGraph(persistent);
    qw->setPersistentGraphics(persistent);
}

void Md3WindowHelper::raiseWindow(QObject *window)
{
    auto *qw = qobject_cast<QWindow *>(window);
    if (!qw)
        return;
#if defined(Q_OS_LINUX) && !defined(Q_OS_ANDROID)
    reportNativeStatus(Md3Linux::forceRaise(qw));
#else
    if (qw->windowStates() & Qt::WindowMinimized)
        qw->showNormal();
    qw->raise();
    qw->requestActivate();
#endif
}

QPointF Md3WindowHelper::cursorScreenPos() const
{
    return QCursor::pos();
}

void Md3WindowHelper::reportNativeStatus(const QString &status)
{
    if (m_lastNativeStatus == status)
        return;
    m_lastNativeStatus = status;
    emit lastNativeStatusChanged();
}
