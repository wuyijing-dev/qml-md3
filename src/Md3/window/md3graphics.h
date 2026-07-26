#pragma once

#include <QObject>
#include <QString>
#include <QStringList>
#include <QtQml/qqmlregistration.h>

/// Process-wide Qt Quick RHI backend selection (must apply before the first QQuickWindow).
class Md3Graphics : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

    Q_PROPERTY(QString currentBackend READ currentBackend NOTIFY backendChanged)
    Q_PROPERTY(QString preferredBackend READ preferredBackend WRITE setPreferredBackend
               NOTIFY preferredBackendChanged)
    Q_PROPERTY(QStringList availableBackends READ availableBackends CONSTANT)
    Q_PROPERTY(bool restartRequired READ restartRequired NOTIFY restartRequiredChanged)
    Q_PROPERTY(QString platformName READ platformName CONSTANT)
    Q_PROPERTY(bool alphaBufferEnabled READ alphaBufferEnabled NOTIFY alphaBufferChanged)

public:
    enum Backend {
        Auto = 0,
        D3D11,
        D3D12,
        Vulkan,
        OpenGL,
        OpenGLES,
        Metal,
        Software
    };
    Q_ENUM(Backend)

    explicit Md3Graphics(QObject *parent = nullptr);

    /// Call before QGuiApplication (and before any QQuickWindow).
    static void applyEarly(int &argc, char **argv);

    QString currentBackend() const;
    QString preferredBackend() const;
    void setPreferredBackend(const QString &name);
    QStringList availableBackends() const;
    bool restartRequired() const { return m_restartRequired; }
    QString platformName() const;
    bool alphaBufferEnabled() const { return m_alphaBuffer; }

    /// Prefer translucent frames (Mica / Wayland soft backdrop). Safe before first window.
    Q_INVOKABLE void setAlphaBufferEnabled(bool enabled);

    /// Apply backend now if the scene graph is not running; otherwise store preference.
    /// Returns true if applied immediately.
    Q_INVOKABLE bool setBackend(const QString &name);

    Q_INVOKABLE QString normalizeBackendName(const QString &name) const;
    Q_INVOKABLE bool isBackendAvailable(const QString &name) const;

signals:
    void backendChanged();
    void preferredBackendChanged();
    void restartRequiredChanged();
    void alphaBufferChanged();

private:
    static QString envOrSettingsPreferred();
    static bool applyNamedBackend(const QString &name);
    static QString apiToName(int api);
    void markRestartRequired(bool on);

    bool m_restartRequired = false;
    bool m_alphaBuffer = true;
    QString m_preferred;
};
