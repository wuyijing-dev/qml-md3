#include "md3performancemonitor.h"

#include <QElapsedTimer>
#include <QFile>
#include <QQuickWindow>
#include <QSGRendererInterface>
#include <QTextStream>
#include <QTimer>
#include <QtGlobal>

#if defined(Q_OS_WIN)
#  include <windows.h>
#  include <psapi.h>
#  include <pdh.h>
#  include <pdhmsg.h>
#  pragma comment(lib, "pdh.lib")
#elif defined(Q_OS_LINUX)
#  include <unistd.h>
#endif

namespace {

qint64 md3NowNs()
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

#if defined(Q_OS_WIN)
// Prefer EX2 (PrivateWorkingSetSize ≈ Task Manager "Memory") when available.
struct Md3PmcEx2 {
    DWORD cb = 0;
    DWORD PageFaultCount = 0;
    SIZE_T PeakWorkingSetSize = 0;
    SIZE_T WorkingSetSize = 0;
    SIZE_T QuotaPeakPagedPoolUsage = 0;
    SIZE_T QuotaPagedPoolUsage = 0;
    SIZE_T QuotaPeakNonPagedPoolUsage = 0;
    SIZE_T QuotaNonPagedPoolUsage = 0;
    SIZE_T PagefileUsage = 0;
    SIZE_T PeakPagefileUsage = 0;
    SIZE_T PrivateUsage = 0;
    SIZE_T PrivateWorkingSetSize = 0;
    ULONG64 SharedCommitUsage = 0;
};

bool queryPmcEx2(Md3PmcEx2 *out)
{
    out->cb = sizeof(Md3PmcEx2);
    if (GetProcessMemoryInfo(GetCurrentProcess(),
                              reinterpret_cast<PROCESS_MEMORY_COUNTERS *>(out),
                              sizeof(Md3PmcEx2))) {
        return true;
    }
    // Older Windows: fall back to EX (no private working set field).
    PROCESS_MEMORY_COUNTERS_EX pmc{};
    pmc.cb = sizeof(pmc);
    if (!GetProcessMemoryInfo(GetCurrentProcess(),
                              reinterpret_cast<PROCESS_MEMORY_COUNTERS *>(&pmc),
                              sizeof(pmc))) {
        return false;
    }
    out->WorkingSetSize = pmc.WorkingSetSize;
    out->PrivateUsage = pmc.PrivateUsage;
    out->PrivateWorkingSetSize = 0;
    return true;
}
#endif

} // namespace

Md3PerformanceMonitor::Md3PerformanceMonitor(QObject *parent)
    : QObject(parent)
{
#if defined(Q_OS_WIN)
    m_memoryLabel = QStringLiteral("Private WS");
#elif defined(Q_OS_LINUX)
    m_memoryLabel = QStringLiteral("RSS");
#else
    m_memoryLabel = QStringLiteral("Memory");
#endif

    m_sampleTimer = new QTimer(this);
    m_sampleTimer->setTimerType(Qt::VeryCoarseTimer);
    connect(m_sampleTimer, &QTimer::timeout, this, &Md3PerformanceMonitor::onSampleTick);
    syncTimer();
}

Md3PerformanceMonitor::~Md3PerformanceMonitor()
{
    unbindWindow();
#if defined(Q_OS_WIN)
    if (m_pdhQuery) {
        PdhCloseQuery(static_cast<PDH_HQUERY>(m_pdhQuery));
        m_pdhQuery = nullptr;
        m_pdhGpuCounter = nullptr;
        m_pdhReady = false;
    }
    if (m_pdhMemQuery) {
        PdhCloseQuery(static_cast<PDH_HQUERY>(m_pdhMemQuery));
        m_pdhMemQuery = nullptr;
        m_pdhMemCounter = nullptr;
        m_pdhMemReady = false;
    }
#endif
}

