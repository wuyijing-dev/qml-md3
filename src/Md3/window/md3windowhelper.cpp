#include "md3windowhelper.h"

#if defined(Q_OS_LINUX) && !defined(Q_OS_ANDROID)
#  include "md3linux_p.h"
#endif

#include <QClipboard>
#include <QCursor>
#include <QDesktopServices>
#include <QDir>
#include <QFileInfo>
#include <QGuiApplication>
#include <QPointF>
#include <QQuickWindow>
#include <QScreen>
#include <QStyleHints>
#include <QUrl>
#include <QWindow>

#if defined(Q_OS_WIN)
#  include <shellapi.h>
#  include <shlobj.h>
#  include <windows.h>
#endif

#if defined(Q_OS_ANDROID)
#  include <QJniObject>
#  include <QNativeInterface>
#endif

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

namespace {

QString localPathFromUrl(const QUrl &url)
{
    if (!url.isValid() && url.isEmpty())
        return {};
    QString path = url.toLocalFile();
    if (path.isEmpty()) {
        // QML often passes bare filesystem paths coerced to QUrl without file://
        const QString s = url.toString();
        if (url.isRelative() || url.scheme().isEmpty()
            || url.scheme() == QLatin1String("file")) {
            path = url.path();
            if (path.isEmpty())
                path = s;
#if defined(Q_OS_WIN)
            // QUrl path may be "/C:/..." — strip leading slash before drive.
            if (path.size() >= 3 && path.at(0) == QLatin1Char('/')
                && path.at(2) == QLatin1Char(':'))
                path = path.mid(1);
#endif
        } else {
            path = s;
        }
    }
    return path;
}

#if defined(Q_OS_ANDROID)
QJniObject androidActivity()
{
    return QNativeInterface::QAndroidApplication::context();
}
#endif

} // namespace

bool Md3WindowHelper::openUrl(const QUrl &url)
{
    if (!url.isValid()) {
        reportNativeStatus(QStringLiteral("openUrl：无效 URL"));
        return false;
    }
    const bool ok = QDesktopServices::openUrl(url);
    reportNativeStatus(ok ? QStringLiteral("已用系统打开：%1").arg(url.toDisplayString())
                          : QStringLiteral("系统打开失败：%1").arg(url.toDisplayString()));
    return ok;
}

bool Md3WindowHelper::revealInFolder(const QUrl &pathOrUrl)
{
    const QString path = localPathFromUrl(pathOrUrl);
    if (path.isEmpty()) {
        reportNativeStatus(QStringLiteral("revealInFolder：路径为空"));
        return false;
    }
    const QFileInfo info(path);
#if defined(Q_OS_WIN)
    const QString native = QDir::toNativeSeparators(info.exists() ? info.absoluteFilePath()
                                                                  : QFileInfo(path).absoluteFilePath());
    PIDLIST_ABSOLUTE pidl = ILCreateFromPathW(reinterpret_cast<PCWSTR>(native.utf16()));
    if (pidl) {
        const HRESULT hr = SHOpenFolderAndSelectItems(pidl, 0, nullptr, 0);
        ILFree(pidl);
        if (SUCCEEDED(hr)) {
            reportNativeStatus(QStringLiteral("已在资源管理器中定位"));
            return true;
        }
    }
    const QString folder = info.isDir() ? info.absoluteFilePath() : info.absolutePath();
    const bool ok = QDesktopServices::openUrl(QUrl::fromLocalFile(folder));
    reportNativeStatus(ok ? QStringLiteral("已打开所在文件夹") : QStringLiteral("打开文件夹失败"));
    return ok;
#elif defined(Q_OS_ANDROID)
    // Best-effort: VIEW the parent directory URI when possible.
    const QString folder = info.isDir() ? info.absoluteFilePath() : info.absolutePath();
    const bool ok = QDesktopServices::openUrl(QUrl::fromLocalFile(folder));
    reportNativeStatus(ok ? QStringLiteral("已请求打开文件管理器")
                          : QStringLiteral("Android 无法打开该路径（权限/提供方）"));
    return ok;
#else
    const QString folder = info.isDir() ? info.absoluteFilePath() : info.absolutePath();
    const bool ok = QDesktopServices::openUrl(QUrl::fromLocalFile(folder));
    reportNativeStatus(ok ? QStringLiteral("已在文件管理器中打开目录")
                          : QStringLiteral("打开目录失败"));
    return ok;
#endif
}

void Md3WindowHelper::beep()
{
    QGuiApplication::beep();
    reportNativeStatus(QStringLiteral("系统提示音"));
}

bool Md3WindowHelper::centerOnScreen(QObject *window)
{
    auto *qw = qobject_cast<QWindow *>(window);
    if (!qw || !qw->screen()) {
        reportNativeStatus(QStringLiteral("centerOnScreen：无有效窗口/屏幕"));
        return false;
    }
    const QRect ag = qw->screen()->availableGeometry();
    qw->setPosition(ag.x() + (ag.width() - qw->width()) / 2,
                    ag.y() + (ag.height() - qw->height()) / 2);
    reportNativeStatus(QStringLiteral("窗口已居中"));
    return true;
}

