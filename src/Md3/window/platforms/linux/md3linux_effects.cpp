#include "md3linux_p.h"

#include <QGuiApplication>
#include <QWindow>

#if defined(MD3_HAVE_KWINDOWSYSTEM)
#  include <KWindowEffects>
#  include <KWindowSystem>
#  include <netwm_def.h>
#endif

// Note: do not use QtGui private QPA headers (not installed on many distros).
// Real blur on Wayland/X11 requires KF6/KF5 WindowSystem when available.

namespace Md3Linux {

bool blurBehindAvailable()
{
#if defined(MD3_HAVE_KWINDOWSYSTEM)
    return KWindowEffects::isEffectAvailable(KWindowEffects::BlurBehind);
#else
    return false;
#endif
}

QString applyBlurBehind(QWindow *window, bool enable)
{
    if (!window)
        return QStringLiteral("无效窗口");

    window->setProperty("_md3_blurBehind", enable);
    window->setProperty("KWinForceBlur", enable);

#if defined(MD3_HAVE_KWINDOWSYSTEM)
    if (KWindowEffects::isEffectAvailable(KWindowEffects::BlurBehind)) {
        KWindowEffects::enableBlurBehind(window, enable);
        if (enable)
            KWindowEffects::enableBackgroundContrast(window, true, 1.0, 1.0, 1.6);
        else
            KWindowEffects::enableBackgroundContrast(window, false);
        return enable ? QStringLiteral("已请求合成器模糊（需 Plasma/KWin 开启 Blur）")
                      : QStringLiteral("已关闭模糊请求");
    }
#endif

    return enable
            ? QStringLiteral("当前环境无模糊协议：仅半透明。Plasma 请安装 libkf6windowsystem-dev 并启用 Blur 特效")
            : QStringLiteral("已关闭半透明背景");
}

QString setKeepAbove(QWindow *window, bool onTop)
{
    if (!window)
        return QStringLiteral("无效窗口");

    window->setFlag(Qt::WindowStaysOnTopHint, onTop);

#if defined(MD3_HAVE_KWINDOWSYSTEM)
    if (onTop)
        KWindowSystem::setState(window->winId(), NET::KeepAbove);
    else
        KWindowSystem::clearState(window->winId(), NET::KeepAbove);
    return onTop ? QStringLiteral("已请求置顶（KWindowSystem KeepAbove）")
                 : QStringLiteral("已取消置顶");
#else
    if (QGuiApplication::platformName().contains(QLatin1String("wayland"), Qt::CaseInsensitive)) {
        return onTop
                ? QStringLiteral("Wayland 下 Qt 置顶常被合成器忽略；Plasma 请安装 KF6WindowSystem 后重编")
                : QStringLiteral("已清除 Qt 置顶标志（Wayland 可能本就无效）");
    }
    return onTop ? QStringLiteral("已设置 Qt::WindowStaysOnTopHint")
                 : QStringLiteral("已取消置顶");
#endif
}

QString forceRaise(QWindow *window)
{
    if (!window)
        return QStringLiteral("无效窗口");

    if (window->windowStates() & Qt::WindowMinimized)
        window->showNormal();
    window->raise();
    window->requestActivate();

#if defined(MD3_HAVE_KWINDOWSYSTEM)
    KWindowSystem::forceActiveWindow(window->winId());
    return QStringLiteral("已调用 forceActiveWindow / raise");
#endif

    if (QGuiApplication::platformName().contains(QLatin1String("wayland"), Qt::CaseInsensitive)) {
        if (window->isActive())
            return QStringLiteral("窗口已在前台；Wayland 禁止抢焦点，故无可见变化");
        return QStringLiteral("已 requestActivate（Wayland 无激活令牌时可能被忽略）");
    }
    return QStringLiteral("已 raise + requestActivate");
}

QString requestAttention(QWindow *window, bool on)
{
    if (!window)
        return QStringLiteral("无效窗口");

    window->alert(on ? 0 : -1);
    QVariantMap props;
    props.insert(QStringLiteral("urgent"), on);
    emitLauncherUpdate(props);

    if (on) {
        notify(QStringLiteral("Md3"),
               window->isActive()
                       ? QStringLiteral("已标记紧急。窗口已在前台时任务栏可能无动画，请切到其他窗口再试。")
                       : QStringLiteral("已请求注意（任务栏紧急 + 通知）"),
               3500);
        return window->isActive()
                ? QStringLiteral("已标记紧急（当前前台，请先切走窗口再观察 Dock）")
                : QStringLiteral("已请求注意");
    }
    notify(QStringLiteral("Md3"), QStringLiteral("已停止注意请求"), 2000);
    return QStringLiteral("已停止注意请求");
}

} // namespace Md3Linux