QString Md3PerformanceMonitor::platformId() const
{
#if defined(Q_OS_WIN)
    return QStringLiteral("windows");
#elif defined(Q_OS_LINUX)
    return QStringLiteral("linux");
#elif defined(Q_OS_MACOS)
    return QStringLiteral("macos");
#else
    return QStringLiteral("unknown");
#endif
}

QString Md3PerformanceMonitor::platformLabel() const
{
#if defined(Q_OS_WIN)
    return QStringLiteral("Windows");
#elif defined(Q_OS_LINUX)
    return QStringLiteral("Linux");
#elif defined(Q_OS_MACOS)
    return QStringLiteral("macOS");
#else
    return QStringLiteral("Unknown");
#endif
}

void Md3PerformanceMonitor::syncTimer()
{
    m_sampleTimer->setInterval(qMax(250, m_sampleIntervalMs));
    if (m_active && m_window)
        m_sampleTimer->start();
    else
        m_sampleTimer->stop();
}

void Md3PerformanceMonitor::setActive(bool active)
{
    if (m_active == active)
        return;
    m_active = active;
    if (m_active) {
        m_framesSinceSample.store(0);
        m_lastSwapNs.store(0);
        m_lastDtNs.store(0);
        m_sampleWindowStartNs = md3NowNs();
        if (m_window) {
            connect(m_window, &QQuickWindow::frameSwapped, this, &Md3PerformanceMonitor::onFrameSwapped,
                    Qt::DirectConnection);
        }
    } else if (m_window) {
        disconnect(m_window, &QQuickWindow::frameSwapped, this, &Md3PerformanceMonitor::onFrameSwapped);
        m_fpsHist.clear();
        m_memHist.clear();
        m_gpuHist.clear();
        rebuildHistoryVariants();
        emit metricsChanged();
    }
    syncTimer();
    emit activeChanged();
}

void Md3PerformanceMonitor::setHistorySize(int size)
{
    size = qBound(8, size, 120);
    if (m_historySize == size)
        return;
    m_historySize = size;
    while (m_fpsHist.size() > m_historySize)
        m_fpsHist.removeFirst();
    while (m_memHist.size() > m_historySize)
        m_memHist.removeFirst();
    while (m_gpuHist.size() > m_historySize)
        m_gpuHist.removeFirst();
    rebuildHistoryVariants();
    emit historySizeChanged();
    emit metricsChanged();
}

void Md3PerformanceMonitor::setSampleIntervalMs(int ms)
{
    ms = qBound(250, ms, 5000);
    if (m_sampleIntervalMs == ms)
        return;
    m_sampleIntervalMs = ms;
    syncTimer();
    emit sampleIntervalMsChanged();
}

void Md3PerformanceMonitor::bindWindow(QObject *window)
{
    unbindWindow();
    auto *qw = qobject_cast<QQuickWindow *>(window);
    if (!qw)
        return;
    m_window = qw;
    m_framesSinceSample.store(0);
    m_lastSwapNs.store(0);
    m_lastDtNs.store(0);
    m_sampleWindowStartNs = md3NowNs();
    if (m_active) {
        connect(qw, &QQuickWindow::frameSwapped, this, &Md3PerformanceMonitor::onFrameSwapped,
                Qt::DirectConnection);
    }
    refreshGraphicsApi();
    syncTimer();
}

void Md3PerformanceMonitor::unbindWindow()
{
    if (m_window) {
        disconnect(m_window, &QQuickWindow::frameSwapped, this, &Md3PerformanceMonitor::onFrameSwapped);
        m_window = nullptr;
    }
    syncTimer();
}

void Md3PerformanceMonitor::reset()
{
    m_fpsHist.clear();
    m_memHist.clear();
    m_gpuHist.clear();
    rebuildHistoryVariants();
    m_fps = 0;
    m_frameTimeMs = 0;
    m_fpsMin = 0;
    m_fpsMax = 0;
    m_frameCount = 0;
    m_framesSinceSample.store(0);
    m_lastSwapNs.store(0);
    m_lastDtNs.store(0);
    m_sampleWindowStartNs = md3NowNs();
    emit metricsChanged();
}

