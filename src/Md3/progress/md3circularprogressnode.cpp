#include "md3circularprogressnode.h"

#include "../charts/md3sgutil.h"

#include <QQuickWindow>
#include <QtMath>

Md3CircularProgressNode::Md3CircularProgressNode(QQuickItem *parent)
    : QQuickItem(parent)
{
    setFlag(ItemHasContents, true);
    setAntialiasing(true);
    applyStyleDefaults();
    setImplicitSize(m_indicatorSize, m_indicatorSize);
    setSize(QSizeF(m_indicatorSize, m_indicatorSize));
}

void Md3CircularProgressNode::applyStyleDefaults()
{
    switch (m_style) {
    case Lively:
        m_strokeWidth = 7;
        m_amplitude = 3.5;
        m_waveCount = 8;
        m_indicatorSize = 52;
        break;
    case Soft:
        m_strokeWidth = 5;
        m_amplitude = 1.5;
        m_waveCount = 4;
        m_indicatorSize = 52;
        break;
    case Wavy:
        m_strokeWidth = 6;
        m_amplitude = 2.5;
        m_waveCount = 5;
        m_indicatorSize = 52;
        break;
    default:
        m_strokeWidth = 4;
        m_amplitude = 0;
        m_waveCount = 0;
        m_indicatorSize = 48;
        break;
    }
    setImplicitSize(m_indicatorSize, m_indicatorSize);
    if (width() < 1 || height() < 1)
        setSize(QSizeF(m_indicatorSize, m_indicatorSize));
}

void Md3CircularProgressNode::setValue(qreal v)
{
    v = qBound(0.0, v, 1.0);
    if (qFuzzyCompare(m_value, v))
        return;
    m_value = v;
    emit valueChanged();
    update();
}

void Md3CircularProgressNode::setIndeterminate(bool v)
{
    if (m_indeterminate == v)
        return;
    m_indeterminate = v;
    emit indeterminateChanged();
    syncTicker();
    update();
}

void Md3CircularProgressNode::setStyle(int v)
{
    if (m_style == v)
        return;
    m_style = v;
    applyStyleDefaults();
    emit styleChanged();
    syncTicker();
    update();
}

void Md3CircularProgressNode::setTrackColor(const QColor &c)
{
    if (m_trackColor == c)
        return;
    m_trackColor = c;
    emit colorsChanged();
    update();
}

void Md3CircularProgressNode::setIndicatorColor(const QColor &c)
{
    if (m_indicatorColor == c)
        return;
    m_indicatorColor = c;
    emit colorsChanged();
    update();
}

void Md3CircularProgressNode::setStrokeWidth(qreal v)
{
    if (qFuzzyCompare(m_strokeWidth, v))
        return;
    m_strokeWidth = v;
    emit styleChanged();
    update();
}

void Md3CircularProgressNode::setAmplitude(qreal v)
{
    if (qFuzzyCompare(m_amplitude, v))
        return;
    m_amplitude = v;
    emit styleChanged();
    update();
}

void Md3CircularProgressNode::setWaveCount(int v)
{
    if (m_waveCount == v)
        return;
    m_waveCount = v;
    emit styleChanged();
    update();
}

void Md3CircularProgressNode::setWaveSpeed(qreal v)
{
    if (qFuzzyCompare(m_waveSpeed, v))
        return;
    m_waveSpeed = v;
    emit styleChanged();
}

void Md3CircularProgressNode::setProgressSpinMs(int v)
{
    if (m_spinMs == v)
        return;
    m_spinMs = qMax(1, v);
    emit styleChanged();
}

void Md3CircularProgressNode::setProgressSweepMs(int v)
{
    if (m_sweepMs == v)
        return;
    m_sweepMs = qMax(1, v);
    emit styleChanged();
}

void Md3CircularProgressNode::setIndicatorSize(qreal v)
{
    if (qFuzzyCompare(m_indicatorSize, v))
        return;
    m_indicatorSize = v;
    setImplicitSize(v, v);
    emit styleChanged();
    update();
}

void Md3CircularProgressNode::componentComplete()
{
    QQuickItem::componentComplete();
    syncTicker();
    update();
}

void Md3CircularProgressNode::geometryChange(const QRectF &n, const QRectF &o)
{
    QQuickItem::geometryChange(n, o);
    if (n.size() != o.size())
        update();
}

void Md3CircularProgressNode::itemChange(ItemChange change, const ItemChangeData &data)
{
    QQuickItem::itemChange(change, data);
    if (change == ItemVisibleHasChanged || change == ItemSceneChange
        || change == ItemEnabledHasChanged) {
        syncTicker();
    }
}

