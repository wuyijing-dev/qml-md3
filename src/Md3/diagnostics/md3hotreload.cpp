#include "md3hotreload.h"

#include <QCoreApplication>
#include <QDir>
#include <QFileInfo>
#include <QFileSystemWatcher>
#include <QQmlEngine>
#include <QtQml>

Md3HotReload::Md3HotReload(QObject *parent)
    : QObject(parent)
    , m_watcher(new QFileSystemWatcher(this))
{
    connect(m_watcher, &QFileSystemWatcher::fileChanged, this, &Md3HotReload::onFileChanged);
    connect(m_watcher, &QFileSystemWatcher::directoryChanged, this, &Md3HotReload::onFileChanged);
    rediscoverSourceTrees();
}

void Md3HotReload::setEnabled(bool on)
{
    if (m_enabled == on)
        return;
    m_enabled = on;
    emit enabledChanged();
    rebuildWatcher();
}

void Md3HotReload::setWatchPaths(const QStringList &paths)
{
    if (m_watchPaths == paths)
        return;
    m_watchPaths = paths;
    emit watchPathsChanged();
    rebuildWatcher();
}

void Md3HotReload::addWatchPath(const QString &path)
{
    if (path.isEmpty() || m_watchPaths.contains(path))
        return;
    m_watchPaths.append(path);
    emit watchPathsChanged();
    rebuildWatcher();
}

void Md3HotReload::clearComponentCache(QObject *engineOwner)
{
    QQmlEngine *engine = nullptr;
    if (engineOwner)
        engine = qmlEngine(engineOwner);
    if (!engine)
        engine = qmlEngine(this);
    if (engine)
        engine->clearComponentCache();
}

void Md3HotReload::rediscoverSourceTrees()
{
    const QString start = QCoreApplication::applicationDirPath();
    const QString gallery = findDirUpwards(start, {
        QStringLiteral("gallery/pages"),
        QStringLiteral("QML_MD3/gallery/pages"),
    });
    const QString md3 = findDirUpwards(start, {
        QStringLiteral("src/Md3"),
        QStringLiteral("QML_MD3/src/Md3"),
    });
    if (m_galleryPagesDir != gallery) {
        m_galleryPagesDir = gallery;
        emit galleryPagesDirChanged();
    }
    if (m_md3QmlDir != md3) {
        m_md3QmlDir = md3;
        emit md3QmlDirChanged();
    }
    if (m_watchPaths.isEmpty()) {
        QStringList defaults;
        if (!gallery.isEmpty())
            defaults << gallery;
        if (!md3.isEmpty())
            defaults << md3;
        if (!defaults.isEmpty())
            setWatchPaths(defaults);
    }
}

QString Md3HotReload::findDirUpwards(const QString &start, const QStringList &candidates)
{
    QDir dir(start);
    for (int i = 0; i < 8; ++i) {
        for (const QString &rel : candidates) {
            const QString p = dir.filePath(rel);
            if (QFileInfo(p).isDir())
                return QDir::cleanPath(p);
        }
        if (!dir.cdUp())
            break;
    }
    // Common absolute fallbacks
    for (const QString &abs : {
             QStringLiteral("D:/QML_MD3/QML_MD3/gallery/pages"),
             QStringLiteral("D:/QML_MD3/QML_MD3/src/Md3"),
         }) {
        for (const QString &rel : candidates) {
            if (abs.endsWith(rel.section(QLatin1Char('/'), -1)) || abs.endsWith(rel)) {
                if (QFileInfo(abs).isDir() && abs.contains(rel.section(QLatin1Char('/'), 0, 0)))
                    return abs;
            }
        }
        if (candidates.contains(QFileInfo(abs).fileName()) && QFileInfo(abs).isDir())
            return abs;
    }
    if (QFileInfo(QStringLiteral("D:/QML_MD3/QML_MD3/gallery/pages")).isDir()
        && candidates.first().contains(QStringLiteral("gallery")))
        return QStringLiteral("D:/QML_MD3/QML_MD3/gallery/pages");
    if (QFileInfo(QStringLiteral("D:/QML_MD3/QML_MD3/src/Md3")).isDir()
        && candidates.first().contains(QStringLiteral("Md3")))
        return QStringLiteral("D:/QML_MD3/QML_MD3/src/Md3");
    return {};
}

void Md3HotReload::rebuildWatcher()
{
    const QStringList old = m_watcher->files() + m_watcher->directories();
    if (!old.isEmpty())
        m_watcher->removePaths(old);
    if (!m_enabled)
        return;

    QStringList toAdd;
    for (const QString &p : std::as_const(m_watchPaths)) {
        if (p.isEmpty() || !QFileInfo::exists(p))
            continue;
        toAdd << p;
        QDir dir(p);
        if (dir.exists()) {
            const auto entries = dir.entryInfoList(
                    {QStringLiteral("*.qml"), QStringLiteral("*.js")},
                    QDir::Files | QDir::NoSymLinks);
            for (const QFileInfo &fi : entries)
                toAdd << fi.absoluteFilePath();
            // One level of subdirs (e.g. pages/scenes)
            const auto subs = dir.entryInfoList(QDir::Dirs | QDir::NoDotAndDotDot);
            for (const QFileInfo &sub : subs) {
                toAdd << sub.absoluteFilePath();
                QDir subDir(sub.absoluteFilePath());
                const auto nested = subDir.entryInfoList(
                        {QStringLiteral("*.qml")}, QDir::Files | QDir::NoSymLinks);
                for (const QFileInfo &fi : nested)
                    toAdd << fi.absoluteFilePath();
            }
        }
    }
    toAdd.removeDuplicates();
    if (!toAdd.isEmpty())
        m_watcher->addPaths(toAdd);
}

void Md3HotReload::onFileChanged(const QString &path)
{
    if (!m_enabled)
        return;
    // Re-add files that editors replace in-place
    if (QFileInfo::exists(path) && !m_watcher->files().contains(path)
        && !m_watcher->directories().contains(path))
        m_watcher->addPath(path);
    emit reloadRequested(path);
}