void Md3PerformanceMonitor::pushHistory(QVector<qreal> &hist, qreal value)
{
    hist.append(value);
    while (hist.size() > m_historySize)
        hist.removeFirst();
}

void Md3PerformanceMonitor::rebuildHistoryVariants()
{
    m_fpsHistoryVar = toVariantList(m_fpsHist);
    m_memHistoryVar = toVariantList(m_memHist);
    m_gpuHistoryVar = toVariantList(m_gpuHist);
}

void Md3PerformanceMonitor::refreshGraphicsApi()
{
    m_graphicsApi.clear();
    if (!m_window)
        return;
    QSGRendererInterface *ri = m_window->rendererInterface();
    if (!ri) {
        m_graphicsApi = QStringLiteral("—");
        return;
    }
    switch (ri->graphicsApi()) {
    case QSGRendererInterface::Direct3D11: m_graphicsApi = QStringLiteral("D3D11"); break;
    case QSGRendererInterface::Direct3D12: m_graphicsApi = QStringLiteral("D3D12"); break;
    case QSGRendererInterface::Vulkan: m_graphicsApi = QStringLiteral("Vulkan"); break;
    case QSGRendererInterface::Metal: m_graphicsApi = QStringLiteral("Metal"); break;
    case QSGRendererInterface::OpenGL: m_graphicsApi = QStringLiteral("OpenGL"); break;
    case QSGRendererInterface::Software: m_graphicsApi = QStringLiteral("Software"); break;
    default: m_graphicsApi = QStringLiteral("—"); break;
    }
}

void Md3PerformanceMonitor::onFrameSwapped()
{
    if (!m_active)
        return;
    const qint64 now = md3NowNs();
    m_framesSinceSample.fetch_add(1, std::memory_order_relaxed);
    const qint64 prev = m_lastSwapNs.exchange(now, std::memory_order_relaxed);
    if (prev > 0) {
        const qint64 dt = now - prev;
        if (dt > 100000 && dt < 1000000000)
            m_lastDtNs.store(dt, std::memory_order_relaxed);
    }
}

void Md3PerformanceMonitor::onSampleTick()
{
    if (!m_active || !m_window)
        return;

    const qint64 now = md3NowNs();
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

    refreshGraphicsApi();
    sampleProcess();
    sampleGpu();

    pushHistory(m_fpsHist, m_fps);
    pushHistory(m_memHist, m_memoryMb);
    if (m_gpuPercent >= 0)
        pushHistory(m_gpuHist, m_gpuPercent);
    rebuildHistoryVariants();
    emit metricsChanged();
}

