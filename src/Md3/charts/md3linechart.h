#pragma once

#include <QColor>
#include <QQuickItem>
#include <QString>
#include <QVariant>
#include <QVariantList>
#include <QVector>
#include <QtQml/qqmlregistration.h>

/// MD3 line chart via Qt Scene Graph (GPU geometry) — industry path for large series.
/// Downsample on CPU (min/max buckets), draw with QSGGeometry. Canvas/QPainter paths archived / avoided.
class Md3LineChart : public QQuickItem
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QVariant values READ values WRITE setValues NOTIFY valuesChanged)
    Q_PROPERTY(QVariant series READ series WRITE setSeries NOTIFY seriesChanged)
    Q_PROPERTY(QVariantList seriesColors READ seriesColors WRITE setSeriesColors NOTIFY styleChanged)
    Q_PROPERTY(QColor lineColor READ lineColor WRITE setLineColor NOTIFY styleChanged)
    Q_PROPERTY(QColor fillColor READ fillColor WRITE setFillColor NOTIFY styleChanged)
    Q_PROPERTY(QColor gridColor READ gridColor WRITE setGridColor NOTIFY styleChanged)
    Q_PROPERTY(QColor axisLabelColor READ axisLabelColor WRITE setAxisLabelColor NOTIFY styleChanged)
    Q_PROPERTY(QColor backgroundColor READ backgroundColor WRITE setBackgroundColor NOTIFY styleChanged)
    Q_PROPERTY(qreal lineWidth READ lineWidth WRITE setLineWidth NOTIFY styleChanged)
    Q_PROPERTY(bool showArea READ showArea WRITE setShowArea NOTIFY styleChanged)
    Q_PROPERTY(bool showDots READ showDots WRITE setShowDots NOTIFY styleChanged)
    Q_PROPERTY(bool showGrid READ showGrid WRITE setShowGrid NOTIFY styleChanged)
    Q_PROPERTY(bool showYLabels READ showYLabels WRITE setShowYLabels NOTIFY styleChanged)
    Q_PROPERTY(bool showXLabels READ showXLabels WRITE setShowXLabels NOTIFY styleChanged)
    Q_PROPERTY(bool smooth READ smooth WRITE setSmooth NOTIFY styleChanged)
    Q_PROPERTY(qreal minY READ minY WRITE setMinY NOTIFY rangeChanged)
    Q_PROPERTY(qreal maxY READ maxY WRITE setMaxY NOTIFY rangeChanged)
    Q_PROPERTY(int horizontalGridLines READ horizontalGridLines WRITE setHorizontalGridLines NOTIFY styleChanged)
    Q_PROPERTY(qreal contentPadding READ contentPadding WRITE setContentPadding NOTIFY styleChanged)
    Q_PROPERTY(qreal labelWidth READ labelWidth WRITE setLabelWidth NOTIFY styleChanged)
    Q_PROPERTY(qreal dotRadius READ dotRadius WRITE setDotRadius NOTIFY styleChanged)
    Q_PROPERTY(QString yUnit READ yUnit WRITE setYUnit NOTIFY styleChanged)
    Q_PROPERTY(int valueDecimals READ valueDecimals WRITE setValueDecimals NOTIFY styleChanged)
    Q_PROPERTY(int maxRenderPoints READ maxRenderPoints WRITE setMaxRenderPoints NOTIFY styleChanged)
    Q_PROPERTY(int smoothMaxPoints READ smoothMaxPoints WRITE setSmoothMaxPoints NOTIFY styleChanged)
    Q_PROPERTY(int dotsMaxPoints READ dotsMaxPoints WRITE setDotsMaxPoints NOTIFY styleChanged)
    Q_PROPERTY(int rawPointCount READ rawPointCount NOTIFY valuesChanged)
    Q_PROPERTY(int renderedPointCount READ renderedPointCount NOTIFY renderedPointCountChanged)