bool Md3WindowHelper::setWindowOpacity(QObject *window, qreal opacity)
{
    auto *qw = qobject_cast<QWindow *>(window);
    if (!qw) {
        reportNativeStatus(QStringLiteral("setWindowOpacity：无有效窗口"));
        return false;
    }
    opacity = qBound(0.0, opacity, 1.0);
    qw->setOpacity(opacity);
    reportNativeStatus(QStringLiteral("窗口透明度 %1").arg(opacity, 0, 'f', 2));
    return true;
}

bool Md3WindowHelper::setVisibleInTaskbar(QObject *window, bool visible)
{
    auto *qw = qobject_cast<QWindow *>(window);
    if (!qw) {
        reportNativeStatus(QStringLiteral("setVisibleInTaskbar：无有效窗口"));
        return false;
    }
#if defined(Q_OS_WIN)
    const HWND hwnd = reinterpret_cast<HWND>(qw->winId());
    if (!hwnd) {
        reportNativeStatus(QStringLiteral("setVisibleInTaskbar：无 HWND"));
        return false;
    }
    LONG_PTR ex = GetWindowLongPtrW(hwnd, GWL_EXSTYLE);
    if (visible) {
        ex = (ex & ~WS_EX_TOOLWINDOW) | WS_EX_APPWINDOW;
    } else {
        ex = (ex & ~WS_EX_APPWINDOW) | WS_EX_TOOLWINDOW;
    }
    SetWindowLongPtrW(hwnd, GWL_EXSTYLE, ex);
    // Refresh taskbar button.
    ShowWindow(hwnd, SW_HIDE);
    ShowWindow(hwnd, SW_SHOW);
    reportNativeStatus(visible ? QStringLiteral("已显示任务栏按钮")
                               : QStringLiteral("已从任务栏隐藏（TOOLWINDOW）"));
    return true;
#elif defined(Q_OS_ANDROID) || defined(Q_OS_IOS) || defined(Q_OS_WASM) || defined(MD3_PLATFORM_WASM)
    Q_UNUSED(visible);
    reportNativeStatus(QStringLiteral("当前平台无桌面任务栏概念"));
    return false;
#else
    // Soft hint: Tool type often omits from taskbar/dock (may change chrome).
    qw->setFlag(Qt::Tool, !visible);
    reportNativeStatus(visible ? QStringLiteral("已请求显示任务栏/Dock 项（Qt::Tool 关闭）")
                               : QStringLiteral("已请求隐藏任务栏/Dock 项（Qt::Tool）"));
    return true;
#endif
}

void Md3WindowHelper::minimizeWindow(QObject *window)
{
    if (auto *qw = qobject_cast<QWindow *>(window)) {
        qw->showMinimized();
        reportNativeStatus(QStringLiteral("窗口已最小化"));
    }
}

void Md3WindowHelper::maximizeWindow(QObject *window)
{
    if (auto *qw = qobject_cast<QWindow *>(window)) {
        qw->showMaximized();
        reportNativeStatus(QStringLiteral("窗口已最大化"));
    }
}

void Md3WindowHelper::restoreWindow(QObject *window)
{
    if (auto *qw = qobject_cast<QWindow *>(window)) {
        qw->showNormal();
        reportNativeStatus(QStringLiteral("窗口已还原"));
    }
}

void Md3WindowHelper::setFullScreen(QObject *window, bool fullScreen)
{
    auto *qw = qobject_cast<QWindow *>(window);
    if (!qw)
        return;
    if (fullScreen)
        qw->showFullScreen();
    else
        qw->showNormal();
    reportNativeStatus(fullScreen ? QStringLiteral("已全屏") : QStringLiteral("已退出全屏"));
}

bool Md3WindowHelper::systemColorSchemeDark() const
{
    if (auto *hints = QGuiApplication::styleHints())
        return hints->colorScheme() == Qt::ColorScheme::Dark;
    return false;
}

bool Md3WindowHelper::shareText(const QString &text, const QString &title)
{
    if (text.isEmpty()) {
        reportNativeStatus(QStringLiteral("shareText：文本为空"));
        return false;
    }
#if defined(Q_OS_ANDROID)
    const QJniObject activity = androidActivity();
    if (!activity.isValid()) {
        reportNativeStatus(QStringLiteral("shareText：无 Activity"));
        return false;
    }
    QJniObject intent("android/content/Intent", "()V");
    intent.callObjectMethod(
            "setAction", "(Ljava/lang/String;)Landroid/content/Intent;",
            QJniObject::fromString(QStringLiteral("android.intent.action.SEND")).object());
    intent.callObjectMethod(
            "setType", "(Ljava/lang/String;)Landroid/content/Intent;",
            QJniObject::fromString(QStringLiteral("text/plain")).object());
    intent.callObjectMethod(
            "putExtra", "(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;",
            QJniObject::fromString(QStringLiteral("android.intent.extra.TEXT")).object(),
            QJniObject::fromString(text).object());
    if (!title.isEmpty()) {
        intent.callObjectMethod(
                "putExtra", "(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;",
                QJniObject::fromString(QStringLiteral("android.intent.extra.SUBJECT")).object(),
                QJniObject::fromString(title).object());
    }
    const QJniObject chooser = QJniObject::callStaticObjectMethod(
            "android/content/Intent", "createChooser",
            "(Landroid/content/Intent;Ljava/lang/CharSequence;)Landroid/content/Intent;",
            intent.object(),
            QJniObject::fromString(title.isEmpty() ? QStringLiteral("Share") : title).object());
    activity.callMethod<void>("startActivity", "(Landroid/content/Intent;)V", chooser.object());
    reportNativeStatus(QStringLiteral("已打开 Android 分享面板"));
    return true;
#else
    Q_UNUSED(title);
    if (QClipboard *clip = QGuiApplication::clipboard()) {
        clip->setText(text);
        reportNativeStatus(QStringLiteral("已复制到剪贴板（桌面分享回退）"));
        return true;
    }
    reportNativeStatus(QStringLiteral("剪贴板不可用"));
    return false;
#endif
}

