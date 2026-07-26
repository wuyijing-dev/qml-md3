#include "md3linechart.h"

#include <QPainter>
#include <QSGGeometry>
#include <QSGGeometryNode>
#include <QSGSimpleTextureNode>
#include <QSGVertexColorMaterial>
#include <QQuickWindow>
#include <QtMath>

#include <cmath>
#include <cstring>
#include <limits>

#ifndef M_PI
#  define M_PI 3.14159265358979323846
#endif

namespace {

struct PlotRect {
    qreal left = 0;
    qreal right = 0;
    qreal top = 0;
    qreal bottom = 0;
    qreal width() const { return right - left; }
    qreal height() const { return bottom - top; }
};

QSGGeometryNode *makeColoredNode(QSGGeometry *geometry, QSGNode *parent)
{
    auto *node = new QSGGeometryNode;
    node->setGeometry(geometry);
    node->setFlag(QSGNode::OwnsGeometry);
    auto *mat = new QSGVertexColorMaterial;
    node->setMaterial(mat);
    node->setFlag(QSGNode::OwnsMaterial);
    parent->appendChildNode(node);
    return node;
}

void setVertex(QSGGeometry::ColoredPoint2D *v, float x, float y, const QColor &c)
{
    v->set(x, y, quint8(c.red()), quint8(c.green()), quint8(c.blue()), quint8(c.alpha()));
}

void appendThickPolyline(QVector<QSGGeometry::ColoredPoint2D> &out,
                         const QVector<QPointF> &pts,
                         float halfW,
                         const QColor &color)
{
    const int n = pts.size();
    if (n < 2 || halfW <= 0.f)
        return;

    for (int i = 0; i < n - 1; ++i) {
        const QPointF a = pts[i];
        const QPointF b = pts[i + 1];
        QPointF d = b - a;
        const qreal len = std::hypot(d.x(), d.y());
        if (len < 1e-6)
            continue;
        d /= len;
        const QPointF nrm(-d.y() * halfW, d.x() * halfW);

        QSGGeometry::ColoredPoint2D v0, v1, v2, v3;
        setVertex(&v0, float(a.x() + nrm.x()), float(a.y() + nrm.y()), color);
        setVertex(&v1, float(a.x() - nrm.x()), float(a.y() - nrm.y()), color);
        setVertex(&v2, float(b.x() + nrm.x()), float(b.y() + nrm.y()), color);
        setVertex(&v3, float(b.x() - nrm.x()), float(b.y() - nrm.y()), color);

        // Degenerate restart between segments keeps a single triangle strip continuous.
        if (!out.isEmpty()) {
            out.append(out.last());
            out.append(v0);
        }
        out.append(v0);
        out.append(v1);
        out.append(v2);
        out.append(v3);
    }
}

void appendAreaStrip(QVector<QSGGeometry::ColoredPoint2D> &out,
                     const QVector<QPointF> &pts,
                     qreal baselineY,
                     const QColor &color)
{
    if (pts.size() < 2)
        return;
    QColor fill = color;
    if (fill.alpha() > 200)
        fill.setAlpha(56);
    for (const QPointF &p : pts) {
        QSGGeometry::ColoredPoint2D top, bot;
        setVertex(&top, float(p.x()), float(p.y()), fill);
        setVertex(&bot, float(p.x()), float(baselineY), fill);
        out.append(top);
        out.append(bot);
    }
}

void appendDotFan(QVector<QSGGeometry::ColoredPoint2D> &out,
                  const QPointF &c,
                  float radius,
                  const QColor &color,
                  int segments = 12)
{
    if (radius <= 0.f)
        return;
    QSGGeometry::ColoredPoint2D center;
    setVertex(&center, float(c.x()), float(c.y()), color);
    for (int i = 0; i <= segments; ++i) {
        const float a0 = float(i) / float(segments) * float(M_PI * 2.0);
        const float a1 = float(i + 1) / float(segments) * float(M_PI * 2.0);
        QSGGeometry::ColoredPoint2D p0, p1;
        setVertex(&p0, float(c.x() + std::cos(a0) * radius), float(c.y() + std::sin(a0) * radius), color);
        setVertex(&p1, float(c.x() + std::cos(a1) * radius), float(c.y() + std::sin(a1) * radius), color);
        out.append(center);
        out.append(p0);
        out.append(p1);
    }
}

QSGGeometry *geometryFromColored(const QVector<QSGGeometry::ColoredPoint2D> &verts,
                                 QSGGeometry::DrawingMode mode)
{
    auto *g = new QSGGeometry(QSGGeometry::defaultAttributes_ColoredPoint2D(), verts.size());
    g->setDrawingMode(mode);
    auto *v = g->vertexDataAsColoredPoint2D();
    for (int i = 0; i < verts.size(); ++i)
        v[i] = verts[i];
    return g;
}

} // namespace