public:
    explicit Md3LineChart(QQuickItem *parent = nullptr);

    QVariant values() const;
    void setValues(const QVariant &v);

    QVariant series() const;
    void setSeries(const QVariant &v);

    QVariantList seriesColors() const { return m_seriesColors; }
    void setSeriesColors(const QVariantList &c);

    QColor lineColor() const { return m_lineColor; }
    void setLineColor(const QColor &c);
    QColor fillColor() const { return m_fillColor; }
    void setFillColor(const QColor &c);
    QColor gridColor() const { return m_gridColor; }
    void setGridColor(const QColor &c);
    QColor axisLabelColor() const { return m_axisLabelColor; }
    void setAxisLabelColor(const QColor &c);
    QColor backgroundColor() const { return m_backgroundColor; }
    void setBackgroundColor(const QColor &c);

    qreal lineWidth() const { return m_lineWidth; }
    void setLineWidth(qreal w);
    bool showArea() const { return m_showArea; }
    void setShowArea(bool v);
    bool showDots() const { return m_showDots; }
    void setShowDots(bool v);
    bool showGrid() const { return m_showGrid; }
    void setShowGrid(bool v);
    bool showYLabels() const { return m_showYLabels; }
    void setShowYLabels(bool v);
    bool showXLabels() const { return m_showXLabels; }
    void setShowXLabels(bool v);
    bool smooth() const { return m_smooth; }
    void setSmooth(bool v);

    qreal minY() const { return m_minY; }
    void setMinY(qreal v);
    qreal maxY() const { return m_maxY; }
    void setMaxY(qreal v);

    int horizontalGridLines() const { return m_horizontalGridLines; }
    void setHorizontalGridLines(int v);
    qreal contentPadding() const { return m_contentPadding; }
    void setContentPadding(qreal v);
    qreal labelWidth() const { return m_labelWidth; }
    void setLabelWidth(qreal v);
    qreal dotRadius() const { return m_dotRadius; }
    void setDotRadius(qreal v);
    QString yUnit() const { return m_yUnit; }
    void setYUnit(const QString &u);
    int valueDecimals() const { return m_valueDecimals; }
    void setValueDecimals(int v);
    int maxRenderPoints() const { return m_maxRenderPoints; }
    void setMaxRenderPoints(int v);
    int smoothMaxPoints() const { return m_smoothMaxPoints; }
    void setSmoothMaxPoints(int v);
    int dotsMaxPoints() const { return m_dotsMaxPoints; }
    void setDotsMaxPoints(int v);

    int rawPointCount() const;
    int renderedPointCount() const { return m_renderedPointCount; }

    /// Build series in C++ — avoids shipping million-element arrays through QML.
    Q_INVOKABLE void fillSine(int count, qreal mid = 50.0, qreal amp1 = 30.0,
                              qreal amp2 = 12.0, qreal noise = 6.0);
    Q_INVOKABLE void setFloatValues(const QByteArray &floats);
    Q_INVOKABLE void clear();

signals:
    void valuesChanged();
    void seriesChanged();
    void styleChanged();
    void rangeChanged();
    void renderedPointCountChanged();

protected:
    QSGNode *updatePaintNode(QSGNode *oldNode, UpdatePaintNodeData *) override;
    void geometryChange(const QRectF &newGeometry, const QRectF &oldGeometry) override;

private:
    using Series = QVector<float>;

    static Series variantToSeries(const QVariant &v);
    static Series downsampleMinMax(const Series &in, int target);
    static QVector<QPointF> catmullRom(const QVector<QPointF> &pts, int segmentsPer);
    QPair<qreal, qreal> computeRange(const QVector<Series> &all) const;
    QColor colorAt(int index) const;
    QVector<Series> activeSeries() const;
    void markDirty();
    void setRenderedCount(int n);

    QVector<Series> m_multi;
    Series m_values;
    bool m_useMulti = false;

    QVariantList m_seriesColors;
    QColor m_lineColor = QColor(103, 80, 164);
    QColor m_fillColor = QColor(103, 80, 164, 51);
    QColor m_gridColor = QColor(121, 116, 126);
    QColor m_axisLabelColor = QColor(73, 69, 79);
    QColor m_backgroundColor = Qt::transparent;

    qreal m_lineWidth = 2.5;
    bool m_showArea = true;
    bool m_showDots = false;
    bool m_showGrid = true;
    bool m_showYLabels = true;
    bool m_showXLabels = false;
    bool m_smooth = true;
    qreal m_minY = qQNaN();
    qreal m_maxY = qQNaN();
    int m_horizontalGridLines = 4;
    qreal m_contentPadding = 8;
    qreal m_labelWidth = 36;
    qreal m_dotRadius = 3;
    QString m_yUnit;
    int m_valueDecimals = 0;
    int m_maxRenderPoints = 0;
    int m_smoothMaxPoints = 400;
    int m_dotsMaxPoints = 80;
    int m_renderedPointCount = 0;
};
