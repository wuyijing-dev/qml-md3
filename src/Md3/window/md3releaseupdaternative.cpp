#include "md3releaseupdaternative.h"

#include <QDir>
#include <QFile>
#include <QFileInfo>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QProcess>
#include <QSaveFile>
#include <QStandardPaths>
#include <QUrl>

Md3ReleaseUpdaterNative::Md3ReleaseUpdaterNative(QObject *parent)
    : QObject(parent)
{
}

void Md3ReleaseUpdaterNative::setOwner(const QString &v)
{
    if (m_owner == v)
        return;
    m_owner = v;
    emit ownerChanged();
}

void Md3ReleaseUpdaterNative::setRepo(const QString &v)
{
    if (m_repo == v)
        return;
    m_repo = v;
    emit repoChanged();
}

void Md3ReleaseUpdaterNative::setCurrentVersion(const QString &v)
{
    if (m_currentVersion == v)
        return;
    m_currentVersion = v;
    emit currentVersionChanged();
    emit releaseChanged();
}

void Md3ReleaseUpdaterNative::setIncludePrerelease(bool v)
{
    if (m_includePrerelease == v)
        return;
    m_includePrerelease = v;
    emit includePrereleaseChanged();
}

void Md3ReleaseUpdaterNative::setAssetNameContains(const QString &v)
{
    if (m_assetNameContains == v)
        return;
    m_assetNameContains = v;
    emit assetNameContainsChanged();
}

bool Md3ReleaseUpdaterNative::hasUpdate() const
{
    return compareVersion(m_latestVersion, m_currentVersion) > 0;
}

qreal Md3ReleaseUpdaterNative::downloadProgress() const
{
    if (m_totalBytes <= 0)
        return 0.0;
    return qreal(m_downloadedBytes) / qreal(m_totalBytes);
}

QString Md3ReleaseUpdaterNative::normalizeVersion(const QString &v) const
{
    QString s = v.trimmed();
    if (s.startsWith(QLatin1Char('v'), Qt::CaseInsensitive))
        s.remove(0, 1);
    return s;
}

int Md3ReleaseUpdaterNative::compareVersion(const QString &a, const QString &b) const
{
    const QStringList av = normalizeVersion(a).split(QLatin1Char('.'), Qt::SkipEmptyParts);
    const QStringList bv = normalizeVersion(b).split(QLatin1Char('.'), Qt::SkipEmptyParts);
    const int n = qMax(av.size(), bv.size());
    for (int i = 0; i < n; ++i) {
        const int ai = i < av.size() ? av[i].toInt() : 0;
        const int bi = i < bv.size() ? bv[i].toInt() : 0;
        if (ai > bi)
            return 1;
        if (ai < bi)
            return -1;
    }
    return 0;
}

void Md3ReleaseUpdaterNative::setErrorString(const QString &message)
{
    if (m_errorString == message)
        return;
    m_errorString = message;
    emit errorStringChanged();
}

void Md3ReleaseUpdaterNative::resetReleaseMeta()
{
    m_latestTag.clear();
    m_latestVersion.clear();
    m_latestName.clear();
    m_publishedAt.clear();
    m_releaseNotes.clear();
    m_downloadUrl.clear();
    m_downloadName.clear();
    emit releaseChanged();
}

