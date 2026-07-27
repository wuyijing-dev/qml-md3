#include "md3appsettings.h"

#include <QSettings>

Md3AppSettings::Md3AppSettings(QObject *parent)
    : QObject(parent)
{
}

void Md3AppSettings::setOrganization(const QString &v)
{
    if (m_org == v)
        return;
    m_org = v;
    emit organizationChanged();
}

void Md3AppSettings::setApplication(const QString &v)
{
    if (m_app == v)
        return;
    m_app = v;
    emit applicationChanged();
}

QVariant Md3AppSettings::value(const QString &key, const QVariant &defaultValue) const
{
    QSettings s(m_org, m_app);
    return s.value(key, defaultValue);
}

void Md3AppSettings::setValue(const QString &key, const QVariant &value)
{
    QSettings s(m_org, m_app);
    s.setValue(key, value);
}

bool Md3AppSettings::contains(const QString &key) const
{
    QSettings s(m_org, m_app);
    return s.contains(key);
}

void Md3AppSettings::remove(const QString &key)
{
    QSettings s(m_org, m_app);
    s.remove(key);
}

void Md3AppSettings::sync()
{
    QSettings s(m_org, m_app);
    s.sync();
}
