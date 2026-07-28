#pragma once

#include <QObject>
#include <QPointer>
#include <QString>
#include <QVariantList>
#include <QVector>
#include <QtQml/qqmlregistration.h>
#include <atomic>

class QQuickWindow;
class QTimer;

/// Process FPS / CPU / memory / GPU sampler for Md3PerformancePanel.
class Md3PerformanceMonitor : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(bool active READ active WRITE setActive NOTIFY activeChanged)
    Q_PROPERTY(int historySize READ historySize WRITE setHistorySize NOTIFY historySizeChanged)
    Q_PROPERTY(int sampleIntervalMs READ sampleIntervalMs WRITE setSampleIntervalMs NOTIFY sampleIntervalMsChanged)

    Q_PROPERTY(qreal fps READ fps NOTIFY metricsChanged)
    Q_PROPERTY(qreal frameTimeMs READ frameTimeMs NOTIFY metricsChanged)
    Q_PROPERTY(qreal fpsMin READ fpsMin NOTIFY metricsChanged)
    Q_PROPERTY(qreal fpsMax READ fpsMax NOTIFY metricsChanged)
    Q_PROPERTY(int frameCount READ frameCount NOTIFY metricsChanged)

    /// Primary memory figure aligned with OS UI (Win Task Manager / Linux RSS).
    Q_PROPERTY(qreal memoryMb READ memoryMb NOTIFY metricsChanged)
    Q_PROPERTY(QString memoryLabel READ memoryLabel NOTIFY metricsChanged)
    Q_PROPERTY(qreal workingSetMb READ workingSetMb NOTIFY metricsChanged)
    Q_PROPERTY(qreal privateBytesMb READ privateBytesMb NOTIFY metricsChanged)
    /// Win: private working set. Linux: PSS when available (else RSS).
    Q_PROPERTY(qreal privateWorkingSetMb READ privateWorkingSetMb NOTIFY metricsChanged)

    Q_PROPERTY(qreal cpuPercent READ cpuPercent NOTIFY metricsChanged)
    /// 0–100 process/engine GPU util when available; -1 if unsupported.
    Q_PROPERTY(qreal gpuPercent READ gpuPercent NOTIFY metricsChanged)
    /// Dedicated / process GPU memory in MB; -1 if unknown.
    Q_PROPERTY(qreal gpuMemoryMb READ gpuMemoryMb NOTIFY metricsChanged)
    Q_PROPERTY(bool gpuAvailable READ gpuAvailable NOTIFY metricsChanged)

    Q_PROPERTY(QString platformId READ platformId CONSTANT)
    Q_PROPERTY(QString platformLabel READ platformLabel CONSTANT)
    Q_PROPERTY(QString graphicsApi READ graphicsApi NOTIFY metricsChanged)

    Q_PROPERTY(QVariantList fpsHistory READ fpsHistory NOTIFY metricsChanged)
    Q_PROPERTY(QVariantList memoryHistory READ memoryHistory NOTIFY metricsChanged)
    Q_PROPERTY(QVariantList gpuHistory READ gpuHistory NOTIFY metricsChanged)

public:
    explicit Md3PerformanceMonitor(QObject *parent = nullptr);
    ~Md3PerformanceMonitor() override;

    bool active() const { return m_active; }
    void setActive(bool active);

    int historySize() const { return m_historySize; }
    void setHistorySize(int size);

    int sampleIntervalMs() const { return m_sampleIntervalMs; }
    void setSampleIntervalMs(int ms);

    qreal fps() const { return m_fps; }
    qreal frameTimeMs() const { return m_frameTimeMs; }
    qreal fpsMin() const { return m_fpsMin; }
    qreal fpsMax() const { return m_fpsMax; }
    int frameCount() const { return m_frameCount; }

    qreal memoryMb() const { return m_memoryMb; }
    QString memoryLabel() const { return m_memoryLabel; }
    qreal workingSetMb() const { return m_workingSetMb; }
    qreal privateBytesMb() const { return m_privateBytesMb; }
    qreal privateWorkingSetMb() const { return m_privateWorkingSetMb; }

    qreal cpuPercent() const { return m_cpuPercent; }
    qreal gpuPercent() const { return m_gpuPercent; }
    qreal gpuMemoryMb() const { return m_gpuMemoryMb; }
    bool gpuAvailable() const { return m_gpuAvailable; }

    QString platformId() const;
    QString platformLabel() const;
    QString graphicsApi() const { return m_graphicsApi; }

    QVariantList fpsHistory() const { return m_fpsHistoryVar; }
    QVariantList memoryHistory() const { return m_memHistoryVar; }
    QVariantList gpuHistory() const { return m_gpuHistoryVar; }

    Q_INVOKABLE void bindWindow(QObject *window);
    Q_INVOKABLE void unbindWindow();
    Q_INVOKABLE void reset();

signals:
    void activeChanged();
    void historySizeChanged();
    void sampleIntervalMsChanged();
    void metricsChanged();

private:
    void onFrameSwapped();
    void onSampleTick();
    void pushHistory(QVector<qreal> &hist, qreal value);
    void rebuildHistoryVariants();
    void sampleProcess();
    void sampleGpu();
    void refreshGraphicsApi();
    void syncTimer();

    QPointer<QQuickWindow> m_window;
    QTimer *m_sampleTimer = nullptr;
    bool m_active = false;
    int m_historySize = 24;
    int m_sampleIntervalMs = 1000;

    qreal m_fps = 0;
    qreal m_frameTimeMs = 0;
    qreal m_fpsMin = 0;
    qreal m_fpsMax = 0;
    int m_frameCount = 0;

    qreal m_memoryMb = 0;
    QString m_memoryLabel;
    qreal m_workingSetMb = 0;
    qreal m_privateBytesMb = 0;
    qreal m_privateWorkingSetMb = 0;

    qreal m_cpuPercent = 0;
    qreal m_gpuPercent = -1;
    qreal m_gpuMemoryMb = -1;
    bool m_gpuAvailable = false;
    QString m_graphicsApi;

    QVector<qreal> m_fpsHist;
    QVector<qreal> m_memHist;
    QVector<qreal> m_gpuHist;
    QVariantList m_fpsHistoryVar;
    QVariantList m_memHistoryVar;
    QVariantList m_gpuHistoryVar;

    qint64 m_sampleWindowStartNs = 0;

    std::atomic<int> m_framesSinceSample{0};
    std::atomic<qint64> m_lastSwapNs{0};
    std::atomic<qint64> m_lastDtNs{0};

#if defined(Q_OS_WIN)
    qint64 m_prevCpuKernel = 0;
    qint64 m_prevCpuUser = 0;
    qint64 m_prevWallNs = 0;
    void *m_pdhQuery = nullptr;      // PDH_HQUERY
    void *m_pdhGpuCounter = nullptr; // PDH_HCOUNTER
    void *m_pdhMemQuery = nullptr;   // PDH_HQUERY
    void *m_pdhMemCounter = nullptr; // PDH_HCOUNTER
    bool m_pdhReady = false;
    bool m_pdhMemReady = false;
#elif defined(Q_OS_LINUX)
    qint64 m_prevLinuxCpu = 0;
    qint64 m_prevLinuxWallNs = 0;
#endif
};
