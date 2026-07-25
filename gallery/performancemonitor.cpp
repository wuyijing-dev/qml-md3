#include "performancemonitor.h"

#include <QElapsedTimer>
#include <QQuickWindow>
#include <QTimer>
#include <QtGlobal>

#if defined(Q_OS_WIN)
#  include <windows.h>
#  include <psapi.h>
#endif

namespace {

qint64 galleryNowNs()
{
    static QElapsedTimer t;
    static const bool started = [] {
        t.start();
        return true;
    }();
    Q_UNUSED(started);
    return t.nsecsElapsed();
}

QVariantList toVariantList(const QVector<qreal> &hist)
{
    QVariantList out;
    out.reserve(hist.size());
    for (qreal v : hist)
        out.append(v);
    return out;
}

} // namespace

PerformanceMonitor::PerformanceMonitor(QObject *parent)
    : QObject(parent)
{
    m_sampleTimer = new QTimer(this);
    m_sampleTimer->setTimerType(Qt::CoarseTimer);
    connect(m_sampleTimer, &QTimer::timeout, this, &PerformanceMonitor::onSampleTick);
    syncTimer();
}

PerformanceMonitor::~PerformanceMonitor()
{
    unbindWindow();
}

void PerformanceMonitor::syncTimer()
{
    m_sampleTimer->setInterval(qMax(200, m_sampleIntervalMs));
    if (m_active && m_window)
        m_sampleTimer->start();
    else
        m_sampleTimer->stop();
}

void PerformanceMonitor::setActive(bool active)
{
    if (m_active == active)
        return;
    m_active = active;
    if (m_active) {
        m_framesSinceSample.store(0);
        m_lastSwapNs.store(0);
        m_lastDtNs.store(0);
        m_sampleWindowStartNs = galleryNowNs();
        if (m_window) {
            connect(m_window, &QQuickWindow::frameSwapped, this, &PerformanceMonitor::onFrameSwapped,
                    Qt::DirectConnection);
        }
    } else if (m_window) {
        disconnect(m_window, &QQuickWindow::frameSwapped, this, &PerformanceMonitor::onFrameSwapped);
        m_fpsHist.clear();
        m_frameHist.clear();
        m_memHist.clear();
        rebuildHistoryVariants();
        emit metricsChanged();
    }
    syncTimer();
    emit activeChanged();
}

void PerformanceMonitor::setHistorySize(int size)
{
    size = qBound(8, size, 240);
    if (m_historySize == size)
        return;
    m_historySize = size;
    while (m_fpsHist.size() > m_historySize)
        m_fpsHist.removeFirst();
    while (m_frameHist.size() > m_historySize)
        m_frameHist.removeFirst();
    while (m_memHist.size() > m_historySize)
        m_memHist.removeFirst();
    rebuildHistoryVariants();
    emit historySizeChanged();
    emit metricsChanged();
}

void PerformanceMonitor::setSampleIntervalMs(int ms)
{
    ms = qBound(200, ms, 5000);
    if (m_sampleIntervalMs == ms)
        return;
    m_sampleIntervalMs = ms;
    syncTimer();
    emit sampleIntervalMsChanged();
}

void PerformanceMonitor::bindWindow(QObject *window)
{
    unbindWindow();
    auto *qw = qobject_cast<QQuickWindow *>(window);
    if (!qw)
        return;
    m_window = qw;
    m_framesSinceSample.store(0);
    m_lastSwapNs.store(0);
    m_lastDtNs.store(0);
    m_sampleWindowStartNs = galleryNowNs();
    if (m_active) {
        connect(qw, &QQuickWindow::frameSwapped, this, &PerformanceMonitor::onFrameSwapped,
                Qt::DirectConnection);
    }
    syncTimer();
}

void PerformanceMonitor::unbindWindow()
{
    if (m_window) {
        disconnect(m_window, &QQuickWindow::frameSwapped, this, &PerformanceMonitor::onFrameSwapped);
        m_window = nullptr;
    }
    syncTimer();
}

void PerformanceMonitor::reset()
{
    m_fpsHist.clear();
    m_frameHist.clear();
    m_memHist.clear();
    rebuildHistoryVariants();
    m_fps = 0;
    m_frameTimeMs = 0;
    m_fpsMin = 0;
    m_fpsMax = 0;
    m_frameCount = 0;
    m_framesSinceSample.store(0);
    m_lastSwapNs.store(0);
    m_lastDtNs.store(0);
    m_sampleWindowStartNs = galleryNowNs();
    emit metricsChanged();
}

