#include "md3graphics.h"

#include <QCoreApplication>
#include <QGuiApplication>
#include <QQuickWindow>
#include <QSettings>
#include <QSGRendererInterface>

#include <cstring>

namespace {

QString settingsKey()
{
    return QStringLiteral("graphics/rhiBackend");
}

QString alphaKey()
{
    return QStringLiteral("graphics/alphaBuffer");
}

} // namespace

Md3Graphics::Md3Graphics(QObject *parent)
    : QObject(parent)
{
    m_preferred = envOrSettingsPreferred();
    QSettings s(QStringLiteral("QML_MD3"), QStringLiteral("Md3"));
    if (s.contains(alphaKey()))
        m_alphaBuffer = s.value(alphaKey(), true).toBool();
}

void Md3Graphics::applyEarly(int &argc, char **argv)
{
    QString backend = envOrSettingsPreferred();
    for (int i = 1; i < argc; ++i) {
        const char *a = argv[i];
        if (!a)
            continue;
        if (std::strncmp(a, "--rhi-backend=", 14) == 0) {
            backend = QString::fromUtf8(a + 14);
        } else if (std::strcmp(a, "--rhi-backend") == 0 && i + 1 < argc) {
            backend = QString::fromUtf8(argv[++i]);
        } else if (std::strncmp(a, "--md3-rhi=", 10) == 0) {
            backend = QString::fromUtf8(a + 10);
        }
    }

    QSettings s(QStringLiteral("QML_MD3"), QStringLiteral("Md3"));
    const bool alpha = s.value(alphaKey(), true).toBool();
    QQuickWindow::setDefaultAlphaBuffer(alpha);

    if (!backend.isEmpty() && backend.compare(QLatin1String("auto"), Qt::CaseInsensitive) != 0)
        applyNamedBackend(backend);
}

QString Md3Graphics::envOrSettingsPreferred()
{
    if (qEnvironmentVariableIsSet("MD3_RHI_BACKEND"))
        return qEnvironmentVariable("MD3_RHI_BACKEND").trimmed();
    if (qEnvironmentVariableIsSet("QSG_RHI_BACKEND"))
        return qEnvironmentVariable("QSG_RHI_BACKEND").trimmed();
    QSettings s(QStringLiteral("QML_MD3"), QStringLiteral("Md3"));
    return s.value(settingsKey()).toString().trimmed();
}

QString Md3Graphics::normalizeBackendName(const QString &name) const
{
    const QString n = name.trimmed().toLower();
    if (n.isEmpty() || n == QLatin1String("auto") || n == QLatin1String("default"))
        return QStringLiteral("auto");
    if (n == QLatin1String("d3d") || n == QLatin1String("dx11") || n == QLatin1String("direct3d11"))
        return QStringLiteral("d3d11");
    if (n == QLatin1String("dx12") || n == QLatin1String("direct3d12"))
        return QStringLiteral("d3d12");
    if (n == QLatin1String("gl") || n == QLatin1String("opengl") || n == QLatin1String("desktop"))
        return QStringLiteral("opengl");
    if (n == QLatin1String("gles") || n == QLatin1String("opengles2") || n == QLatin1String("opengles"))
        return QStringLiteral("opengles");
    if (n == QLatin1String("vk") || n == QLatin1String("vulkan"))
        return QStringLiteral("vulkan");
    if (n == QLatin1String("mtl") || n == QLatin1String("metal"))
        return QStringLiteral("metal");
    if (n == QLatin1String("sw") || n == QLatin1String("software") || n == QLatin1String("qpainter"))
        return QStringLiteral("software");
    return n;
}

bool Md3Graphics::applyNamedBackend(const QString &name)
{
    Md3Graphics probe;
    const QString n = probe.normalizeBackendName(name);
    if (n == QLatin1String("auto"))
        return true;

    using Api = QSGRendererInterface::GraphicsApi;
    Api api = QSGRendererInterface::Unknown;
    if (n == QLatin1String("d3d11"))
        api = QSGRendererInterface::Direct3D11;
    else if (n == QLatin1String("d3d12"))
        api = QSGRendererInterface::Direct3D12;
    else if (n == QLatin1String("vulkan"))
        api = QSGRendererInterface::Vulkan;
    else if (n == QLatin1String("opengl"))
        api = QSGRendererInterface::OpenGL;
    else if (n == QLatin1String("opengles"))
        api = QSGRendererInterface::OpenGL; // ES selected by Qt platform
    else if (n == QLatin1String("metal"))
        api = QSGRendererInterface::Metal;
    else if (n == QLatin1String("software"))
        api = QSGRendererInterface::Software;
    else
        return false;

    QQuickWindow::setGraphicsApi(api);
    qputenv("QSG_RHI_BACKEND", n.toUtf8());
    return true;
}

