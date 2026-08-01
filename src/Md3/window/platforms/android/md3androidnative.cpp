#include "md3windowhelper.h"

#include <QtGlobal>
#include <QGuiApplication>
#include <QIcon>
#include <QScreen>
#include <QStyleHints>
#include <QWindow>

#if defined(Q_OS_ANDROID)
#  include <QJniObject>
#  include <QNativeInterface>
#endif

// Android — system chrome; keep-screen-on, FLAG_SECURE, launcher badge.

namespace {

#if defined(Q_OS_ANDROID)
constexpr jint kFlagKeepScreenOn = 0x00000080; // WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON
constexpr jint kFlagSecure = 0x00002000;       // WindowManager.LayoutParams.FLAG_SECURE

bool applyWindowFlag(jint flag, bool enable, QString *error)
{
    const QJniObject activity = QNativeInterface::QAndroidApplication::context();
    if (!activity.isValid()) {
        if (error)
            *error = QStringLiteral("无有效 Android Context/Activity");
        return false;
    }
    const QJniObject window = activity.callObjectMethod("getWindow", "()Landroid/view/Window;");
    if (!window.isValid()) {
        if (error)
            *error = QStringLiteral("Context.getWindow() 失败（需 Activity）");
        return false;
    }
    if (enable)
        window.callMethod<void>("addFlags", "(I)V", flag);
    else
        window.callMethod<void>("clearFlags", "(I)V", flag);
    return true;
}

template<typename Fn>
void runOnUiThread(Fn &&fn)
{
    auto future = QNativeInterface::QAndroidApplication::runOnAndroidMainThread(std::forward<Fn>(fn));
    future.waitForFinished();
}
#endif

} // namespace

void Md3WindowHelper::shutdownNative() {}

void Md3WindowHelper::bindWindow(QObject *) {}
void Md3WindowHelper::unbindWindow(QObject *) {}
void Md3WindowHelper::setMaximizeButtonRect(QObject *, qreal, qreal, qreal, qreal) {}
void Md3WindowHelper::clearMaximizeButtonRect(QObject *) {}
void Md3WindowHelper::setSnapMaximizeRect(QObject *, qreal, qreal, qreal, qreal) {}
void Md3WindowHelper::clearSnapMaximizeRect(QObject *) {}
void Md3WindowHelper::setSnapLayoutsArmed(QObject *, bool) {}
void Md3WindowHelper::setCaptionHitRect(QObject *, qreal, qreal, qreal, qreal) {}
void Md3WindowHelper::clearCaptionHitRect(QObject *) {}
void Md3WindowHelper::applyCornerPreference(QObject *, bool) {}
void Md3WindowHelper::showSystemMenu(QObject *, qreal, qreal) {}
void Md3WindowHelper::setImmersiveDarkMode(QObject *, bool) {}
void Md3WindowHelper::setSystemBackdrop(QObject *, int) {}
void Md3WindowHelper::setBorderColor(QObject *, const QString &) {}
void Md3WindowHelper::setCaptionTextColor(QObject *, const QString &) {}
void Md3WindowHelper::setExcludedFromPeek(QObject *, bool) {}
void Md3WindowHelper::setDisallowPeek(QObject *, bool) {}

void Md3WindowHelper::setExcludeFromCapture(QObject *, bool exclude)
{
#if defined(Q_OS_ANDROID)
    QString err;
    bool ok = false;
    runOnUiThread([&]() {
        ok = applyWindowFlag(kFlagSecure, exclude, &err);
    });
    if (ok) {
        reportNativeStatus(exclude ? QStringLiteral("已启用 FLAG_SECURE（防截屏/录屏）")
                                   : QStringLiteral("已清除 FLAG_SECURE"));
    } else {
        reportNativeStatus(err.isEmpty() ? QStringLiteral("FLAG_SECURE 失败") : err);
    }
#else
    Q_UNUSED(exclude);
#endif
}

void Md3WindowHelper::setAlwaysOnTop(QObject *window, bool onTop)
{
    if (auto *qw = qobject_cast<QWindow *>(window))
        qw->setFlag(Qt::WindowStaysOnTopHint, onTop);
}

void Md3WindowHelper::setWindowCloaked(QObject *, bool) {}
void Md3WindowHelper::setPreferredAppMode(bool) {}

