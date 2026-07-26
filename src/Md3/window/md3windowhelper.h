#pragma once

#include <QObject>
#include <QRectF>
#include <QString>
#include <QUrl>
#include <QVariantList>
#include <QtQml/qqmlregistration.h>
#include <QVector>

class QWindow;
class Md3WinNativeFilter;

class Md3WindowHelper : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QString platformId READ platformId CONSTANT)
    Q_PROPERTY(bool wayland READ wayland CONSTANT)
    Q_PROPERTY(bool xcb READ xcb CONSTANT)
    Q_PROPERTY(qreal trafficLightsInset READ trafficLightsInset CONSTANT)
    Q_PROPERTY(bool customChromeRecommended READ customChromeRecommended CONSTANT)
    Q_PROPERTY(bool captionButtonsRecommended READ captionButtonsRecommended CONSTANT)
    Q_PROPERTY(bool snapLayoutsSupported READ snapLayoutsSupported CONSTANT)
    Q_PROPERTY(bool systemBackdropSupported READ systemBackdropSupported CONSTANT)
    Q_PROPERTY(bool systemMenuSupported READ systemMenuSupported CONSTANT)
    Q_PROPERTY(bool immersiveDarkModeSupported READ immersiveDarkModeSupported CONSTANT)
    Q_PROPERTY(bool taskbarProgressSupported READ taskbarProgressSupported CONSTANT)
    Q_PROPERTY(bool taskbarOverlaySupported READ taskbarOverlaySupported CONSTANT)
    Q_PROPERTY(bool jumpListSupported READ jumpListSupported CONSTANT)
    Q_PROPERTY(bool thumbBarSupported READ thumbBarSupported CONSTANT)
    Q_PROPERTY(bool iconicThumbnailSupported READ iconicThumbnailSupported CONSTANT)
    Q_PROPERTY(bool systemTraySupported READ systemTraySupported CONSTANT)
    Q_PROPERTY(bool perMonitorDpiV2Supported READ perMonitorDpiV2Supported CONSTANT)
    Q_PROPERTY(bool alwaysOnTopSupported READ alwaysOnTopSupported CONSTANT)
    Q_PROPERTY(bool thumbnailClipSupported READ thumbnailClipSupported CONSTANT)
    Q_PROPERTY(bool applicationRestartSupported READ applicationRestartSupported CONSTANT)
    Q_PROPERTY(bool preferredAppModeSupported READ preferredAppModeSupported CONSTANT)
    Q_PROPERTY(bool windowCloakSupported READ windowCloakSupported CONSTANT)
    Q_PROPERTY(bool systemAccentSupported READ systemAccentSupported CONSTANT)
    Q_PROPERTY(qreal windowCornerRadius READ windowCornerRadius CONSTANT)
    Q_PROPERTY(bool roundedCornersRecommended READ roundedCornersRecommended CONSTANT)