void Md3ReleaseUpdaterNative::check()
{
    if (m_owner.isEmpty() || m_repo.isEmpty()) {
        setErrorString(tr("Missing owner/repo"));
        emit checkFailed(m_errorString);
        return;
    }

    m_checking = true;
    emit checkingChanged();
    setErrorString(QString());
    resetReleaseMeta();

    const QString url = m_includePrerelease
            ? QStringLiteral("https://api.github.com/repos/%1/%2/releases").arg(m_owner, m_repo)
            : QStringLiteral("https://api.github.com/repos/%1/%2/releases/latest").arg(m_owner, m_repo);

    QNetworkRequest req{QUrl(url)};
    req.setHeader(QNetworkRequest::UserAgentHeader, QStringLiteral("Md3ReleaseUpdater/1.0"));

    QNetworkReply *reply = m_net.get(req);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        m_checking = false;
        emit checkingChanged();

        const QByteArray payload = reply->readAll();
        if (reply->error() != QNetworkReply::NoError) {
            setErrorString(reply->errorString());
            emit checkFailed(m_errorString);
            reply->deleteLater();
            return;
        }

        QJsonParseError parseError;
        const QJsonDocument doc = QJsonDocument::fromJson(payload, &parseError);
        if (parseError.error != QJsonParseError::NoError) {
            setErrorString(tr("Invalid release metadata"));
            emit checkFailed(m_errorString);
            reply->deleteLater();
            return;
        }

        QJsonObject rel;
        if (doc.isArray()) {
            const QJsonArray arr = doc.array();
            for (const QJsonValue &v : arr) {
                const QJsonObject obj = v.toObject();
                if (obj.value(QStringLiteral("prerelease")).toBool() == m_includePrerelease) {
                    rel = obj;
                    break;
                }
            }
            if (rel.isEmpty() && !arr.isEmpty())
                rel = arr.first().toObject();
        } else {
            rel = doc.object();
        }

        if (rel.isEmpty()) {
            setErrorString(tr("No releases found"));
            emit checkFailed(m_errorString);
            reply->deleteLater();
            return;
        }

        m_latestTag = rel.value(QStringLiteral("tag_name")).toString();
        m_latestVersion = normalizeVersion(m_latestTag);
        m_latestName = rel.value(QStringLiteral("name")).toString(m_latestTag);
        m_publishedAt = rel.value(QStringLiteral("published_at")).toString();
        m_releaseNotes = rel.value(QStringLiteral("body")).toString();

        const QJsonArray assets = rel.value(QStringLiteral("assets")).toArray();
        QJsonObject chosenAsset;
        for (const QJsonValue &v : assets) {
            const QJsonObject a = v.toObject();
            const QString name = a.value(QStringLiteral("name")).toString();
            if (m_assetNameContains.isEmpty() || name.contains(m_assetNameContains, Qt::CaseInsensitive)) {
                chosenAsset = a;
                break;
            }
        }
        if (chosenAsset.isEmpty() && !assets.isEmpty())
            chosenAsset = assets.first().toObject();

        m_downloadUrl = chosenAsset.value(QStringLiteral("browser_download_url")).toString();
        m_downloadName = chosenAsset.value(QStringLiteral("name")).toString();
        emit releaseChanged();
        emit checked();
        if (hasUpdate())
            emit updateAvailable(m_latestVersion, m_downloadUrl);
        reply->deleteLater();
    });
}

void Md3ReleaseUpdaterNative::beginDownloadReply(QNetworkReply *reply, const QString &targetPath)
{
    auto *save = new QSaveFile(targetPath, reply);
    if (!save->open(QIODevice::WriteOnly)) {
        setErrorString(tr("Cannot write download file"));
        emit checkFailed(m_errorString);
        reply->abort();
        return;
    }

    connect(reply, &QNetworkReply::readyRead, this, [reply, save]() {
        save->write(reply->readAll());
    });
    connect(reply, &QNetworkReply::downloadProgress, this, [this](qint64 received, qint64 total) {
        m_downloadedBytes = received;
        m_totalBytes = total;
        emit downloadProgressChanged();
    });
    connect(reply, &QNetworkReply::finished, this, [this, reply, save, targetPath]() {
        m_downloading = false;
        emit downloadingChanged();

        if (reply->error() != QNetworkReply::NoError) {
            save->cancelWriting();
            setErrorString(reply->errorString());
            emit checkFailed(m_errorString);
            reply->deleteLater();
            return;
        }

        if (!save->commit()) {
            setErrorString(tr("Failed to finalize download file"));
            emit checkFailed(m_errorString);
            reply->deleteLater();
            return;
        }

        m_downloadedFilePath = targetPath;
        emit downloadedFilePathChanged();
        emit downloadFinished(targetPath);

        if (!m_pendingExtractDir.isEmpty()) {
            const QString dir = m_pendingExtractDir;
            m_pendingExtractDir.clear();
            extractTo(dir);
        }
        reply->deleteLater();
    });
}