QString Md3WindowHelper::systemAccentColor() const
{
#if defined(Q_OS_ANDROID)
    const QJniObject activity = QNativeInterface::QAndroidApplication::context();
    if (activity.isValid()) {
        const jint sdk = QJniObject::getStaticField<jint>("android/os/Build$VERSION", "SDK_INT");
        if (sdk >= 31) {
            const jint colorId =
                    QJniObject::getStaticField<jint>("android/R$color", "system_accent1_600");
            if (colorId != 0) {
                const QJniObject res =
                        activity.callObjectMethod("getResources", "()Landroid/content/res/Resources;");
                if (res.isValid()) {
                    const jint c = res.callMethod<jint>("getColor", "(I)I", colorId);
                    if (c != 0) {
                        const quint32 u = quint32(c);
                        return QStringLiteral("#%1")
                                .arg(u & 0xFFFFFFu, 6, 16, QLatin1Char('0'))
                                .toUpper();
                    }
                }
            }
        }
    }
#endif
    return QStringLiteral("#6750A4");
}

QString Md3WindowHelper::wallpaperSeedColor() const
{
    return systemAccentColor();
}

int Md3WindowHelper::monitorCount() const
{
    return QGuiApplication::screens().size();
}

bool Md3WindowHelper::moveToMonitor(QObject *, int)
{
    return false;
}

void Md3WindowHelper::flashTaskbar(QObject *window, bool flash)
{
    if (auto *qw = qobject_cast<QWindow *>(window))
        qw->alert(flash ? 0 : -1);
}

bool Md3WindowHelper::setAppUserModelId(const QString &) { return false; }
void Md3WindowHelper::setTaskbarProgress(QObject *, qreal, int) {}
void Md3WindowHelper::clearTaskbarProgress(QObject *) {}
bool Md3WindowHelper::setTaskbarOverlayIcon(QObject *, const QUrl &, const QString &) { return false; }
void Md3WindowHelper::clearTaskbarOverlayIcon(QObject *) {}
void Md3WindowHelper::setThumbnailClip(QObject *, qreal, qreal, qreal, qreal) {}
void Md3WindowHelper::clearThumbnailClip(QObject *) {}
void Md3WindowHelper::setThumbnailTooltip(QObject *, const QString &) {}
bool Md3WindowHelper::registerApplicationRestart(const QString &) { return false; }
void Md3WindowHelper::unregisterApplicationRestart() {}
bool Md3WindowHelper::setJumpListTasks(const QVariantList &) { return false; }
void Md3WindowHelper::clearJumpList() {}
bool Md3WindowHelper::setThumbBarButtons(QObject *, const QVariantList &) { return false; }
void Md3WindowHelper::clearThumbBarButtons(QObject *) {}
void Md3WindowHelper::setForceIconicRepresentation(QObject *, bool) {}
bool Md3WindowHelper::setIconicThumbnail(QObject *, const QUrl &) { return false; }
void Md3WindowHelper::clearIconicThumbnail(QObject *) {}

bool Md3WindowHelper::setWindowIcon(QObject *window, const QUrl &iconUrl)
{
    auto *qw = qobject_cast<QWindow *>(window);
    if (!qw || !iconUrl.isValid())
        return false;
    QString path = iconUrl.toLocalFile();
    if (path.isEmpty()) {
        if (iconUrl.scheme() == QLatin1String("qrc"))
            path = QLatin1Char(':') + iconUrl.path();
        else
            path = iconUrl.toString();
    }
    const QIcon icon(path);
    if (icon.isNull())
        return false;
    qw->setIcon(icon);
    return true;
}

bool Md3WindowHelper::showSystemTrayIcon(QObject *, const QUrl &, const QString &) { return false; }
void Md3WindowHelper::hideSystemTrayIcon() {}

