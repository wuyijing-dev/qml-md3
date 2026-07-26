#include "md3linearprogressnode.h"

#include "../charts/md3sgutil.h"

#include <QQuickWindow>
#include <QtMath>

Md3LinearProgressNode::Md3LinearProgressNode(QQuickItem *parent)
    : QQuickItem(parent)
{
    setFlag(ItemHasContents, true);
    setAntialiasing(true);
    setImplicitSize(200, preferredHeight());
    applyStyleDefaults();
}

qreal Md3LinearProgressNode::preferredHeight() const
{
    return qMax(m_thickness, m_amplitude * 2 + m_thickness);
}

void Md3LinearProgressNode::applyStyleDefaults()
{
    switch (m_style) {
    case Lively:
        m_wavelength = 28;
        m_amplitude = 5;
        m_thickness = 10;
        break;
    case Soft:
        m_wavelength = 56;
        m_amplitude = 2;
        m_thickness = 6;
        break;
    case Wavy:
        m_wavelength = 40;
        m_amplitude = 3;
        m_thickness = 8;
        break;
    default:
        m_wavelength = 40;
        m_amplitude = 0;
        m_thickness = 4;
        break;
    }
    setImplicitHeight(preferredHeight());
}

void Md3LinearProgressNode::setValue(qreal v)
{
    v = qBound(0.0, v, 1.0);
    if (qFuzzyCompare(m_value, v))
        return;
    m_value = v;
    emit valueChanged();
    update();
}

void Md3LinearProgressNode::setIndeterminate(bool v)
{
    if (m_indeterminate == v)
        return;
    m_indeterminate = v;
    emit indeterminateChanged();
    syncTicker();
    update();
}

void Md3LinearProgressNode::setStyle(int v)
{
    if (m_style == v)
        return;
    m_style = v;
    applyStyleDefaults();
    emit styleChanged();
    syncTicker();
    update();
}

void Md3LinearProgressNode::setTrackColor(const QColor &c)
{
    if (m_trackColor == c)
        return;
    m_trackColor = c;
    emit colorsChanged();
    update();
}

void Md3LinearProgressNode::setIndicatorColor(const QColor &c)
{
    if (m_indicatorColor == c)
        return;
    m_indicatorColor = c;
    emit colorsChanged();
    update();
}

void Md3LinearProgressNode::setShowStopIndicator(bool v)
{
    if (m_showStop == v)
        return;
    m_showStop = v;
    emit styleChanged();
    update();
}

void Md3LinearProgressNode::setWavelength(qreal v)
{
    if (qFuzzyCompare(m_wavelength, v))
        return;
    m_wavelength = v;
    emit styleChanged();
    update();
}

void Md3LinearProgressNode::setAmplitude(qreal v)
{
    if (qFuzzyCompare(m_amplitude, v))
        return;
    m_amplitude = v;
    setImplicitHeight(preferredHeight());
    emit styleChanged();
    update();
}

void Md3LinearProgressNode::setTrackThickness(qreal v)
{
    if (qFuzzyCompare(m_thickness, v))
        return;
    m_thickness = v;
    setImplicitHeight(preferredHeight());
    emit styleChanged();
    update();
}

void Md3LinearProgressNode::setWaveSpeed(qreal v)
{
    if (qFuzzyCompare(m_waveSpeed, v))
        return;
    m_waveSpeed = v;
    emit styleChanged();
}

void Md3LinearProgressNode::setProgressTravelMs(int v)
{
    if (m_travelMs == v)
        return;
    m_travelMs = qMax(1, v);
    emit styleChanged();
}

void Md3LinearProgressNode::componentComplete()
{
    QQuickItem::componentComplete();
    syncTicker();
    update();
}

void Md3LinearProgressNode::geometryChange(const QRectF &n, const QRectF &o)
{
    QQuickItem::geometryChange(n, o);
    if (n.size() != o.size())
        update();
}

void Md3LinearProgressNode::itemChange(ItemChange change, const ItemChangeData &data)
{
    QQuickItem::itemChange(change, data);
    if (change == ItemVisibleHasChanged || change == ItemSceneChange
        || change == ItemEnabledHasChanged) {
        syncTicker();
    }
}

