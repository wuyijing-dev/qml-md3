#pragma once

#include <QObject>
#include <QString>
#include <QVariant>
#include <QtQml/qqmlregistration.h>

/// Thin QSettings facade for window / theme / shell / tour persistence.
class Md3AppSettings : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

    Q_PROPERTY(QString organization READ organization WRITE setOrganization NOTIFY organizationChanged)
    Q_PROPERTY(QString application READ application WRITE setApplication NOTIFY applicationChanged)

public:
    explicit Md3AppSettings(QObject *parent = nullptr);

    QString organization() const { return m_org; }
    void setOrganization(const QString &v);
    QString application() const { return m_app; }
    void setApplication(const QString &v);

    Q_INVOKABLE QVariant value(const QString &key, const QVariant &defaultValue = QVariant()) const;
    Q_INVOKABLE void setValue(const QString &key, const QVariant &value);
    Q_INVOKABLE bool contains(const QString &key) const;
    Q_INVOKABLE void remove(const QString &key);
    Q_INVOKABLE void sync();

signals:
    void organizationChanged();
    void applicationChanged();

private:
    QString m_org = QStringLiteral("QML_MD3");
    QString m_app = QStringLiteral("Md3");
};