public:
    enum SystemBackdrop {
        BackdropNone = 0,
        BackdropAuto = 1,
        BackdropMica = 2,
        BackdropAcrylic = 3,
        BackdropTabbed = 4
    };
    Q_ENUM(SystemBackdrop)

    enum TaskbarProgressState {
        ProgressNoProgress = 0,
        ProgressIndeterminate = 1,
        ProgressNormal = 2,
        ProgressError = 3,
        ProgressPaused = 4
    };
    Q_ENUM(TaskbarProgressState)

    enum TrayActivation {
        TrayUnknown = 0,
        TrayLeftClick = 1,
        TrayLeftDoubleClick = 2,
        TrayRightClick = 3,
        TrayMiddleClick = 4,
        TrayBalloonShown = 5,
        TrayBalloonClicked = 6,
        TrayBalloonTimeout = 7
    };
    Q_ENUM(TrayActivation)

    explicit Md3WindowHelper(QObject *parent = nullptr);
    ~Md3WindowHelper() override;

    QString platformId() const;
    bool wayland() const;
    bool xcb() const;
    qreal trafficLightsInset() const;
    bool customChromeRecommended() const;
    bool captionButtonsRecommended() const;
    qreal windowCornerRadius() const;
    bool roundedCornersRecommended() const;
    bool snapLayoutsSupported() const;
    bool systemBackdropSupported() const;
    bool systemMenuSupported() const;
    bool immersiveDarkModeSupported() const;
    bool taskbarProgressSupported() const;
    bool taskbarOverlaySupported() const;
    bool jumpListSupported() const;
    bool thumbBarSupported() const;
    bool iconicThumbnailSupported() const;
    bool systemTraySupported() const;
    bool perMonitorDpiV2Supported() const;
    bool alwaysOnTopSupported() const;
    bool thumbnailClipSupported() const;
    bool applicationRestartSupported() const;
    bool preferredAppModeSupported() const;
    bool windowCloakSupported() const;
    bool systemAccentSupported() const;

    Q_INVOKABLE void bindWindow(QObject *window);
    Q_INVOKABLE void unbindWindow(QObject *window);
    Q_INVOKABLE void applyCornerPreference(QObject *window, bool rounded);
    Q_INVOKABLE void setMaximizeButtonRect(QObject *window, qreal x, qreal y, qreal w, qreal h);
    Q_INVOKABLE void clearMaximizeButtonRect(QObject *window);
    Q_INVOKABLE void setCaptionHitRect(QObject *window, qreal x, qreal y, qreal w, qreal h);
    Q_INVOKABLE void clearCaptionHitRect(QObject *window);
    Q_INVOKABLE bool setWindowIcon(QObject *window, const QUrl &iconUrl);
    Q_INVOKABLE void showSystemMenu(QObject *window, qreal globalX, qreal globalY);
    Q_INVOKABLE void setImmersiveDarkMode(QObject *window, bool dark);
    Q_INVOKABLE void setSystemBackdrop(QObject *window, int backdrop);
    Q_INVOKABLE void setBorderColor(QObject *window, const QString &cssColor);
    Q_INVOKABLE void setCaptionTextColor(QObject *window, const QString &cssColor);
    Q_INVOKABLE void flashTaskbar(QObject *window, bool flash = true);

    Q_INVOKABLE bool setAppUserModelId(const QString &appId);
    Q_INVOKABLE void setTaskbarProgress(QObject *window, qreal value, int state = ProgressNormal);
    Q_INVOKABLE void clearTaskbarProgress(QObject *window);
    Q_INVOKABLE bool setTaskbarOverlayIcon(QObject *window, const QUrl &iconUrl, const QString &description = QString());
    Q_INVOKABLE void clearTaskbarOverlayIcon(QObject *window);
    Q_INVOKABLE void setExcludedFromPeek(QObject *window, bool excluded);
    Q_INVOKABLE void setDisallowPeek(QObject *window, bool disallow);
    Q_INVOKABLE void setExcludeFromCapture(QObject *window, bool exclude);

    Q_INVOKABLE bool setJumpListTasks(const QVariantList &tasks);
    Q_INVOKABLE void clearJumpList();

    Q_INVOKABLE bool setThumbBarButtons(QObject *window, const QVariantList &buttons);
    Q_INVOKABLE void clearThumbBarButtons(QObject *window);

    Q_INVOKABLE void setForceIconicRepresentation(QObject *window, bool enabled);
    Q_INVOKABLE bool setIconicThumbnail(QObject *window, const QUrl &imageUrl);
    Q_INVOKABLE void clearIconicThumbnail(QObject *window);

    /// Taskbar live-preview clip (logical coords) / tooltip.
    Q_INVOKABLE void setThumbnailClip(QObject *window, qreal x, qreal y, qreal w, qreal h);
    Q_INVOKABLE void clearThumbnailClip(QObject *window);
    Q_INVOKABLE void setThumbnailTooltip(QObject *window, const QString &text);

    Q_INVOKABLE bool showSystemTrayIcon(QObject *window, const QUrl &iconUrl, const QString &tooltip = QString());
    Q_INVOKABLE void hideSystemTrayIcon();
    Q_INVOKABLE bool showTrayNotification(const QString &title, const QString &body, int timeoutMs = 5000);

    Q_INVOKABLE void setAlwaysOnTop(QObject *window, bool onTop);
    Q_INVOKABLE void setWindowCloaked(QObject *window, bool cloaked);
    Q_INVOKABLE void setPreferredAppMode(bool dark);
    Q_INVOKABLE int monitorCount() const;
    Q_INVOKABLE bool moveToMonitor(QObject *window, int monitorIndex);
    Q_INVOKABLE bool registerApplicationRestart(const QString &commandLineArgs = QString());
    Q_INVOKABLE void unregisterApplicationRestart();

    /// Raise + activate (xdg-activation / focus). Safe on all platforms.
    Q_INVOKABLE void raiseWindow(QObject *window);
    /// Dock/taskbar numeric badge (Unity/Plasma count + Qt setBadgeNumber where available).
    Q_INVOKABLE bool setDockBadge(int count);
    /// Inhibit idle/screensaver (org.freedesktop.ScreenSaver). Linux desktop only.
    Q_INVOKABLE bool setIdleInhibit(bool inhibit, const QString &reason = QString());

    /// Windows accent / wallpaper sampling for Material You seed.
    Q_INVOKABLE QString systemAccentColor() const;
    Q_INVOKABLE QString wallpaperSeedColor() const;

    Q_INVOKABLE qreal devicePixelRatio(QObject *window) const;
    Q_INVOKABLE int windowDpi(QObject *window) const;

    /// When false, QQuickWindow may release the scene graph while not visible (saves GPU memory).
    Q_INVOKABLE void setPersistentSceneGraph(QObject *window, bool persistent);

signals:
    void thumbBarButtonClicked(int buttonId);
    void trayActivated(int reason);
    void dpiChanged(qreal devicePixelRatio, int dpi);

private:
    friend class Md3WinNativeFilter;
    /// Platform-specific teardown (platforms/windows|linux|macos).
    void shutdownNative();
#if defined(Q_OS_WIN)
    void *m_iconBig = nullptr;
    void *m_iconSmall = nullptr;
    void *m_trayIcon = nullptr;
    void *m_trayHwnd = nullptr;
    bool m_trayAdded = false;
    QVector<void *> m_thumbIcons;
    void *m_iconicBitmap = nullptr;
    QUrl m_iconicUrl;
    void clearWinIcons();
    void clearThumbIcons();
    void clearIconicBitmap();
    void handleThumbBarClick(int buttonId);
    void handleTrayMessage(quintptr lParam);
    void handleDpiChanged(QWindow *window);
    bool respondIconicThumbnail(void *hwnd, int width, int height);
    bool respondIconicLivePreview(void *hwnd);
#elif defined(Q_OS_LINUX)
    void *m_linuxTray = nullptr; // QSystemTrayIcon*
#endif
};
