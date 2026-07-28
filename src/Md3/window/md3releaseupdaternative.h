#pragma once

#include <QObject>
#include <QNetworkAccessManager>
#include <QPointer>
#include <QtQml/qqmlregistration.h>

class QNetworkReply;

class Md3ReleaseUpdaterNative : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QString owner READ owner WRITE setOwner NOTIFY ownerChanged)
    Q_PROPERTY(QString repo READ repo WRITE setRepo NOTIFY repoChanged)
    Q_PROPERTY(QString currentVersion READ currentVersion WRITE setCurrentVersion NOTIFY currentVersionChanged)
    Q_PROPERTY(bool includePrerelease READ includePrerelease WRITE setIncludePrerelease NOTIFY includePrereleaseChanged)
    Q_PROPERTY(QString assetNameContains READ assetNameContains WRITE setAssetNameContains NOTIFY assetNameContainsChanged)
    Q_PROPERTY(bool checking READ checking NOTIFY checkingChanged)
    Q_PROPERTY(bool downloading READ downloading NOTIFY downloadingChanged)
    Q_PROPERTY(bool extracting READ extracting NOTIFY extractingChanged)
    Q_PROPERTY(QString errorString READ errorString NOTIFY errorStringChanged)
    Q_PROPERTY(QString latestTag READ latestTag NOTIFY releaseChanged)
    Q_PROPERTY(QString latestVersion READ latestVersion NOTIFY releaseChanged)
    Q_PROPERTY(QString latestName READ latestName NOTIFY releaseChanged)
    Q_PROPERTY(QString publishedAt READ publishedAt NOTIFY releaseChanged)
    Q_PROPERTY(QString releaseNotes READ releaseNotes NOTIFY releaseChanged)
    Q_PROPERTY(QString downloadUrl READ downloadUrl NOTIFY releaseChanged)
    Q_PROPERTY(QString downloadName READ downloadName NOTIFY releaseChanged)
    Q_PROPERTY(bool hasUpdate READ hasUpdate NOTIFY releaseChanged)
    Q_PROPERTY(qint64 downloadedBytes READ downloadedBytes NOTIFY downloadProgressChanged)
    Q_PROPERTY(qint64 totalBytes READ totalBytes NOTIFY downloadProgressChanged)
    Q_PROPERTY(qreal downloadProgress READ downloadProgress NOTIFY downloadProgressChanged)
    Q_PROPERTY(QString downloadedFilePath READ downloadedFilePath NOTIFY downloadedFilePathChanged)
    Q_PROPERTY(QString extractedDirPath READ extractedDirPath NOTIFY extractedDirPathChanged)

public:
    explicit Md3ReleaseUpdaterNative(QObject *parent = nullptr);

    QString owner() const { return m_owner; }
    void setOwner(const QString &v);
    QString repo() const { return m_repo; }
    void setRepo(const QString &v);
    QString currentVersion() const { return m_currentVersion; }
    void setCurrentVersion(const QString &v);
    bool includePrerelease() const { return m_includePrerelease; }
    void setIncludePrerelease(bool v);
    QString assetNameContains() const { return m_assetNameContains; }
    void setAssetNameContains(const QString &v);

    bool checking() const { return m_checking; }
    bool downloading() const { return m_downloading; }
    bool extracting() const { return m_extracting; }
    QString errorString() const { return m_errorString; }
    QString latestTag() const { return m_latestTag; }
    QString latestVersion() const { return m_latestVersion; }
    QString latestName() const { return m_latestName; }
    QString publishedAt() const { return m_publishedAt; }
    QString releaseNotes() const { return m_releaseNotes; }
    QString downloadUrl() const { return m_downloadUrl; }
    QString downloadName() const { return m_downloadName; }
    bool hasUpdate() const;
    qint64 downloadedBytes() const { return m_downloadedBytes; }
    qint64 totalBytes() const { return m_totalBytes; }
    qreal downloadProgress() const;
    QString downloadedFilePath() const { return m_downloadedFilePath; }
    QString extractedDirPath() const { return m_extractedDirPath; }

    Q_INVOKABLE void check();
    Q_INVOKABLE void downloadTo(const QString &directoryPath);
    Q_INVOKABLE void extractTo(const QString &directoryPath);
    Q_INVOKABLE void downloadAndExtract(const QString &downloadDirectory, const QString &extractDirectory);
    Q_INVOKABLE void clearDownloadedFile();

signals:
    void ownerChanged();
    void repoChanged();
    void currentVersionChanged();
    void includePrereleaseChanged();
    void assetNameContainsChanged();
    void checkingChanged();
    void downloadingChanged();
    void extractingChanged();
    void errorStringChanged();
    void releaseChanged();
    void downloadProgressChanged();
    void downloadedFilePathChanged();
    void extractedDirPathChanged();

    void checked();
    void updateAvailable(const QString &version, const QString &url);
    void checkFailed(const QString &message);
    void downloadFinished(const QString &filePath);
    void extractFinished(const QString &directoryPath);

private:
    void setErrorString(const QString &message);
    void resetReleaseMeta();
    int compareVersion(const QString &a, const QString &b) const;
    QString normalizeVersion(const QString &v) const;
    void beginDownloadReply(QNetworkReply *reply, const QString &targetPath);
    void finishExtractProcess(int exitCode, const QString &targetDir, const QString &stdErr);

    QNetworkAccessManager m_net;
    QString m_owner;
    QString m_repo;
    QString m_currentVersion;
    bool m_includePrerelease = false;
    QString m_assetNameContains = QStringLiteral(".zip");
    bool m_checking = false;
    bool m_downloading = false;
    bool m_extracting = false;
    QString m_errorString;
    QString m_latestTag;
    QString m_latestVersion;
    QString m_latestName;
    QString m_publishedAt;
    QString m_releaseNotes;
    QString m_downloadUrl;
    QString m_downloadName;
    qint64 m_downloadedBytes = 0;
    qint64 m_totalBytes = 0;
    QString m_downloadedFilePath;
    QString m_extractedDirPath;
    QString m_pendingExtractDir;
};