void Md3PerformanceMonitor::sampleProcess()
{
#if defined(Q_OS_WIN)
    Md3PmcEx2 pmc{};
    if (queryPmcEx2(&pmc)) {
        m_workingSetMb = qreal(pmc.WorkingSetSize) / (1024.0 * 1024.0);
        m_privateBytesMb = qreal(pmc.PrivateUsage) / (1024.0 * 1024.0);
        if (pmc.PrivateWorkingSetSize > 0) {
            // Matches Task Manager Processes "Memory" (private working set).
            m_privateWorkingSetMb = qreal(pmc.PrivateWorkingSetSize) / (1024.0 * 1024.0);
            m_memoryMb = m_privateWorkingSetMb;
            m_memoryLabel = QStringLiteral("Private WS");
        } else {
            // Fallback: Working Set is closer to Task Manager than Private Bytes
            // (PrivateUsage/commit is often ~2× the UI column).
            m_privateWorkingSetMb = m_workingSetMb;
            m_memoryMb = m_workingSetMb;
            m_memoryLabel = QStringLiteral("Working set");
        }
    }

    FILETIME creation{}, exitT{}, kernel{}, user{};
    if (GetProcessTimes(GetCurrentProcess(), &creation, &exitT, &kernel, &user)) {
        auto to100ns = [](const FILETIME &ft) -> qint64 {
            return (qint64(ft.dwHighDateTime) << 32) | qint64(ft.dwLowDateTime);
        };
        const qint64 k = to100ns(kernel);
        const qint64 u = to100ns(user);
        const qint64 wall = md3NowNs();
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
#elif defined(Q_OS_LINUX)
    qreal rssMb = 0;
    qreal swapMb = 0;
    QFile status(QStringLiteral("/proc/self/status"));
    if (status.open(QIODevice::ReadOnly | QIODevice::Text)) {
        QTextStream in(&status);
        while (!in.atEnd()) {
            const QString line = in.readLine();
            if (line.startsWith(QLatin1String("VmRSS:"))) {
                const QStringList parts = line.split(QLatin1Char(' '), Qt::SkipEmptyParts);
                if (parts.size() >= 2)
                    rssMb = parts.at(1).toLongLong() / 1024.0;
            } else if (line.startsWith(QLatin1String("VmSwap:"))) {
                const QStringList parts = line.split(QLatin1Char(' '), Qt::SkipEmptyParts);
                if (parts.size() >= 2)
                    swapMb = parts.at(1).toLongLong() / 1024.0;
            }
        }
    }
    Q_UNUSED(swapMb);
    m_workingSetMb = rssMb;

    qint64 privateKb = 0;
    qint64 pssKb = 0;
    QFile rollup(QStringLiteral("/proc/self/smaps_rollup"));
    if (rollup.open(QIODevice::ReadOnly | QIODevice::Text)) {
        QTextStream in(&rollup);
        while (!in.atEnd()) {
            const QString line = in.readLine();
            if (line.startsWith(QLatin1String("Private_Clean:"))
                    || line.startsWith(QLatin1String("Private_Dirty:"))) {
                const QStringList parts = line.split(QLatin1Char(' '), Qt::SkipEmptyParts);
                if (parts.size() >= 2)
                    privateKb += parts.at(1).toLongLong();
            } else if (line.startsWith(QLatin1String("Pss:"))) {
                const QStringList parts = line.split(QLatin1Char(' '), Qt::SkipEmptyParts);
                if (parts.size() >= 2)
                    pssKb = parts.at(1).toLongLong();
            }
        }
    }
    m_privateBytesMb = privateKb > 0 ? qreal(privateKb) / 1024.0 : rssMb;
    // System Monitor / GNOME often show RSS; PSS is fairer for shared libs.
    m_privateWorkingSetMb = pssKb > 0 ? qreal(pssKb) / 1024.0 : rssMb;
    m_memoryMb = rssMb;
    m_memoryLabel = QStringLiteral("RSS");

    // CPU: /proc/self/stat utime+stime (clock ticks).
    QFile statFile(QStringLiteral("/proc/self/stat"));
    if (statFile.open(QIODevice::ReadOnly | QIODevice::Text)) {
        const QByteArray line = statFile.readAll();
        // Format: pid (comm) state ... utime stime — comm may contain spaces/parens.
        const int rparen = line.lastIndexOf(')');
        if (rparen > 0) {
            const QList<QByteArray> parts = line.mid(rparen + 2).split(' ');
            // After ") ": state=0, ppid=1, ... utime=11, stime=12 (0-based in remainder)
            if (parts.size() > 12) {
                const qint64 utime = parts.at(11).toLongLong();
                const qint64 stime = parts.at(12).toLongLong();
                const qint64 total = utime + stime;
                const qint64 wall = md3NowNs();
                if (m_prevLinuxWallNs > 0 && m_prevLinuxCpu >= 0) {
                    const qint64 dCpu = total - m_prevLinuxCpu;
                    const qreal dWallSec = qreal(wall - m_prevLinuxWallNs) / 1e9;
                    const qreal ticksPerSec = qreal(sysconf(_SC_CLK_TCK));
                    const long cores = qMax(1L, sysconf(_SC_NPROCESSORS_ONLN));
                    if (dWallSec > 0.0 && ticksPerSec > 0.0) {
                        m_cpuPercent = qBound(0.0,
                            (qreal(dCpu) / ticksPerSec) / dWallSec * 100.0 / qreal(cores),
                            100.0);
                    }
                }
                m_prevLinuxCpu = total;
                m_prevLinuxWallNs = wall;
            }
        }
    }
#else
    Q_UNUSED(this);
#endif
}

void Md3PerformanceMonitor::sampleGpu()
{
    m_gpuAvailable = false;
    m_gpuPercent = -1;
    m_gpuMemoryMb = -1;

#if defined(Q_OS_WIN)
    // PDH: sum 3D engine util for this PID (Task Manager GPU engine style).
    const DWORD pid = GetCurrentProcessId();
    if (!m_pdhQuery) {
        PDH_HQUERY query = nullptr;
        if (PdhOpenQueryW(nullptr, 0, &query) != ERROR_SUCCESS)
            return;
        m_pdhQuery = query;

        // Wildcard: all GPU Engine instances; filter by pid_ in Collect.
        wchar_t path[256];
        swprintf_s(path, L"\\GPU Engine(pid_%lu*)\\Utilization Percentage",
                   static_cast<unsigned long>(pid));
        PDH_HCOUNTER counter = nullptr;
        const PDH_STATUS st = PdhAddEnglishCounterW(query, path, 0, &counter);
        if (st != ERROR_SUCCESS) {
            // Fallback: any engtype_3D for this pid
            swprintf_s(path, L"\\GPU Engine(pid_%lu_*)\\Utilization Percentage",
                       static_cast<unsigned long>(pid));
            if (PdhAddEnglishCounterW(query, path, 0, &counter) != ERROR_SUCCESS) {
                PdhCloseQuery(query);
                m_pdhQuery = nullptr;
                return;
            }
        }
        m_pdhGpuCounter = counter;
        PdhCollectQueryData(query); // prime
        m_pdhReady = true;
    }

    if (!m_pdhReady || !m_pdhQuery)
        return;

    auto *query = static_cast<PDH_HQUERY>(m_pdhQuery);
    if (PdhCollectQueryData(query) != ERROR_SUCCESS)
        return;

    // Expand wildcards via PdhGetRawCounterArray / formatted array.
    DWORD bufSize = 0;
    DWORD itemCount = 0;
    PDH_STATUS st = PdhGetFormattedCounterArrayW(
        static_cast<PDH_HCOUNTER>(m_pdhGpuCounter), PDH_FMT_DOUBLE, &bufSize, &itemCount, nullptr);
    if (st != PDH_MORE_DATA && st != ERROR_SUCCESS)
        return;

    QByteArray buf(int(bufSize), Qt::Uninitialized);
    auto *items = reinterpret_cast<PDH_FMT_COUNTERVALUE_ITEM_W *>(buf.data());
    itemCount = 0;
    st = PdhGetFormattedCounterArrayW(
        static_cast<PDH_HCOUNTER>(m_pdhGpuCounter), PDH_FMT_DOUBLE, &bufSize, &itemCount, items);
    if (st != ERROR_SUCCESS || itemCount == 0)
        return;

    qreal sum = 0;
    int n = 0;
    for (DWORD i = 0; i < itemCount; ++i) {
        if (items[i].FmtValue.CStatus == ERROR_SUCCESS) {
            sum += items[i].FmtValue.doubleValue;
            ++n;
        }
    }
    if (n > 0) {
        // Multiple engines: take max (closer to Task Manager GPU column) not sum.
        qreal mx = 0;
        for (DWORD i = 0; i < itemCount; ++i) {
            if (items[i].FmtValue.CStatus == ERROR_SUCCESS)
                mx = qMax(mx, items[i].FmtValue.doubleValue);
        }
        m_gpuPercent = qBound(0.0, mx, 100.0);
        m_gpuAvailable = true;
    }

    // Dedicated GPU memory for this process (cached query).
    if (!m_pdhMemReady && !m_pdhMemQuery) {
        wchar_t memPath[256];
        swprintf_s(memPath, L"\\GPU Process Memory(pid_%lu*)\\Dedicated Usage",
                   static_cast<unsigned long>(pid));
        PDH_HQUERY memQuery = nullptr;
        PDH_HCOUNTER memCounter = nullptr;
        if (PdhOpenQueryW(nullptr, 0, &memQuery) == ERROR_SUCCESS
                && PdhAddEnglishCounterW(memQuery, memPath, 0, &memCounter) == ERROR_SUCCESS) {
            m_pdhMemQuery = memQuery;
            m_pdhMemCounter = memCounter;
            PdhCollectQueryData(memQuery); // prime
            m_pdhMemReady = true;
        } else if (memQuery) {
            PdhCloseQuery(memQuery);
        }
    }
    if (m_pdhMemReady && m_pdhMemQuery) {
        auto *memQuery = static_cast<PDH_HQUERY>(m_pdhMemQuery);
        if (PdhCollectQueryData(memQuery) == ERROR_SUCCESS) {
            DWORD mBuf = 0;
            DWORD mCount = 0;
            PDH_STATUS mst = PdhGetFormattedCounterArrayW(
                static_cast<PDH_HCOUNTER>(m_pdhMemCounter), PDH_FMT_LARGE, &mBuf, &mCount, nullptr);
            if (mst == PDH_MORE_DATA || mst == ERROR_SUCCESS) {
                QByteArray raw(int(mBuf), Qt::Uninitialized);
                auto *mitems = reinterpret_cast<PDH_FMT_COUNTERVALUE_ITEM_W *>(raw.data());
                mCount = 0;
                if (PdhGetFormattedCounterArrayW(
                        static_cast<PDH_HCOUNTER>(m_pdhMemCounter), PDH_FMT_LARGE,
                        &mBuf, &mCount, mitems) == ERROR_SUCCESS) {
                    qint64 bytes = 0;
                    for (DWORD i = 0; i < mCount; ++i) {
                        if (mitems[i].FmtValue.CStatus == ERROR_SUCCESS)
                            bytes = qMax(bytes, qint64(mitems[i].FmtValue.largeValue));
                    }
                    if (bytes > 0)
                        m_gpuMemoryMb = qreal(bytes) / (1024.0 * 1024.0);
                }
            }
        }
    }

#elif defined(Q_OS_LINUX)
    // AMD: /sys/class/drm/card*/device/gpu_busy_percent
    // NVIDIA: try nvidia-smi is too heavy; skip unless sysfs exists.
    const QStringList cards = {
        QStringLiteral("/sys/class/drm/card0/device/gpu_busy_percent"),
        QStringLiteral("/sys/class/drm/card1/device/gpu_busy_percent"),
    };
    for (const QString &path : cards) {
        QFile f(path);
        if (!f.open(QIODevice::ReadOnly | QIODevice::Text))
            continue;
        bool ok = false;
        const qreal v = QString::fromUtf8(f.readAll().trimmed()).toDouble(&ok);
        if (ok) {
            m_gpuPercent = qBound(0.0, v, 100.0);
            m_gpuAvailable = true;
            break;
        }
    }

    // Intel/AMD VRAM used (system-wide, not per-process — still useful).
    const QStringList vramPaths = {
        QStringLiteral("/sys/class/drm/card0/device/mem_info_vram_used"),
        QStringLiteral("/sys/class/drm/card1/device/mem_info_vram_used"),
    };
    for (const QString &path : vramPaths) {
        QFile f(path);
        if (!f.open(QIODevice::ReadOnly | QIODevice::Text))
            continue;
        bool ok = false;
        const qulonglong bytes = QString::fromUtf8(f.readAll().trimmed()).toULongLong(&ok);
        if (ok && bytes > 0) {
            m_gpuMemoryMb = qreal(bytes) / (1024.0 * 1024.0);
            m_gpuAvailable = true;
            break;
        }
    }
#else
    Q_UNUSED(this);
#endif
}