void Md3ReleaseUpdaterNative::downloadTo(const QString &directoryPath)
{
    if (m_downloadUrl.isEmpty()) {
        setErrorString(tr("No download URL available"));
        emit checkFailed(m_errorString);
        return;
    }

    QDir dir(directoryPath.isEmpty()
             ? QStandardPaths::writableLocation(QStandardPaths::DownloadLocation)
             : directoryPath);
    if (!dir.exists() && !dir.mkpath(QStringLiteral("."))) {
        setErrorString(tr("Cannot create download directory"));
        emit checkFailed(m_errorString);
        return;
    }
    const QFileInfo dirInfo(dir.absolutePath());
    if (!dirInfo.isReadable() || !dirInfo.isWritable()) {
        setErrorString(tr("Download directory is not writable"));
        emit checkFailed(m_errorString);
        return;
    }

    const QString fileName = m_downloadName.isEmpty()
            ? QStringLiteral("%1-%2.zip").arg(m_repo, m_latestVersion)
            : m_downloadName;
    // Sanitize to avoid path traversal or accidental absolute paths from remote metadata.
    QString safeFileName = QFileInfo(fileName).fileName();
    const QString invalidChars = QStringLiteral("\\/:*?\"<>|");
    for (int i = 0; i < invalidChars.size(); ++i)
        safeFileName.replace(invalidChars.at(i), QLatin1Char('_'));
    while (safeFileName.contains(QStringLiteral("..")))
        safeFileName.replace(QStringLiteral(".."), QStringLiteral("."));
    if (safeFileName.isEmpty())
        safeFileName = QStringLiteral("update.zip");
    const QString targetPath = dir.filePath(safeFileName);

    m_downloading = true;
    m_downloadedBytes = 0;
    m_totalBytes = 0;
    emit downloadingChanged();
    emit downloadProgressChanged();
    setErrorString(QString());

    QNetworkRequest req{QUrl(m_downloadUrl)};
    req.setHeader(QNetworkRequest::UserAgentHeader, QStringLiteral("Md3ReleaseUpdater/1.0"));
    QNetworkReply *reply = m_net.get(req);
    beginDownloadReply(reply, targetPath);
}

void Md3ReleaseUpdaterNative::finishExtractProcess(int exitCode, const QString &targetDir, const QString &stdErr)
{
    m_extracting = false;
    emit extractingChanged();
    if (exitCode != 0) {
        setErrorString(stdErr.isEmpty() ? tr("Archive extraction failed") : stdErr);
        emit checkFailed(m_errorString);
        return;
    }
    m_extractedDirPath = targetDir;
    emit extractedDirPathChanged();
    emit extractFinished(targetDir);
}

void Md3ReleaseUpdaterNative::extractTo(const QString &directoryPath)
{
#if defined(Q_OS_WASM) || defined(MD3_PLATFORM_WASM)
    Q_UNUSED(directoryPath);
    setErrorString(tr("Archive extract is not supported on WebAssembly"));
    emit checkFailed(m_errorString);
    return;
#else
    if (m_downloadedFilePath.isEmpty()) {
        setErrorString(tr("No downloaded archive to extract"));
        emit checkFailed(m_errorString);
        return;
    }
    if (!QFileInfo::exists(m_downloadedFilePath)) {
        setErrorString(tr("Downloaded archive file does not exist"));
        emit checkFailed(m_errorString);
        return;
    }

    if (directoryPath.isEmpty()) {
        setErrorString(tr("Extract directory is empty"));
        emit checkFailed(m_errorString);
        return;
    }

    QDir dir(directoryPath);
    if (!dir.exists() && !dir.mkpath(QStringLiteral("."))) {
        setErrorString(tr("Cannot create extract directory"));
        emit checkFailed(m_errorString);
        return;
    }
    const QFileInfo extractDirInfo(dir.absolutePath());
    if (!extractDirInfo.isWritable()) {
        setErrorString(tr("Extract directory is not writable"));
        emit checkFailed(m_errorString);
        return;
    }

    m_extracting = true;
    emit extractingChanged();
    setErrorString(QString());

    auto *proc = new QProcess(this);
#if defined(Q_OS_WIN)
    const QString program = QStringLiteral("powershell");
    const QStringList args = {
        QStringLiteral("-NoProfile"),
        QStringLiteral("-Command"),
        QStringLiteral("Expand-Archive -Path \"%1\" -DestinationPath \"%2\" -Force")
                .arg(QDir::toNativeSeparators(m_downloadedFilePath),
                     QDir::toNativeSeparators(dir.absolutePath()))
    };
#else
    const QString program = QStringLiteral("tar");
    const QStringList args = {
        QStringLiteral("-xf"),
        m_downloadedFilePath,
        QStringLiteral("-C"),
        dir.absolutePath()
    };
#endif
    proc->start(program, args);
    connect(proc, qOverload<int, QProcess::ExitStatus>(&QProcess::finished),
            this, [this, proc, dir](int exitCode, QProcess::ExitStatus) {
        const QString stdErr = QString::fromLocal8Bit(proc->readAllStandardError()).trimmed();
        proc->deleteLater();
        finishExtractProcess(exitCode, dir.absolutePath(), stdErr);
    });
#endif
}

void Md3ReleaseUpdaterNative::downloadAndExtract(const QString &downloadDirectory, const QString &extractDirectory)
{
    m_pendingExtractDir = extractDirectory;
    downloadTo(downloadDirectory);
}

void Md3ReleaseUpdaterNative::clearDownloadedFile()
{
    if (!m_downloadedFilePath.isEmpty())
        QFile::remove(m_downloadedFilePath);
    m_downloadedFilePath.clear();
    emit downloadedFilePathChanged();
}

