#pragma once

#include <QObject>
#include <QString>
#include <QStringList>
#include <QHash>
#include <QtQml/qqmlregistration.h>

class QQmlEngine;
class QJSEngine;
class QLocalServer;
class QSharedMemory;
class QAbstractNativeEventFilter;

/// Electron-parity host helpers: single-instance, open-at-login, global shortcuts,
/// custom protocol clients, power / session signals, and standard paths.
class Md3NativeShell : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

    Q_PROPERTY(bool singleInstancePrimary READ isSingleInstancePrimary NOTIFY singleInstanceChanged)
    Q_PROPERTY(bool openAtLogin READ isOpenAtLogin WRITE setOpenAtLogin NOTIFY openAtLoginChanged)
    Q_PROPERTY(bool openAtLoginSupported READ openAtLoginSupported CONSTANT)
    Q_PROPERTY(bool globalShortcutSupported READ globalShortcutSupported CONSTANT)
    Q_PROPERTY(bool protocolClientSupported READ protocolClientSupported CONSTANT)
    Q_PROPERTY(bool powerMonitorSupported READ powerMonitorSupported CONSTANT)
    Q_PROPERTY(bool onBattery READ onBattery NOTIFY powerSourceChanged)
    Q_PROPERTY(QString lastStatus READ lastStatus NOTIFY lastStatusChanged)

    Q_PROPERTY(QString userDataPath READ userDataPath CONSTANT)
    Q_PROPERTY(QString cachePath READ cachePath CONSTANT)
    Q_PROPERTY(QString logsPath READ logsPath CONSTANT)
    Q_PROPERTY(QString tempPath READ tempPath CONSTANT)
    Q_PROPERTY(QString exePath READ exePath CONSTANT)
    Q_PROPERTY(QString homePath READ homePath CONSTANT)

public:
    explicit Md3NativeShell(QObject *parent = nullptr);
    ~Md3NativeShell() override;

    static Md3NativeShell *create(QQmlEngine *, QJSEngine *);

    bool isSingleInstancePrimary() const { return m_singlePrimary; }
    bool isOpenAtLogin() const;
    void setOpenAtLogin(bool enabled);
    bool openAtLoginSupported() const;
    bool globalShortcutSupported() const;
    bool protocolClientSupported() const;
    bool powerMonitorSupported() const;
    bool onBattery() const;
    QString lastStatus() const { return m_lastStatus; }

    QString userDataPath() const;
    QString cachePath() const;
    QString logsPath() const;
    QString tempPath() const;
    QString exePath() const;
    QString homePath() const;

    /// Electron app.requestSingleInstanceLock — primary keeps lock; secondary emits
    /// nothing here (caller should exit). When a second instance starts, primary
    /// receives secondInstance(argv).
    Q_INVOKABLE bool requestSingleInstanceLock(const QString &id = QString());
    Q_INVOKABLE void releaseSingleInstanceLock();

    /// Electron app.setLoginItemSettings({ openAtLogin })
    Q_INVOKABLE bool setOpenAtLoginEnabled(bool enabled, bool openAsHidden = false);

    /// Electron globalShortcut.register(accelerator) — accelerator like "Ctrl+Shift+K"
    Q_INVOKABLE bool registerGlobalShortcut(const QString &id, const QString &accelerator);
    Q_INVOKABLE bool unregisterGlobalShortcut(const QString &id);
    Q_INVOKABLE void unregisterAllGlobalShortcuts();

    /// Electron app.setAsDefaultProtocolClient(scheme)
    Q_INVOKABLE bool setAsDefaultProtocolClient(const QString &scheme,
                                                const QString &path = QString(),
                                                const QStringList &args = {});
    Q_INVOKABLE bool removeAsDefaultProtocolClient(const QString &scheme);
    Q_INVOKABLE bool isDefaultProtocolClient(const QString &scheme) const;

    /// Electron app.getPath(name): home, appData, userData, temp, exe, desktop,
    /// documents, downloads, music, pictures, videos, logs, cache
    Q_INVOKABLE QString getPath(const QString &name) const;

    /// Bring this process's first top-level window forward (second-instance helper).
    Q_INVOKABLE void focusMainWindow();

    // Called from native WndProc / event filter / portal (not QML API).
    void handleHotkey(int nativeId);
    void handlePortalShortcut(const QString &id);
    void handlePowerBroadcast(quintptr wParam);
    void handleSessionChange(quintptr wParam);

signals:
    void singleInstanceChanged();
    void openAtLoginChanged();
    void powerSourceChanged();
    void lastStatusChanged();
    /// Emitted on the primary instance when another process tried to start.
    void secondInstance(const QStringList &argv);
    void globalShortcutActivated(const QString &id);
    void suspend();
    void resume();
    void lockScreen();
    void unlockScreen();
    void onAc();
    void onBatteryPower();

private:
    void reportStatus(const QString &status);
    void ensureNativeFilter();
    void teardownSingleInstance();
    void refreshBattery();
    QString autostartKey() const;
    QString sanitizeScheme(const QString &scheme) const;

    bool m_singlePrimary = false;
    QString m_singleId;
    QSharedMemory *m_shared = nullptr;
    QLocalServer *m_server = nullptr;
    QString m_lastStatus;
    bool m_onBattery = false;
    bool m_openAsHidden = false;

    QHash<QString, int> m_shortcutIds; // logical id → native hotkey id
    QHash<int, QString> m_hotkeyToId;  // native → logical
    int m_nextHotkeyId = 1;

    QAbstractNativeEventFilter *m_filter = nullptr;
#if defined(Q_OS_WIN)
    void *m_msgHwnd = nullptr; // HWND
#endif
};