Md3LineChart::Md3LineChart(QQuickItem *parent)
    : QQuickItem(parent)
{
    setFlag(ItemHasContents, true);
    setAntialiasing(true);
    setImplicitSize(280, 160);
}

void Md3LineChart::geometryChange(const QRectF &newGeometry, const QRectF &oldGeometry)
{
    QQuickItem::geometryChange(newGeometry, oldGeometry);
    if (newGeometry.size() != oldGeometry.size())
        markDirty();
}

void Md3LineChart::markDirty()
{
    update();
}

void Md3LineChart::setRenderedCount(int n)
{
    if (m_renderedPointCount == n)
        return;
    m_renderedPointCount = n;
    emit renderedPointCountChanged();
}

Md3LineChart::Series Md3LineChart::variantToSeries(const QVariant &v)
{
    Series out;
    if (!v.isValid() || v.isNull())
        return out;

    if (v.userType() == QMetaType::QVariantList || v.canConvert<QVariantList>()) {
        const QVariantList list = v.toList();
        out.reserve(list.size());
        for (const QVariant &item : list) {
            if (item.canConvert<qreal>()) {
                out.push_back(float(item.toReal()));
            } else if (item.typeId() == QMetaType::QVariantMap) {
                const auto map = item.toMap();
                if (map.contains(QStringLiteral("y")))
                    out.push_back(float(map.value(QStringLiteral("y")).toReal()));
            }
        }
        return out;
    }

    if (v.canConvert<QVariantList>()) {
        return variantToSeries(QVariant::fromValue(v.toList()));
    }
    return out;
}

Md3LineChart::Series Md3LineChart::downsampleMinMax(const Series &in, int target)
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

QVector<QPointF> Md3LineChart::catmullRom(const QVector<QPointF> &pts, int segmentsPer)
{
    const int n = pts.size();
    if (n < 3 || segmentsPer < 1)
        return pts;

    QVector<QPointF> out;
    out.reserve((n - 1) * segmentsPer + 1);
    out.push_back(pts.first());
    for (int i = 0; i < n - 1; ++i) {
        const QPointF p0 = pts[qMax(0, i - 1)];
        const QPointF p1 = pts[i];
        const QPointF p2 = pts[i + 1];
        const QPointF p3 = pts[qMin(n - 1, i + 2)];
        for (int s = 1; s <= segmentsPer; ++s) {
            const qreal t = qreal(s) / segmentsPer;
            const qreal t2 = t * t;
            const qreal t3 = t2 * t;
            const QPointF q =
                0.5 * ((2.0 * p1)
                       + (-p0 + p2) * t
                       + (2.0 * p0 - 5.0 * p1 + 4.0 * p2 - p3) * t2
                       + (-p0 + 3.0 * p1 - 3.0 * p2 + p3) * t3);
            out.push_back(q);
        }
    }
    return out;
}

QPair<qreal, qreal> Md3LineChart::computeRange(const QVector<Series> &all) const
{
    if (!qIsNaN(m_minY) && !qIsNaN(m_maxY) && m_maxY > m_minY)
        return {m_minY, m_maxY};

    qreal lo = std::numeric_limits<qreal>::infinity();
    qreal hi = -std::numeric_limits<qreal>::infinity();
    bool found = false;
    for (const Series &s : all) {
        const int step = s.size() > 200000 ? qMax(1, s.size() / 100000) : 1;
        for (int i = 0; i < s.size(); i += step) {
            found = true;
            lo = qMin(lo, qreal(s[i]));
            hi = qMax(hi, qreal(s[i]));
        }
        if (!s.isEmpty()) {
            found = true;
            lo = qMin(lo, qreal(s.first()));
            hi = qMax(hi, qreal(s.last()));
            lo = qMin(lo, qreal(s.last()));
            hi = qMax(hi, qreal(s.first()));
        }
    }
    if (!found)
        return {0.0, 1.0};
    if (hi <= lo) {
        lo -= 1.0;
        hi += 1.0;
    }
    const qreal pad = (hi - lo) * 0.08;
    return {lo - pad, hi + pad};
}

