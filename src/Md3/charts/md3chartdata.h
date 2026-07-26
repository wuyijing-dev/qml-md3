#pragma once

#include <QObject>
#include <QVariantList>
#include <QVector>
#include <QtQml/qqmlregistration.h>

/// High-volume series helper: generate / ingest in C++, expose downsampled points for QML Shapes.
class Md3ChartData : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QVariantList points READ points NOTIFY pointsChanged)
    Q_PROPERTY(int rawCount READ rawCount NOTIFY pointsChanged)
    Q_PROPERTY(int pointCount READ pointCount NOTIFY pointsChanged)
    Q_PROPERTY(int targetPoints READ targetPoints WRITE setTargetPoints NOTIFY targetPointsChanged)

public:
    explicit Md3ChartData(QObject *parent = nullptr);

    QVariantList points() const;
    int rawCount() const { return m_rawCount; }
    int pointCount() const { return m_display.size(); }
    int targetPoints() const { return m_targetPoints; }
    void setTargetPoints(int n);

    /// Build sine in C++ (million-safe) then downsample to targetPoints (0 = keep denser default 512).
    Q_INVOKABLE void fillSine(int count, qreal mid = 50.0, qreal amp1 = 30.0,
                              qreal amp2 = 12.0, qreal noise = 6.0);
    Q_INVOKABLE void setFloatValues(const QByteArray &floats);
    Q_INVOKABLE void setValues(const QVariantList &values);
    Q_INVOKABLE void clear();

signals:
    void pointsChanged();
    void targetPointsChanged();

private:
    using Series = QVector<float>;
    static Series downsampleMinMax(const Series &in, int target);
    void rebuildDisplay();

    Series m_raw;
    Series m_display;
    int m_rawCount = 0;
    int m_targetPoints = 512;
};
