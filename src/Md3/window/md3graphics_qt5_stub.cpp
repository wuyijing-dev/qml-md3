#include "md3graphics.h"

#include <QCoreApplication>
#include <QGuiApplication>
#include <QQuickWindow>

Md3Graphics::Md3Graphics(QObject *parent)
    : QObject(parent)
{
}

void Md3Graphics::applyEarly(int &argc, char **argv)
{
    Q_UNUSED(argc)
    Q_UNUSED(argv)
}

QString Md3Graphics::currentBackend() const
{
    return QStringLiteral("opengl");
}

QString Md3Graphics::preferredBackend() const
{
    return QStringLiteral("auto");
}

void Md3Graphics::setPreferredBackend(const QString &name)
{
    Q_UNUSED(name)
}

QStringList Md3Graphics::availableBackends() const
{
    return { QStringLiteral("auto"), QStringLiteral("opengl") };
}

QString Md3Graphics::platformName() const
{
    return QGuiApplication::platformName();
}

bool Md3Graphics::setBackend(const QString &name)
{
    Q_UNUSED(name)
    return false;
}

QString Md3Graphics::normalizeBackendName(const QString &name) const
{
    const QString n = name.trimmed().toLower();
    if (n.isEmpty())
        return QStringLiteral("auto");
    return n;
}

bool Md3Graphics::isBackendAvailable(const QString &name) const
{
    const QString n = normalizeBackendName(name);
    return n == QLatin1String("auto") || n == QLatin1String("opengl");
}

void Md3Graphics::setAlphaBufferEnabled(bool enabled)
{
    if (m_alphaBuffer == enabled)
        return;
    m_alphaBuffer = enabled;
    QQuickWindow::setDefaultAlphaBuffer(enabled);
    emit alphaBufferChanged();
}