QColor Md3LineChart::colorAt(int index) const
{
    if (index < m_seriesColors.size()) {
        const QVariant v = m_seriesColors.at(index);
        if (v.canConvert<QColor>())
            return v.value<QColor>();
    }
    if (index == 0)
        return m_lineColor;
    static const QColor roles[] = {
        QColor(103, 80, 164),
        QColor(98, 91, 113),
        QColor(125, 82, 96),
        QColor(179, 38, 30)
    };
    return roles[index % 4];
}

QVector<Md3LineChart::Series> Md3LineChart::activeSeries() const
{
    if (m_useMulti && !m_multi.isEmpty())
        return m_multi;
    if (!m_values.isEmpty())
        return {m_values};
    return {};
}

int Md3LineChart::rawPointCount() const
{
    int n = 0;
    for (const Series &s : activeSeries())
        n += s.size();
    return n;
}

QVariant Md3LineChart::values() const
{
    QVariantList list;
    list.reserve(m_values.size());
    for (float v : m_values)
        list.append(v);
    return list;
}

void Md3LineChart::setValues(const QVariant &v)
{
    m_values = variantToSeries(v);
    m_useMulti = false;
    m_multi.clear();
    emit valuesChanged();
    markDirty();
}

QVariant Md3LineChart::series() const
{
    QVariantList outer;
    for (const Series &s : m_multi) {
        QVariantList inner;
        inner.reserve(s.size());
        for (float v : s)
            inner.append(v);
        outer.append(QVariant(inner));
    }
    return outer;
}

void Md3LineChart::setSeries(const QVariant &v)
{
    m_multi.clear();
    const QVariantList outer = v.toList();
    for (const QVariant &item : outer)
        m_multi.push_back(variantToSeries(item));
    m_useMulti = !m_multi.isEmpty();
    if (m_useMulti)
        m_values.clear();
    emit seriesChanged();
    emit valuesChanged();
    markDirty();
}

void Md3LineChart::setSeriesColors(const QVariantList &c)
{
    if (m_seriesColors == c)
        return;
    m_seriesColors = c;
    emit styleChanged();
    markDirty();
}

#define MD3_CHART_SETTER(type, name, member, signal) \
    void Md3LineChart::set##name(type v)              \
    {                                                 \
        if (member == v)                              \
            return;                                   \
        member = v;                                   \
        emit signal();                                \
        markDirty();                                  \
    }

MD3_CHART_SETTER(const QColor &, LineColor, m_lineColor, styleChanged)
MD3_CHART_SETTER(const QColor &, FillColor, m_fillColor, styleChanged)
MD3_CHART_SETTER(const QColor &, GridColor, m_gridColor, styleChanged)
MD3_CHART_SETTER(const QColor &, AxisLabelColor, m_axisLabelColor, styleChanged)
MD3_CHART_SETTER(const QColor &, BackgroundColor, m_backgroundColor, styleChanged)
MD3_CHART_SETTER(qreal, LineWidth, m_lineWidth, styleChanged)
MD3_CHART_SETTER(bool, ShowArea, m_showArea, styleChanged)
MD3_CHART_SETTER(bool, ShowDots, m_showDots, styleChanged)
MD3_CHART_SETTER(bool, ShowGrid, m_showGrid, styleChanged)
MD3_CHART_SETTER(bool, ShowYLabels, m_showYLabels, styleChanged)
MD3_CHART_SETTER(bool, ShowXLabels, m_showXLabels, styleChanged)
MD3_CHART_SETTER(bool, Smooth, m_smooth, styleChanged)
MD3_CHART_SETTER(qreal, MinY, m_minY, rangeChanged)
MD3_CHART_SETTER(qreal, MaxY, m_maxY, rangeChanged)
MD3_CHART_SETTER(int, HorizontalGridLines, m_horizontalGridLines, styleChanged)
MD3_CHART_SETTER(qreal, ContentPadding, m_contentPadding, styleChanged)
MD3_CHART_SETTER(qreal, LabelWidth, m_labelWidth, styleChanged)
MD3_CHART_SETTER(qreal, DotRadius, m_dotRadius, styleChanged)
MD3_CHART_SETTER(int, ValueDecimals, m_valueDecimals, styleChanged)
MD3_CHART_SETTER(int, MaxRenderPoints, m_maxRenderPoints, styleChanged)
MD3_CHART_SETTER(int, SmoothMaxPoints, m_smoothMaxPoints, styleChanged)
MD3_CHART_SETTER(int, DotsMaxPoints, m_dotsMaxPoints, styleChanged)