bool Md3LinearProgressNode::wantsTick() const
{
    const bool wavy = m_style != Standard;
    return isVisible() && isEnabled() && opacity() > 0.01 && (m_indeterminate || wavy);
}

void Md3LinearProgressNode::syncTicker()
{
    QQuickWindow *w = window();
    if (m_tickConnected && m_tickWindow && m_tickWindow.data() != w) {
        disconnect(m_tickWindow, &QQuickWindow::frameSwapped, this, &Md3LinearProgressNode::onFrameSwapped);
        m_tickConnected = false;
        m_tickWindow = nullptr;
    }
    const bool need = wantsTick() && w;
    if (need && !m_tickConnected) {
        connect(w, &QQuickWindow::frameSwapped, this, &Md3LinearProgressNode::onFrameSwapped);
        m_tickConnected = true;
        m_tickWindow = w;
        m_clock.restart();
    } else if (!need && m_tickConnected) {
        if (m_tickWindow)
            disconnect(m_tickWindow, &QQuickWindow::frameSwapped, this, &Md3LinearProgressNode::onFrameSwapped);
        m_tickConnected = false;
        m_tickWindow = nullptr;
    }
}

void Md3LinearProgressNode::onFrameSwapped()
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

void Md3LinearProgressNode::advance(qreal dt)
{
    const bool wavy = m_style != Standard;
    if (wavy)
        m_wavePhase = std::fmod(m_wavePhase + m_waveSpeed * dt, qreal(M_PI * 2));

    if (m_indeterminate) {
        const qreal barW = wavy ? qMax(48.0, width() * 0.35) : qMax(48.0, width() * 0.35);
        const qreal span = width() + barW;
        m_travelX += span * dt / (m_travelMs / 1000.0);
        if (m_travelX > width())
            m_travelX = -barW;
    }
}

