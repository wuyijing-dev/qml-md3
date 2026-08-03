#pragma once

#include <QObject>
#include <QString>
#include <QTranslator>
#include <QtQml/qqmlregistration.h>

/// Loads Md3 UI translators and drives Qt.uiLanguage for qsTr retranslation.
class Md3I18n : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

    Q_PROPERTY(QString language READ language WRITE setLanguage NOTIFY languageChanged)
    Q_PROPERTY(QStringList availableLanguages READ availableLanguages CONSTANT)
    /// Bumps on language change (and via bump()). Bind menuModel / palette model to this
    /// so JS arrays of qsTr() strings rebuild after retranslate.
    Q_PROPERTY(int revision READ revision NOTIFY revisionChanged)

public:
    explicit Md3I18n(QObject *parent = nullptr);

    QString language() const { return m_language; }
    void setLanguage(const QString &lang);

    int revision() const { return m_revision; }

    QStringList availableLanguages() const;

    Q_INVOKABLE bool loadLanguage(const QString &lang);
    Q_INVOKABLE QString languageLabel(const QString &lang) const;
    /// Call after app-owned translators install, or when dynamic models must rebuild.
    Q_INVOKABLE void bump();

signals:
    void languageChanged();
    void revisionChanged();

private:
    bool _install(const QString &lang);
    QString m_language = QStringLiteral("en");
    int m_revision = 0;
    QTranslator m_translator;
};