void Md3LineChart::setYUnit(const QString &u)
{
    if (m_yUnit == u)
        return;
    m_yUnit = u;
    emit styleChanged();
    markDirty();
}

void Md3LineChart::fillSine(int count, qreal mid, qreal amp1, qreal amp2, qreal noise)
{
    count = qMax(0, count);
    Series s;
    s.resize(count);
    for (int i = 0; i < count; ++i) {
        const qreal t = i * 0.002;
        const qreal n = ((i % 997) / 997.0 - 0.5) * noise;
        s[i] = float(mid + std::sin(t) * amp1 + std::sin(t * 0.17) * amp2 + n);
    }
    m_values = std::move(s);
    m_useMulti = false;
    m_multi.clear();
    emit valuesChanged();
    markDirty();
}

void Md3LineChart::setFloatValues(const QByteArray &floats)
{
    const int n = floats.size() / int(sizeof(float));
    Series s;
    s.resize(n);
    if (n > 0)
        memcpy(s.data(), floats.constData(), size_t(n) * sizeof(float));
    m_values = std::move(s);
    m_useMulti = false;
    m_multi.clear();
    emit valuesChanged();
    markDirty();
}

void Md3LineChart::clear()
{
    m_values.clear();
    m_multi.clear();
    m_useMulti = false;
    emit valuesChanged();
    emit seriesChanged();
    markDirty();
}