bool Md3CircularProgressNode::wantsTick() const
{
    const bool wavy = m_style != Standard;
    return isVisible() && isEnabled() && opacity() > 0.01 && (m_indeterminate || wavy);
}

void Md3CircularProgressNode::syncTicker()
{
    QQuickWindow *w = window();
    if (m_tickConnected && m_tickWindow && m_tickWindow.data() != w) {
        disconnect(m_tickWindow, &QQuickWindow::frameSwapped, this, &Md3CircularProgressNode::onFrameSwapped);
        m_tickConnected = false;
        m_tickWindow = nullptr;
    }
    const bool need = wantsTick() && w;
    if (need && !m_tickConnected) {
        connect(w, &QQuickWindow::frameSwapped, this, &Md3CircularProgressNode::onFrameSwapped);
        m_tickConnected = true;
        m_tickWindow = w;
        m_clock.restart();
    } else if (!need && m_tickConnected) {
        if (m_tickWindow)
            disconnect(m_tickWindow, &QQuickWindow::frameSwapped, this, &Md3CircularProgressNode::onFrameSwapped);
        m_tickConnected = false;
        m_tickWindow = nullptr;
    }
}

void Md3CircularProgressNode::onFrameSwapped()
{
    if (!wantsTick()) {
        syncTicker();
        return;
    }
    qreal dt = m_clock.restart() / 1000.0;
    if (dt <= 0)
        dt = 1.0 / 60.0;
    if (dt > 0.05)
        dt = 0.05;
    advance(dt);
    update();
}

void Md3CircularProgressNode::advance(qreal dt)
{
    const bool wavy = m_style != Standard;
    if (wavy)
        m_wavePhase = std::fmod(m_wavePhase + m_waveSpeed * dt, qreal(M_PI * 2));

    if (m_indeterminate) {
        const qreal spinSpeed = (M_PI * 2) / (m_spinMs / 1000.0);
        m_rotation = std::fmod(m_rotation + spinSpeed * dt, qreal(M_PI * 2));
        const qreal sweepMin = M_PI * 0.28;
        const qreal sweepMax = M_PI * 1.15;
        m_sweep += m_sweepDir * (sweepMax - sweepMin) * dt / (m_sweepMs / 1000.0);
        if (m_sweep >= sweepMax) {
            m_sweep = sweepMax;
            m_sweepDir = -1;
        } else if (m_sweep <= sweepMin) {
            m_sweep = sweepMin;
            m_sweepDir = 1;
        }
    }
}

QSGNode *Md3CircularProgressNode::updatePaintNode(QSGNode *oldNode, UpdatePaintNodeData *)
{
    delete oldNode;
    auto *root = new QSGNode;

    const qreal w = width();
    const qreal h = height();
    if (w < 2 || h < 2)
        return root;

    const qreal cx = w * 0.5;
    const qreal cy = h * 0.5;
    const bool wavy = m_style != Standard && m_amplitude > 0.01;
    const qreal baseR = qMin(w, h) * 0.5 - m_strokeWidth - (wavy ? m_amplitude : 0);
    if (baseR < 1)
        return root;

    auto strokeArc = [&](qreal start, qreal sweepAngle, const QColor &color,
                         QVector<QSGGeometry::ColoredPoint2D> &out) {
        if (std::abs(sweepAngle) < 0.001)
            return;
        const int steps = qMax(24, int(std::ceil(std::abs(sweepAngle) * 28)));
        QVector<QPointF> pts;
        pts.reserve(steps + 1);
        for (int i = 0; i <= steps; ++i) {
            const qreal t = qreal(i) / steps;
            const qreal a = start + sweepAngle * t;
            qreal r = baseR;
            if (wavy)
                r = baseR + std::sin(a * m_waveCount + m_wavePhase) * m_amplitude;
            pts.append(QPointF(cx + std::cos(a) * r, cy + std::sin(a) * r));
        }
        Md3Sg::appendThickPolyline(out, pts, float(m_strokeWidth * 0.5), color);
    };

    QVector<QSGGeometry::ColoredPoint2D> verts;
    strokeArc(-M_PI / 2, M_PI * 2, m_trackColor, verts);
    if (m_indeterminate)
        strokeArc(m_rotation, m_sweep, m_indicatorColor, verts);
    else
        strokeArc(-M_PI / 2, M_PI * 2 * qBound(0.0, m_value, 1.0), m_indicatorColor, verts);

    if (!verts.isEmpty())
        Md3Sg::makeColoredNode(Md3Sg::geometryFromColored(verts, QSGGeometry::DrawTriangleStrip), root);
    return root;
}