bool Md3WindowHelper::vibrate(int durationMs)
{
    durationMs = qBound(0, durationMs, 5000);
#if defined(Q_OS_ANDROID)
    const QJniObject activity = androidActivity();
    if (!activity.isValid()) {
        reportNativeStatus(QStringLiteral("vibrate：无 Activity"));
        return false;
    }
    const QJniObject vibrator = activity.callObjectMethod(
            "getSystemService", "(Ljava/lang/String;)Ljava/lang/Object;",
            QJniObject::fromString(QStringLiteral("vibrator")).object());
    if (!vibrator.isValid()) {
        reportNativeStatus(QStringLiteral("vibrate：无 Vibrator 服务"));
        return false;
    }
    // API 26+: VibrationEffect.createOneShot; older: vibrate(long)
    const QJniObject effect = QJniObject::callStaticObjectMethod(
            "android/os/VibrationEffect", "createOneShot", "(JI)Landroid/os/VibrationEffect;",
            jlong(durationMs <= 0 ? 40 : durationMs), jint(-1) /* DEFAULT_AMPLITUDE */);
    if (effect.isValid()) {
        vibrator.callMethod<void>("vibrate", "(Landroid/os/VibrationEffect;)V", effect.object());
    } else {
        vibrator.callMethod<void>("vibrate", "(J)V", jlong(durationMs <= 0 ? 40 : durationMs));
    }
    reportNativeStatus(QStringLiteral("已振动 %1 ms").arg(durationMs <= 0 ? 40 : durationMs));
    return true;
#else
    if (durationMs > 0)
        QGuiApplication::beep();
    reportNativeStatus(QStringLiteral("非 Android：振动回退为提示音"));
    return durationMs > 0;
#endif
}

bool Md3WindowHelper::setImmersiveSystemUi(bool immersive)
{
#if defined(Q_OS_ANDROID)
    const QJniObject activity = androidActivity();
    if (!activity.isValid()) {
        reportNativeStatus(QStringLiteral("setImmersiveSystemUi：无 Activity"));
        return false;
    }
    bool ok = false;
    auto future = QNativeInterface::QAndroidApplication::runOnAndroidMainThread([&]() {
        const QJniObject window = activity.callObjectMethod("getWindow", "()Landroid/view/Window;");
        if (!window.isValid())
            return;
        const QJniObject decor = window.callObjectMethod("getDecorView", "()Landroid/view/View;");
        if (!decor.isValid())
            return;
        // SYSTEM_UI_FLAG_IMMERSIVE_STICKY | HIDE_NAVIGATION | FULLSCREEN
        constexpr jint kImmersiveSticky = 0x00001000;
        constexpr jint kHideNav = 0x00000002;
        constexpr jint kFullscreen = 0x00000004;
        constexpr jint kLayoutStable = 0x00000100;
        constexpr jint kLayoutHideNav = 0x00000200;
        constexpr jint kLayoutFullscreen = 0x00000400;
        const jint flags = immersive
                ? (kImmersiveSticky | kHideNav | kFullscreen | kLayoutStable | kLayoutHideNav
                   | kLayoutFullscreen)
                : 0;
        decor.callMethod<void>("setSystemUiVisibility", "(I)V", flags);
        ok = true;
    });
    future.waitForFinished();
    reportNativeStatus(ok ? (immersive ? QStringLiteral("已启用沉浸式系统栏")
                                       : QStringLiteral("已恢复系统栏"))
                          : QStringLiteral("沉浸式系统栏设置失败"));
    return ok;
#else
    Q_UNUSED(immersive);
    reportNativeStatus(QStringLiteral("沉浸式系统栏仅 Android 可用"));
    return false;
#endif
}

void Md3WindowHelper::requestAttention(QObject *window, bool on)
{
    flashTaskbar(window, on);
}

void Md3WindowHelper::reportNativeStatus(const QString &status)
{
    if (m_lastNativeStatus == status)
        return;
    m_lastNativeStatus = status;
    emit lastNativeStatusChanged();
}