QSGNode *Md3LineChart::updatePaintNode(QSGNode *oldNode, UpdatePaintNodeData *)
{
    delete oldNode;
    auto *root = new QSGNode;

    const qreal w = width();
    const qreal h = height();
    if (w < 2 || h < 2) {
        setRenderedCount(0);
        return root;
    }

    PlotRect plot;
    const qreal pad = m_contentPadding;
    const qreal labelW = m_showYLabels ? m_labelWidth : 0;
    plot.left = pad + labelW;
    plot.right = w - pad;
    plot.top = pad + 4;
    plot.bottom = h - pad - (m_showXLabels ? 16 : 0);
    if (plot.width() < 1 || plot.height() < 1) {
        setRenderedCount(0);
        return root;
    }

    if (m_backgroundColor.alpha() > 0) {
        QVector<QSGGeometry::ColoredPoint2D> bg;
        bg.resize(4);
        setVertex(&bg[0], 0, 0, m_backgroundColor);
        setVertex(&bg[1], float(w), 0, m_backgroundColor);
        setVertex(&bg[2], 0, float(h), m_backgroundColor);
        setVertex(&bg[3], float(w), float(h), m_backgroundColor);
        auto *g = geometryFromColored(bg, QSGGeometry::DrawTriangleStrip);
        makeColoredNode(g, root);
    }

    const QVector<Series> all = activeSeries();
    const auto range = computeRange(all);
    const qreal span = qMax(1e-6, range.second - range.first);
    const int target = m_maxRenderPoints > 0
                           ? m_maxRenderPoints
                           : qMax(64, int(std::floor(plot.width() * 2.5)));

    auto yAt = [&](qreal v) {
        return plot.top + plot.height() * (1.0 - (v - range.first) / span);
    };

    if (m_showGrid && m_horizontalGridLines > 0) {
        QVector<QSGGeometry::ColoredPoint2D> gridVerts;
        QColor gc = m_gridColor;
        gc.setAlpha(qRound(gc.alpha() * 0.5));
        for (int g = 0; g <= m_horizontalGridLines; ++g) {
            const qreal t = qreal(g) / m_horizontalGridLines;
            const qreal y = plot.top + plot.height() * (1.0 - t);
            QSGGeometry::ColoredPoint2D a, b;
            setVertex(&a, float(plot.left), float(y), gc);
            setVertex(&b, float(plot.right), float(y), gc);
            gridVerts.append(a);
            gridVerts.append(b);
        }
        auto *g = geometryFromColored(gridVerts, QSGGeometry::DrawLines);
        makeColoredNode(g, root);
    }

    int rendered = 0;
    for (int s = 0; s < all.size(); ++s) {
        const Series raw = all[s];
        if (raw.isEmpty())
            continue;
        const Series nums = downsampleMinMax(raw, target);
        const int n = nums.size();
        rendered += n;

        QVector<QPointF> pts;
        pts.reserve(n);
        for (int i = 0; i < n; ++i) {
            const qreal x = n == 1 ? (plot.left + plot.width() * 0.5)
                                   : (plot.left + plot.width() * qreal(i) / (n - 1));
            pts.append(QPointF(x, yAt(nums[i])));
        }

        const bool useSmooth = m_smooth && raw.size() <= m_smoothMaxPoints && n <= m_smoothMaxPoints;
        if (useSmooth)
            pts = catmullRom(pts, 4);

        const QColor col = colorAt(s);

        if (m_showArea) {
            QColor fill = (s == 0) ? m_fillColor : col;
            if (s > 0)
                fill.setAlpha(31);
            else if (fill.alpha() == 255)
                fill.setAlpha(56);
            QVector<QSGGeometry::ColoredPoint2D> area;
            appendAreaStrip(area, pts, plot.bottom, fill);
            auto *g = geometryFromColored(area, QSGGeometry::DrawTriangleStrip);
            makeColoredNode(g, root);
        }

        {
            QVector<QSGGeometry::ColoredPoint2D> stroke;
            appendThickPolyline(stroke, pts, float(m_lineWidth * 0.5), col);
            auto *g = geometryFromColored(stroke, QSGGeometry::DrawTriangleStrip);
            makeColoredNode(g, root);
        }

        const bool useDots = m_showDots && n <= m_dotsMaxPoints;
        if (useDots) {
            QVector<QSGGeometry::ColoredPoint2D> dots;
            for (const QPointF &p : pts) {
                appendDotFan(dots, p, float(m_dotRadius), col);
                QColor hole = m_backgroundColor.alpha() > 0 ? m_backgroundColor : QColor(255, 255, 255);
                // Inner hole approximates surface; use near-white if transparent bg.
                if (m_backgroundColor.alpha() == 0)
                    hole = QColor(250, 250, 250);
                appendDotFan(dots, p, float(qMax(1.0, m_dotRadius - 1.2)), hole);
            }
            auto *g = geometryFromColored(dots, QSGGeometry::DrawTriangles);
            makeColoredNode(g, root);
        }
    }

    setRenderedCount(rendered);

    // Axis labels: small CPU texture (text only) — geometry stays on GPU.
    if (m_showYLabels && m_horizontalGridLines >= 0 && window()) {
        const int tw = qMax(1, int(std::ceil(plot.left)));
        const int th = qMax(1, int(std::ceil(h)));
        QImage img(tw, th, QImage::Format_ARGB32_Premultiplied);
        img.fill(Qt::transparent);
        QPainter painter(&img);
        painter.setRenderHint(QPainter::TextAntialiasing, true);
        painter.setPen(m_axisLabelColor);
        QFont font = painter.font();
        font.setPixelSize(11);
        painter.setFont(font);
        for (int g = 0; g <= m_horizontalGridLines; ++g) {
            const qreal t = qreal(g) / qMax(1, m_horizontalGridLines);
            const qreal v = range.first + span * t;
            const qreal y = plot.top + plot.height() * (1.0 - t);
            const QString text = QString::number(v, 'f', m_valueDecimals) + m_yUnit;
            const QRectF rect(0, y - 8, plot.left - 6, 16);
            painter.drawText(rect, Qt::AlignRight | Qt::AlignVCenter, text);
        }
        painter.end();

        QSGTexture *tex = window()->createTextureFromImage(img);
        auto *texNode = new QSGSimpleTextureNode;
        texNode->setTexture(tex);
        texNode->setOwnsTexture(true);
        texNode->setRect(0, 0, tw, th);
        root->appendChildNode(texNode);
    }

    return root;
}
