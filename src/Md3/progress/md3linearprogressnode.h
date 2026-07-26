#pragma once

#include <QColor>
#include <QElapsedTimer>
#include <QPointer>
#include <QQuickItem>
#include <QQuickWindow>
#include <QtQml/qqmlregistration.h>

/// GPU linear progress (Scene Graph). Canvas path archived under components/archive/.
class Md3LinearProgressNode : public QQuickItem
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(qreal value READ value WRITE setValue NOTIFY valueChanged)
    Q_PROPERTY(bool indeterminate READ indeterminate WRITE setIndeterminate NOTIFY indeterminateChanged)
    Q_PROPERTY(int style READ style WRITE setStyle NOTIFY styleChanged)
    Q_PROPERTY(QColor trackColor READ trackColor WRITE setTrackColor NOTIFY colorsChanged)
    Q_PROPERTY(QColor indicatorColor READ indicatorColor WRITE setIndicatorColor NOTIFY colorsChanged)
    Q_PROPERTY(bool showStopIndicator READ showStopIndicator WRITE setShowStopIndicator NOTIFY styleChanged)
    Q_PROPERTY(qreal wavelength READ wavelength WRITE setWavelength NOTIFY styleChanged)
    Q_PROPERTY(qreal amplitude READ amplitude WRITE setAmplitude NOTIFY styleChanged)
    Q_PROPERTY(qreal trackThickness READ trackThickness WRITE setTrackThickness NOTIFY styleChanged)
    Q_PROPERTY(qreal waveSpeed READ waveSpeed WRITE setWaveSpeed NOTIFY styleChanged)
    Q_PROPERTY(int progressTravelMs READ progressTravelMs WRITE setProgressTravelMs NOTIFY styleChanged)
    Q_PROPERTY(qreal preferredHeight READ preferredHeight NOTIFY styleChanged)

public:
    enum Style { Standard = 0, Wavy = 1, Lively = 2, Soft = 3 };
    Q_ENUM(Style)

    explicit Md3LinearProgressNode(QQuickItem *parent = nullptr);

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

    bool showStopIndicator() const { return m_showStop; }
    void setShowStopIndicator(bool v);
    qreal wavelength() const { return m_wavelength; }
    void setWavelength(qreal v);
    qreal amplitude() const { return m_amplitude; }
    void setAmplitude(qreal v);
    qreal trackThickness() const { return m_thickness; }
    void setTrackThickness(qreal v);
    qreal waveSpeed() const { return m_waveSpeed; }
    void setWaveSpeed(qreal v);
    int progressTravelMs() const { return m_travelMs; }
    void setProgressTravelMs(int v);
    qreal preferredHeight() const;

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
    bool m_indeterminate = false;
    int m_style = Standard;
    QColor m_trackColor = QColor(230, 224, 233);
    QColor m_indicatorColor = QColor(103, 80, 164);
    bool m_showStop = true;
    qreal m_wavelength = 40;
    qreal m_amplitude = 0;
    qreal m_thickness = 4;
    qreal m_waveSpeed = 3.4906585; // 2π / 1.8
    int m_travelMs = 1800;

    qreal m_wavePhase = 0;
    qreal m_travelX = 0;
    bool m_tickConnected = false;
    QPointer<QQuickWindow> m_tickWindow;
    QElapsedTimer m_clock;
};