void PerformanceMonitor::pushHistory(QVector<qreal> &hist, qreal value)
{
    hist.append(value);
    while (hist.size() > m_historySize)
        hist.removeFirst();
}

void PerformanceMonitor::rebuildHistoryVariants()
{
    m_fpsHistoryVar = toVariantList(m_fpsHist);
    m_frameHistoryVar = toVariantList(m_frameHist);
    m_memHistoryVar = toVariantList(m_memHist);
}

void PerformanceMonitor::onFrameSwapped()
{
    // May run on the scene graph / render thread — keep this lock-free and tiny.
    if (!m_active)
        return;
    const qint64 now = galleryNowNs();
    m_framesSinceSample.fetch_add(1, std::memory_order_relaxed);
    const qint64 prev = m_lastSwapNs.exchange(now, std::memory_order_relaxed);
    if (prev > 0) {
        const qint64 dt = now - prev;
        if (dt > 100000 && dt < 1000000000) // 0.1ms .. 1s
            m_lastDtNs.store(dt, std::memory_order_relaxed);
    }
}

void PerformanceMonitor::onSampleTick()
{
    if (!m_active || !m_window)
        return;

    const qint64 now = galleryNowNs();
    const int frames = m_framesSinceSample.exchange(0, std::memory_order_relaxed);
    m_frameCount += frames;

    qreal elapsedMs = 0;
    if (m_sampleWindowStartNs > 0)
        elapsedMs = qreal(now - m_sampleWindowStartNs) / 1e6;
    m_sampleWindowStartNs = now;

    if (elapsedMs > 1.0 && frames > 0)
        m_fps = qreal(frames) * 1000.0 / elapsedMs;
    else if (frames == 0)
        m_fps = 0;

    const qint64 dtNs = m_lastDtNs.load(std::memory_order_relaxed);
    if (dtNs > 0)
        m_frameTimeMs = qreal(dtNs) / 1e6;

    if (m_fps > 0.01) {
        if (m_fpsMin <= 0.01)
            m_fpsMin = m_fps;
        else
            m_fpsMin = qMin(m_fpsMin, m_fps);
        m_fpsMax = qMax(m_fpsMax, m_fps);
    }

    sampleProcess();

    pushHistory(m_fpsHist, m_fps);
    pushHistory(m_frameHist, m_frameTimeMs);
    pushHistory(m_memHist, m_workingSetMb);
    rebuildHistoryVariants();
    emit metricsChanged();
}

void PerformanceMonitor::sampleProcess()
{
#if defined(Q_OS_WIN)
    PROCESS_MEMORY_COUNTERS_EX pmc{};
    pmc.cb = sizeof(pmc);
    if (GetProcessMemoryInfo(GetCurrentProcess(),
                             reinterpret_cast<PROCESS_MEMORY_COUNTERS *>(&pmc),
                             sizeof(pmc))) {
        m_workingSetMb = qreal(pmc.WorkingSetSize) / (1024.0 * 1024.0);
        m_privateBytesMb = qreal(pmc.PrivateUsage) / (1024.0 * 1024.0);
    }

    FILETIME creation{}, exitT{}, kernel{}, user{};
    if (GetProcessTimes(GetCurrentProcess(), &creation, &exitT, &kernel, &user)) {
        auto to100ns = [](const FILETIME &ft) -> qint64 {
            return (qint64(ft.dwHighDateTime) << 32) | qint64(ft.dwLowDateTime);
        };
        const qint64 k = to100ns(kernel);
        const qint64 u = to100ns(user);
        const qint64 wall = galleryNowNs();
        if (m_prevWallNs > 0) {
            const qint64 dCpu = (k - m_prevCpuKernel) + (u - m_prevCpuUser);
            const qint64 dWall100ns = (wall - m_prevWallNs) / 100;
            if (dWall100ns > 0) {
                SYSTEM_INFO si{};
                GetSystemInfo(&si);
                const int cores = qMax(1, int(si.dwNumberOfProcessors));
                m_cpuPercent = qBound(0.0, (qreal(dCpu) / qreal(dWall100ns)) * 100.0 / cores, 100.0);
            }
        }
        m_prevCpuKernel = k;
        m_prevCpuUser = u;
        m_prevWallNs = wall;
    }
#else
    Q_UNUSED(this);
#endif
}
