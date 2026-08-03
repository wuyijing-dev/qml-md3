#include "md3i18n.h"

#include <QCoreApplication>
#include <QLocale>
#include <QQmlEngine>

Md3I18n::Md3I18n(QObject *parent)
    : QObject(parent)
{
    const QString sys = QLocale::system().name(); // e.g. zh_CN
    if (sys.startsWith(QLatin1String("zh")))
        m_language = QStringLiteral("zh_CN");
    else
        m_language = QStringLiteral("en");
    _install(m_language);
}

QStringList Md3I18n::availableLanguages() const
{
    return { QStringLiteral("en"), QStringLiteral("zh_CN") };
}

QString Md3I18n::languageLabel(const QString &lang) const
{
    if (lang == QLatin1String("zh_CN"))
        return QStringLiteral("简体中文");
    if (lang == QLatin1String("en"))
        return QStringLiteral("English");
    return lang;
}

void Md3I18n::setLanguage(const QString &lang)
{
    loadLanguage(lang);
}

bool Md3I18n::loadLanguage(const QString &lang)
{
    QString code = lang.trimmed();
    if (code.isEmpty())
        code = QStringLiteral("en");
    if (code == QLatin1String("zh") || code == QLatin1String("zh-CN") || code == QLatin1String("zh_Hans"))
        code = QStringLiteral("zh_CN");
    if (!_install(code))
        return false;
    if (m_language == code)
        return true;
    m_language = code;
    emit languageChanged();
    bump();
    return true;
}

void Md3I18n::bump()
{
    ++m_revision;
    emit revisionChanged();
}

bool Md3I18n::_install(const QString &lang)
{
    QCoreApplication *app = QCoreApplication::instance();
    if (!app)
        return false;

    app->removeTranslator(&m_translator);

    // Prefer compiled .qm from module qrc; fall back to empty (source language).
    const QStringList candidates = {
        QStringLiteral(":/md3/i18n/md3_%1.qm").arg(lang),
        QStringLiteral(":/qt/qml/Md3/i18n/md3_%1.qm").arg(lang)
    };

    bool loaded = false;
    for (const QString &path : candidates) {
        if (m_translator.load(path)) {
            loaded = true;
            break;
        }
    }

    // English is the source language — OK with no .qm
    if (!loaded && lang != QLatin1String("en"))
        qWarning("Md3I18n: no translation file for %s (qsTr stays source)", qPrintable(lang));

    if (loaded)
        app->installTranslator(&m_translator);

    QLocale::setDefault(QLocale(lang));

    if (QQmlEngine *eng = qmlEngine(this)) {
        // Drives Qt.uiLanguage so qsTr() re-evaluates with Gallery/app bindings.
        eng->setUiLanguage(lang);
        eng->retranslate();
    }

    return true;
}