QSGNode *Md3LinearProgressNode::updatePaintNode(QSGNode *oldNode, UpdatePaintNodeData *)
{
    delete oldNode;
    auto *root = new QSGNode;

    const qreal w = width();
    const qreal h = height();
    if (w < 2 || h < 2)
        return root;

    const qreal mid = h * 0.5;
    const qreal thick = m_thickness;
    const qreal progress = qBound(0.0, m_value, 1.0);
    const qreal barW = m_indeterminate ? qMax(48.0, w * 0.35) : w * progress;
    const bool wavy = m_style != Standard && m_amplitude > 0.01;

    if (!wavy) {
        const qreal trackY = mid - thick * 0.5;
        QVector<QSGGeometry::ColoredPoint2D> track;
        Md3Sg::appendDisc(track, QPointF(thick * 0.5, mid), float(thick * 0.5), m_trackColor);
        {
            const qreal bodyW = qMax(0.0, w - thick);
            if (bodyW > 0) {
                const qreal x0 = thick * 0.5;
                QSGGeometry::ColoredPoint2D v0, v1, v2, v3;
                Md3Sg::setVertex(&v0, float(x0), float(trackY), m_trackColor);
                Md3Sg::setVertex(&v1, float(x0 + bodyW), float(trackY), m_trackColor);
                Md3Sg::setVertex(&v2, float(x0), float(trackY + thick), m_trackColor);
                Md3Sg::setVertex(&v3, float(x0 + bodyW), float(trackY + thick), m_trackColor);
                track.append(v0); track.append(v1); track.append(v2);
                track.append(v1); track.append(v3); track.append(v2);
            }
        }
        Md3Sg::appendDisc(track, QPointF(w - thick * 0.5, mid), float(thick * 0.5), m_trackColor);
        Md3Sg::makeColoredNode(Md3Sg::geometryFromColored(track, QSGGeometry::DrawTriangles), root);

        QVector<QSGGeometry::ColoredPoint2D> ind;
        if (m_indeterminate) {
            const qreal x = m_travelX;
            const qreal iw = barW;
            if (iw > 0) {
                Md3Sg::appendDisc(ind, QPointF(x + thick * 0.5, mid), float(thick * 0.5), m_indicatorColor);
                const qreal bodyW = qMax(0.0, iw - thick);
                if (bodyW > 0) {
                    const qreal x0 = x + thick * 0.5;
                    const qreal y0 = trackY;
                    QSGGeometry::ColoredPoint2D v0, v1, v2, v3;
                    Md3Sg::setVertex(&v0, float(x0), float(y0), m_indicatorColor);
                    Md3Sg::setVertex(&v1, float(x0 + bodyW), float(y0), m_indicatorColor);
                    Md3Sg::setVertex(&v2, float(x0), float(y0 + thick), m_indicatorColor);
                    Md3Sg::setVertex(&v3, float(x0 + bodyW), float(y0 + thick), m_indicatorColor);
                    ind.append(v0); ind.append(v1); ind.append(v2);
                    ind.append(v1); ind.append(v3); ind.append(v2);
                }
                Md3Sg::appendDisc(ind, QPointF(x + iw - thick * 0.5, mid), float(thick * 0.5), m_indicatorColor);
            }
        } else {
            const qreal iw = qMin(barW, w);
            if (iw > 0.5) {
                Md3Sg::appendDisc(ind, QPointF(thick * 0.5, mid), float(thick * 0.5), m_indicatorColor);
                const qreal bodyW = qMax(0.0, iw - thick);
                if (bodyW > 0) {
                    const qreal x0 = thick * 0.5;
                    QSGGeometry::ColoredPoint2D v0, v1, v2, v3;
                    Md3Sg::setVertex(&v0, float(x0), float(trackY), m_indicatorColor);
                    Md3Sg::setVertex(&v1, float(x0 + bodyW), float(trackY), m_indicatorColor);
                    Md3Sg::setVertex(&v2, float(x0), float(trackY + thick), m_indicatorColor);
                    Md3Sg::setVertex(&v3, float(x0 + bodyW), float(trackY + thick), m_indicatorColor);
                    ind.append(v0); ind.append(v1); ind.append(v2);
                    ind.append(v1); ind.append(v3); ind.append(v2);
                }
                if (iw > thick)
                    Md3Sg::appendDisc(ind, QPointF(iw - thick * 0.5, mid), float(thick * 0.5), m_indicatorColor);
            }
            if (m_showStop && progress < 0.999)
                Md3Sg::appendDisc(ind, QPointF(w - thick * 0.5, mid), float(thick * 0.5), m_indicatorColor);
        }
        if (!ind.isEmpty())
            Md3Sg::makeColoredNode(Md3Sg::geometryFromColored(ind, QSGGeometry::DrawTriangles), root);
        return root;
    }

    // Wavy: thick polyline along sine (GPU triangle strip)
    auto buildWave = [&](qreal fromX, qreal toX, const QColor &color,
                         QVector<QSGGeometry::ColoredPoint2D> &out) {
        if (toX <= fromX + 0.5)
            return;
        const qreal wl = qMax(8.0, m_wavelength);
        const int steps = qMax(2, int(std::ceil((toX - fromX) / 2.0)));
        QVector<QPointF> pts;
        pts.reserve(steps + 1);
        for (int i = 0; i <= steps; ++i) {
            const qreal t = qreal(i) / steps;
            const qreal x = fromX + (toX - fromX) * t;
            const qreal y = mid + std::sin((x / wl) * M_PI * 2 + m_wavePhase) * m_amplitude;
            pts.append(QPointF(x, y));
        }
        Md3Sg::appendThickPolyline(out, pts, float(thick * 0.5), color);
    };

    QVector<QSGGeometry::ColoredPoint2D> lines;
    buildWave(thick * 0.5, w - thick * 0.5, m_trackColor, lines);
    if (m_indeterminate)
        buildWave(m_travelX, m_travelX + barW, m_indicatorColor, lines);
    else {
        const qreal end = qMax(thick * 0.5, (w - thick) * progress + thick * 0.5);
        buildWave(thick * 0.5, end, m_indicatorColor, lines);
    }
    if (!lines.isEmpty())
        Md3Sg::makeColoredNode(Md3Sg::geometryFromColored(lines, QSGGeometry::DrawTriangleStrip), root);

    if (!m_indeterminate && m_showStop && progress < 0.999) {
        QVector<QSGGeometry::ColoredPoint2D> stop;
        Md3Sg::appendDisc(stop, QPointF(w - thick * 0.5, mid), float(thick * 0.5), m_indicatorColor);
        Md3Sg::makeColoredNode(Md3Sg::geometryFromColored(stop, QSGGeometry::DrawTriangles), root);
    }
    return root;
}
