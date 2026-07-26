#pragma once

#include <QColor>
#include <QElapsedTimer>
#include <QPointer>
#include <QQuickItem>
#include <QQuickWindow>
#include <QtQml/qqmlregistration.h>

/// GPU circular progress (Scene Graph). Canvas path archived under components/archive/.
class Md3CircularProgressNode : public QQuickItem
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(qreal value READ value WRITE setValue NOTIFY valueChanged)
    Q_PROPERTY(bool indeterminate READ indeterminate WRITE setIndeterminate NOTIFY indeterminateChanged)
    Q_PROPERTY(int style READ style WRITE setStyle NOTIFY styleChanged)
    Q_PROPERTY(QColor trackColor READ trackColor WRITE setTrackColor NOTIFY colorsChanged)
    Q_PROPERTY(QColor indicatorColor READ indicatorColor WRITE setIndicatorColor NOTIFY colorsChanged)
    Q_PROPERTY(qreal strokeWidth READ strokeWidth WRITE setStrokeWidth NOTIFY styleChanged)
    Q_PROPERTY(qreal amplitude READ amplitude WRITE setAmplitude NOTIFY styleChanged)
    Q_PROPERTY(int waveCount READ waveCount WRITE setWaveCount NOTIFY styleChanged)
    Q_PROPERTY(qreal waveSpeed READ waveSpeed WRITE setWaveSpeed NOTIFY styleChanged)
    Q_PROPERTY(int progressSpinMs READ progressSpinMs WRITE setProgressSpinMs NOTIFY styleChanged)
    Q_PROPERTY(int progressSweepMs READ progressSweepMs WRITE setProgressSweepMs NOTIFY styleChanged)
    Q_PROPERTY(qreal indicatorSize READ indicatorSize WRITE setIndicatorSize NOTIFY styleChanged)

public:
    enum Style { Standard = 0, Wavy = 1, Lively = 2, Soft = 3 };
    Q_ENUM(Style)

    explicit Md3CircularProgressNode(QQuickItem *parent = nullptr);

    qreal value() const { return m_value; }
    void setValue(qreal v);
    bool indeterminate() const { return m_indeterminate; }
    void setIndeterminate(bool v);
    int style() const { return m_style; }
    void setStyle(int v);

    QColor trackColor() const { return m_trackColor; }
    void setTrackColor(const QColor &c);
    QColor indicatorColor() const { return m_indicatorColor; }
    void setIndicatorColor(const QColor &c);

    qreal strokeWidth() const { return m_strokeWidth; }
    void setStrokeWidth(qreal v);
    qreal amplitude() const { return m_amplitude; }
    void setAmplitude(qreal v);
    int waveCount() const { return m_waveCount; }
    void setWaveCount(int v);
    qreal waveSpeed() const { return m_waveSpeed; }
    void setWaveSpeed(qreal v);
    int progressSpinMs() const { return m_spinMs; }
    void setProgressSpinMs(int v);
    int progressSweepMs() const { return m_sweepMs; }
    void setProgressSweepMs(int v);
    qreal indicatorSize() const { return m_indicatorSize; }
    void setIndicatorSize(qreal v);

signals:
    void valueChanged();
    void indeterminateChanged();
    void styleChanged();
    void colorsChanged();

protected:
    QSGNode *updatePaintNode(QSGNode *oldNode, UpdatePaintNodeData *) override;
    void itemChange(ItemChange change, const ItemChangeData &data) override;
    void geometryChange(const QRectF &newGeometry, const QRectF &oldGeometry) override;
    void componentComplete() override;

private:
    void applyStyleDefaults();
    void syncTicker();
    void onFrameSwapped();
    void advance(qreal dt);
    bool wantsTick() const;

    qreal m_value = 0;
    bool m_indeterminate = true;
    int m_style = Standard;
    QColor m_trackColor = QColor(230, 224, 233);
    QColor m_indicatorColor = QColor(103, 80, 164);
    qreal m_strokeWidth = 4;
    qreal m_amplitude = 0;
    int m_waveCount = 0;
    qreal m_waveSpeed = 3.4906585;
    int m_spinMs = 1600;
    int m_sweepMs = 1100;
    qreal m_indicatorSize = 48;

    qreal m_wavePhase = 0;
    qreal m_rotation = -1.5707963;
    qreal m_sweep = 1.7278759; // π * 0.55
    qreal m_sweepDir = 1;
    bool m_tickConnected = false;
    QPointer<QQuickWindow> m_tickWindow;
    QElapsedTimer m_clock;
};
