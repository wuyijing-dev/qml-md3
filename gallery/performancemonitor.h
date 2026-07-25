#pragma once

#include <QObject>
#include <QPointer>
#include <QVariantList>
#include <QVector>
#include <QtQml/qqmlregistration.h>
#include <atomic>

class QQuickWindow;
class QTimer;

/// Gallery-only: real FPS / CPU / memory with low GUI-thread overhead.
class PerformanceMonitor : public QObject
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
    Q_PROPERTY(qreal workingSetMb READ workingSetMb NOTIFY metricsChanged)
    Q_PROPERTY(qreal privateBytesMb READ privateBytesMb NOTIFY metricsChanged)
    Q_PROPERTY(qreal cpuPercent READ cpuPercent NOTIFY metricsChanged)
    Q_PROPERTY(QVariantList fpsHistory READ fpsHistory NOTIFY metricsChanged)
    Q_PROPERTY(QVariantList frameTimeHistory READ frameTimeHistory NOTIFY metricsChanged)
    Q_PROPERTY(QVariantList memoryHistory READ memoryHistory NOTIFY metricsChanged)
    Q_PROPERTY(int frameCount READ frameCount NOTIFY metricsChanged)

public:
    explicit PerformanceMonitor(QObject *parent = nullptr);
    ~PerformanceMonitor() override;

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
    qreal workingSetMb() const { return m_workingSetMb; }
    qreal privateBytesMb() const { return m_privateBytesMb; }
    qreal cpuPercent() const { return m_cpuPercent; }
    QVariantList fpsHistory() const { return m_fpsHistoryVar; }
    QVariantList frameTimeHistory() const { return m_frameHistoryVar; }
    QVariantList memoryHistory() const { return m_memHistoryVar; }
    int frameCount() const { return m_frameCount; }

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
    void syncTimer();

    QPointer<QQuickWindow> m_window;
    QTimer *m_sampleTimer = nullptr;
    bool m_active = true;
    int m_historySize = 48;
    int m_sampleIntervalMs = 500;

    qreal m_fps = 0;
    qreal m_frameTimeMs = 0;
    qreal m_fpsMin = 0;
    qreal m_fpsMax = 0;
    qreal m_workingSetMb = 0;
    qreal m_privateBytesMb = 0;
    qreal m_cpuPercent = 0;
    int m_frameCount = 0;

    QVector<qreal> m_fpsHist;
    QVector<qreal> m_frameHist;
    QVector<qreal> m_memHist;
    QVariantList m_fpsHistoryVar;
    QVariantList m_frameHistoryVar;
    QVariantList m_memHistoryVar;

    qint64 m_sampleWindowStartNs = 0;

    // Touch only from DirectConnection (render thread) + timer exchange (GUI).
    std::atomic<int> m_framesSinceSample{0};
    std::atomic<qint64> m_lastSwapNs{0};
    std::atomic<qint64> m_lastDtNs{0};

#if defined(Q_OS_WIN)
    qint64 m_prevCpuKernel = 0;
    qint64 m_prevCpuUser = 0;
    qint64 m_prevWallNs = 0;
#endif
};
