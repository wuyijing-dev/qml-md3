#include "md3appsettings.h"

#include <QSettings>

Md3AppSettings::Md3AppSettings(QObject *parent)
    : QObject(parent)
{
}

Md3AppSettings::~Md3AppSettings() = default;

void Md3AppSettings::setOrganization(const QString &v)
{
    if (m_org == v)
        return;
    m_org = v;
    m_settings.reset();
    emit organizationChanged();
}

void Md3AppSettings::setApplication(const QString &v)
{
    if (m_app == v)
        return;
    m_app = v;
    m_settings.reset();
    emit applicationChanged();
}

QSettings *Md3AppSettings::settings() const
{
    if (!m_settings)
        m_settings = std::make_unique<QSettings>(m_org, m_app);
    return m_settings.get();
}

QVariant Md3AppSettings::value(const QString &key, const QVariant &defaultValue) const
{
    return settings()->value(key, defaultValue);
}

void Md3AppSettings::setValue(const QString &key, const QVariant &value)
{
    settings()->setValue(key, value);
}

bool Md3AppSettings::contains(const QString &key) const
{
    return settings()->contains(key);
}

void Md3AppSettings::remove(const QString &key)
{
    settings()->remove(key);
}

void Md3AppSettings::sync()
{
    settings()->sync();
}
