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

public:
    explicit Md3I18n(QObject *parent = nullptr);

    QString language() const { return m_language; }
    void setLanguage(const QString &lang);

    QStringList availableLanguages() const;

    Q_INVOKABLE bool loadLanguage(const QString &lang);
    Q_INVOKABLE QString languageLabel(const QString &lang) const;

signals:
    void languageChanged();

private:
    bool _install(const QString &lang);
    QString m_language = QStringLiteral("en");
    QTranslator m_translator;
};
