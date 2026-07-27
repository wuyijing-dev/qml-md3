#pragma once

#include <QObject>
#include <QString>
#include <QStringList>
#include <QtQml/qqmlregistration.h>

class QQmlEngine;

/// Dev-time QML hot reload: watch paths and clear the component cache.
class Md3HotReload : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(bool enabled READ enabled WRITE setEnabled NOTIFY enabledChanged)
    Q_PROPERTY(QStringList watchPaths READ watchPaths WRITE setWatchPaths NOTIFY watchPathsChanged)
    Q_PROPERTY(QString galleryPagesDir READ galleryPagesDir NOTIFY galleryPagesDirChanged)
    Q_PROPERTY(QString md3QmlDir READ md3QmlDir NOTIFY md3QmlDirChanged)

public:
    explicit Md3HotReload(QObject *parent = nullptr);

    bool enabled() const { return m_enabled; }
    void setEnabled(bool on);
    QStringList watchPaths() const { return m_watchPaths; }
    void setWatchPaths(const QStringList &paths);
    QString galleryPagesDir() const { return m_galleryPagesDir; }
    QString md3QmlDir() const { return m_md3QmlDir; }

    Q_INVOKABLE void addWatchPath(const QString &path);
    Q_INVOKABLE void clearComponentCache(QObject *engineOwner);
    Q_INVOKABLE void rediscoverSourceTrees();

signals:
    void enabledChanged();
    void watchPathsChanged();
    void galleryPagesDirChanged();
    void md3QmlDirChanged();
    void reloadRequested(const QString &path);

private:
    void rebuildWatcher();
    void onFileChanged(const QString &path);
    static QString findDirUpwards(const QString &start, const QStringList &candidates);

    bool m_enabled = false;
    QStringList m_watchPaths;
    QString m_galleryPagesDir;
    QString m_md3QmlDir;
    class QFileSystemWatcher *m_watcher = nullptr;
};
