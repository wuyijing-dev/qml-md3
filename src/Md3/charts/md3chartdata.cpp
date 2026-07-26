#include "md3chartdata.h"

#include <QtMath>
#include <cmath>
#include <cstring>

Md3ChartData::Md3ChartData(QObject *parent)
    : QObject(parent)
{
}

QVariantList Md3ChartData::points() const
{
    QVariantList out;
    out.reserve(m_display.size());
    for (float v : m_display)
        out.append(v);
    return out;
}

void Md3ChartData::setTargetPoints(int n)
{
    n = qMax(16, n);
    if (m_targetPoints == n)
        return;
    m_targetPoints = n;
    emit targetPointsChanged();
    if (!m_raw.isEmpty()) {
        rebuildDisplay();
        emit pointsChanged();
    }
}

Md3ChartData::Series Md3ChartData::downsampleMinMax(const Series &in, int target)
{
    const int n = in.size();
    if (n <= target || target < 3)
        return in;

    const int buckets = qMax(1, (target - 2) / 2);
    Series out;
    out.reserve(buckets * 2 + 2);
    out.push_back(in.first());
    for (int b = 0; b < buckets; ++b) {
        const int start = int(std::floor(b * double(n - 2) / buckets)) + 1;
        const int end = int(std::floor((b + 1) * double(n - 2) / buckets)) + 1;
        if (start >= n - 1)
            break;
        int loI = start;
        int hiI = start;
        float lo = in[start];
        float hi = in[start];
        for (int i = start + 1; i < end && i < n - 1; ++i) {
            const float v = in[i];
            if (v < lo) {
                lo = v;
                loI = i;
            }
            if (v > hi) {
                hi = v;
                hiI = i;
            }
        }
        if (loI <= hiI) {
            out.push_back(lo);
            if (hiI != loI)
                out.push_back(hi);
        } else {
            out.push_back(hi);
            if (loI != hiI)
                out.push_back(lo);
        }
    }
    out.push_back(in.last());
    return out;
}

void Md3ChartData::rebuildDisplay()
{
    m_display = downsampleMinMax(m_raw, m_targetPoints);
    m_rawCount = m_raw.size();
}

void Md3ChartData::fillSine(int count, qreal mid, qreal amp1, qreal amp2, qreal noise)
{
    count = qMax(0, count);
    m_raw.resize(count);
    for (int i = 0; i < count; ++i) {
        const qreal t = i * 0.002;
        const qreal n = ((i % 997) / 997.0 - 0.5) * noise;
        m_raw[i] = float(mid + std::sin(t) * amp1 + std::sin(t * 0.17) * amp2 + n);
    }
    rebuildDisplay();
    emit pointsChanged();
}

void Md3ChartData::setFloatValues(const QByteArray &floats)
{
    const int n = floats.size() / int(sizeof(float));
    m_raw.resize(n);
    if (n > 0)
        memcpy(m_raw.data(), floats.constData(), size_t(n) * sizeof(float));
    rebuildDisplay();
    emit pointsChanged();
}

void Md3ChartData::setValues(const QVariantList &values)
{
    m_raw.resize(values.size());
    for (int i = 0; i < values.size(); ++i)
        m_raw[i] = float(values.at(i).toReal());
    rebuildDisplay();
    emit pointsChanged();
}

void Md3ChartData::clear()
{
    m_raw.clear();
    m_display.clear();
    m_rawCount = 0;
    emit pointsChanged();
}