bool Md3WindowHelper::showTrayNotification(const QString &title, const QString &body, int timeoutMs)
{
    Q_UNUSED(timeoutMs);
#if defined(Q_OS_ANDROID)
    const QJniObject activity = QNativeInterface::QAndroidApplication::context();
    if (!activity.isValid()) {
        reportNativeStatus(QStringLiteral("通知：无 Activity"));
        return false;
    }
    bool ok = false;
    auto future = QNativeInterface::QAndroidApplication::runOnAndroidMainThread([&]() {
        const jint sdk = QJniObject::getStaticField<jint>("android/os/Build$VERSION", "SDK_INT");
        if (sdk >= 26) {
            const QJniObject nm = activity.callObjectMethod(
                    "getSystemService", "(Ljava/lang/String;)Ljava/lang/Object;",
                    QJniObject::fromString(QStringLiteral("notification")).object());
            if (nm.isValid()) {
                const QJniObject channelId = QJniObject::fromString(QStringLiteral("md3_default"));
                const QJniObject name = QJniObject::fromString(QStringLiteral("Md3"));
                QJniObject channel("android/app/NotificationChannel",
                                   "(Ljava/lang/String;Ljava/lang/CharSequence;I)V", channelId.object(),
                                   name.object(), jint(3));
                if (channel.isValid())
                    nm.callMethod<void>("createNotificationChannel",
                                        "(Landroid/app/NotificationChannel;)V", channel.object());
            }
        }
        QJniObject builder;
        if (sdk >= 26) {
            builder = QJniObject("android/app/Notification$Builder",
                                 "(Landroid/content/Context;Ljava/lang/String;)V", activity.object(),
                                 QJniObject::fromString(QStringLiteral("md3_default")).object());
        } else {
            builder = QJniObject("android/app/Notification$Builder", "(Landroid/content/Context;)V",
                                 activity.object());
        }
        if (!builder.isValid())
            return;
        builder.callObjectMethod("setContentTitle",
                                 "(Ljava/lang/CharSequence;)Landroid/app/Notification$Builder;",
                                 QJniObject::fromString(title).object());
        builder.callObjectMethod("setContentText",
                                 "(Ljava/lang/CharSequence;)Landroid/app/Notification$Builder;",
                                 QJniObject::fromString(body).object());
        builder.callObjectMethod("setSmallIcon", "(I)Landroid/app/Notification$Builder;",
                                 jint(0x01080052)); // android.R.drawable.ic_dialog_info
        builder.callObjectMethod("setAutoCancel", "(Z)Landroid/app/Notification$Builder;", jboolean(true));
        const QJniObject notification =
                builder.callObjectMethod("build", "()Landroid/app/Notification;");
        const QJniObject nm = activity.callObjectMethod(
                "getSystemService", "(Ljava/lang/String;)Ljava/lang/Object;",
                QJniObject::fromString(QStringLiteral("notification")).object());
        if (!nm.isValid() || !notification.isValid())
            return;
        nm.callMethod<void>("notify", "(ILandroid/app/Notification;)V", jint(1001),
                            notification.object());
        ok = true;
    });
    future.waitForFinished();
    reportNativeStatus(ok ? QStringLiteral("已发送系统通知") : QStringLiteral("系统通知失败（检查 POST_NOTIFICATIONS）"));
    return ok;
#else
    Q_UNUSED(title)
    Q_UNUSED(body)
    return false;
#endif
}

bool Md3WindowHelper::setDockBadge(int count)
{
    count = qMax(0, count);
#if QT_VERSION >= QT_VERSION_CHECK(6, 5, 0)
    if (auto *app = qGuiApp) {
        app->setBadgeNumber(count);
        reportNativeStatus(count > 0
                                   ? QStringLiteral("已设置启动器角标（setBadgeNumber）")
                                   : QStringLiteral("已清除启动器角标"));
        return true;
    }
#endif
    reportNativeStatus(QStringLiteral("当前 Qt 无 setBadgeNumber，角标不可用"));
    return false;
}

bool Md3WindowHelper::setIdleInhibit(bool inhibit, const QString &reason)
{
    Q_UNUSED(reason);
#if defined(Q_OS_ANDROID)
    QString err;
    bool ok = false;
    runOnUiThread([&]() {
        ok = applyWindowFlag(kFlagKeepScreenOn, inhibit, &err);
    });
    if (ok) {
        reportNativeStatus(inhibit ? QStringLiteral("已保持屏幕常亮（FLAG_KEEP_SCREEN_ON）")
                                   : QStringLiteral("已恢复系统息屏策略"));
        return true;
    }
    reportNativeStatus(err.isEmpty() ? QStringLiteral("息屏抑制失败") : err);
    return false;
#else
    Q_UNUSED(inhibit);
    return false;
#endif
}

bool Md3WindowHelper::blurBehindAvailable() const { return false; }
bool Md3WindowHelper::openBlurSettings() { return false; }