QString Md3Graphics::apiToName(int api)
{
    using Api = QSGRendererInterface::GraphicsApi;
    switch (api) {
    case QSGRendererInterface::Direct3D11: return QStringLiteral("d3d11");
    case QSGRendererInterface::Direct3D12: return QStringLiteral("d3d12");
    case QSGRendererInterface::Vulkan: return QStringLiteral("vulkan");
    case QSGRendererInterface::OpenGL: return QStringLiteral("opengl");
    case QSGRendererInterface::Metal: return QStringLiteral("metal");
    case QSGRendererInterface::Software: return QStringLiteral("software");
    case QSGRendererInterface::Null: return QStringLiteral("null");
    default: break;
    }
    return QStringLiteral("auto");
}

QString Md3Graphics::currentBackend() const
{
    // Prefer live scene graph API from any top-level quick window
    const auto windows = QGuiApplication::allWindows();
    for (QWindow *w : windows) {
        if (auto *qw = qobject_cast<QQuickWindow *>(w)) {
            if (QSGRendererInterface *ri = qw->rendererInterface()) {
                const QString name = apiToName(int(ri->graphicsApi()));
                if (!name.isEmpty() && name != QLatin1String("auto"))
                    return name;
            }
        }
    }
    if (qEnvironmentVariableIsSet("QSG_RHI_BACKEND"))
        return normalizeBackendName(qEnvironmentVariable("QSG_RHI_BACKEND"));
    return m_preferred.isEmpty() ? QStringLiteral("auto") : normalizeBackendName(m_preferred);
}

QString Md3Graphics::preferredBackend() const
{
    return m_preferred.isEmpty() ? QStringLiteral("auto") : normalizeBackendName(m_preferred);
}

void Md3Graphics::setPreferredBackend(const QString &name)
{
    setBackend(name);
}

QStringList Md3Graphics::availableBackends() const
{
    QStringList out{QStringLiteral("auto")};
#if defined(Q_OS_WIN)
    out << QStringLiteral("d3d11") << QStringLiteral("d3d12") << QStringLiteral("vulkan")
        << QStringLiteral("opengl") << QStringLiteral("software");
#elif defined(Q_OS_MACOS)
    out << QStringLiteral("metal") << QStringLiteral("opengl") << QStringLiteral("software");
#else
    // Linux Wayland/X11
    out << QStringLiteral("vulkan") << QStringLiteral("opengl") << QStringLiteral("software");
#endif
    return out;
}

QString Md3Graphics::platformName() const
{
    return QGuiApplication::platformName();
}

bool Md3Graphics::isBackendAvailable(const QString &name) const
{
    const QString n = normalizeBackendName(name);
    return availableBackends().contains(n);
}

void Md3Graphics::setAlphaBufferEnabled(bool enabled)
{
    if (m_alphaBuffer == enabled)
        return;
    m_alphaBuffer = enabled;
    QSettings s(QStringLiteral("QML_MD3"), QStringLiteral("Md3"));
    s.setValue(alphaKey(), enabled);
    // Only effective before the first QQuickWindow — mark restart if windows exist
    if (!QGuiApplication::allWindows().isEmpty())
        markRestartRequired(true);
    else
        QQuickWindow::setDefaultAlphaBuffer(enabled);
    emit alphaBufferChanged();
}

bool Md3Graphics::setBackend(const QString &name)
{
    const QString n = normalizeBackendName(name);
    if (m_preferred != n) {
        m_preferred = n;
        QSettings s(QStringLiteral("QML_MD3"), QStringLiteral("Md3"));
        if (n == QLatin1String("auto"))
            s.remove(settingsKey());
        else
            s.setValue(settingsKey(), n);
        emit preferredBackendChanged();
    }

    const bool hasWindows = !QGuiApplication::allWindows().isEmpty();
    if (hasWindows) {
        markRestartRequired(true);
        return false;
    }

    const bool ok = (n == QLatin1String("auto")) ? true : applyNamedBackend(n);
    if (ok) {
        markRestartRequired(false);
        emit backendChanged();
    }
    return ok;
}

void Md3Graphics::markRestartRequired(bool on)
{
    if (m_restartRequired == on)
        return;
    m_restartRequired = on;
    emit restartRequiredChanged();
}
