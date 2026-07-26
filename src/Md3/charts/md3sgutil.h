#pragma once

#include <QColor>
#include <QPointF>
#include <QSGGeometry>
#include <QSGGeometryNode>
#include <QSGNode>
#include <QSGVertexColorMaterial>
#include <QVector>
#include <QtMath>

#include <cmath>

#ifndef M_PI
#  define M_PI 3.14159265358979323846
#endif

/// Shared Scene Graph helpers for MD3 GPU-drawn controls (charts, progress, …).
namespace Md3Sg {

inline void setVertex(QSGGeometry::ColoredPoint2D *v, float x, float y, const QColor &c)
{
    v->set(x, y, quint8(c.red()), quint8(c.green()), quint8(c.blue()), quint8(c.alpha()));
}

inline QSGGeometryNode *makeColoredNode(QSGGeometry *geometry, QSGNode *parent)
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

inline QSGGeometry *geometryFromColored(const QVector<QSGGeometry::ColoredPoint2D> &verts,
                                        QSGGeometry::DrawingMode mode)
{
    auto *g = new QSGGeometry(QSGGeometry::defaultAttributes_ColoredPoint2D(), verts.size());
    g->setDrawingMode(mode);
    auto *v = g->vertexDataAsColoredPoint2D();
    for (int i = 0; i < verts.size(); ++i)
        v[i] = verts[i];
    return g;
}

inline void appendThickPolyline(QVector<QSGGeometry::ColoredPoint2D> &out,
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

inline void appendRoundRectStrip(QVector<QSGGeometry::ColoredPoint2D> &out,
                                 qreal x, qreal y, qreal w, qreal h,
                                 const QColor &color)
{
    if (w <= 0 || h <= 0)
        return;
    // Capsule approximation: rectangle body (radius = h/2 handled by round ends via circles if needed).
    // Body as triangle strip.
    QSGGeometry::ColoredPoint2D v[4];
    setVertex(&v[0], float(x), float(y), color);
    setVertex(&v[1], float(x + w), float(y), color);
    setVertex(&v[2], float(x), float(y + h), color);
    setVertex(&v[3], float(x + w), float(y + h), color);
    if (!out.isEmpty()) {
        out.append(out.last());
        out.append(v[0]);
    }
    out.append(v[0]);
    out.append(v[1]);
    out.append(v[2]);
    out.append(v[3]);
}

inline void appendDisc(QVector<QSGGeometry::ColoredPoint2D> &out,
                       const QPointF &c, float radius, const QColor &color, int segments = 16)
{
    if (radius <= 0.f)
        return;
    QSGGeometry::ColoredPoint2D center;
    setVertex(&center, float(c.x()), float(c.y()), color);
    for (int i = 0; i < segments; ++i) {
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

inline void appendCapsule(QVector<QSGGeometry::ColoredPoint2D> &out,
                          qreal x, qreal y, qreal w, qreal h, const QColor &color)
{
    if (w <= 0 || h <= 0)
        return;
    const qreal r = h * 0.5;
    const qreal bodyW = qMax(0.0, w - h);
    const qreal bodyX = x + r;
    appendDisc(out, QPointF(x + r, y + r), float(r), color);
    if (bodyW > 0)
        appendRoundRectStrip(out, bodyX, y, bodyW, h, color);
    appendDisc(out, QPointF(x + w - r, y + r), float(r), color);
}

} // namespace Md3Sg
