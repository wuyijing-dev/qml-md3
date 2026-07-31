#pragma once

#include <QObject>
#include <QPointer>
#include <QtQml/qqmlregistration.h>

class QQuickItem;

/// Keeps a QQuickItem's height (and optionally width) aligned with implicit size.
/// Implements Md3's strict layout policy in C++ so Qt 6.5 / 6.8 / 6.10 match
/// (Column / Flickable consume height, not implicit-only).
class Md3HeightSync : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QQuickItem *target READ target WRITE setTarget NOTIFY targetChanged)
    Q_PROPERTY(bool enabled READ enabled WRITE setEnabled NOTIFY enabledChanged)
    Q_PROPERTY(bool syncHeight READ syncHeight WRITE setSyncHeight NOTIFY syncHeightChanged)
    Q_PROPERTY(bool syncWidth READ syncWidth WRITE setSyncWidth NOTIFY syncWidthChanged)
    Q_PROPERTY(int policy READ policy WRITE setPolicy NOTIFY policyChanged)
    Q_PROPERTY(qreal epsilon READ epsilon WRITE setEpsilon NOTIFY epsilonChanged)

public:
    enum Policy {
        /// height = implicitHeight (body slots that Column must measure).
        Exact = 0,
        /// height = max(height, implicitHeight) — fixes collapse without fighting parents.
        AtLeastImplicit = 1
    };
    Q_ENUM(Policy)

    explicit Md3HeightSync(QObject *parent = nullptr);
    ~Md3HeightSync() override;

    QQuickItem *target() const;
    void setTarget(QQuickItem *item);

    bool enabled() const { return m_enabled; }
    void setEnabled(bool on);

    bool syncHeight() const { return m_syncHeight; }
    void setSyncHeight(bool on);

    bool syncWidth() const { return m_syncWidth; }
    void setSyncWidth(bool on);

    int policy() const { return m_policy; }
    void setPolicy(int policy);

    qreal epsilon() const { return m_epsilon; }
    void setEpsilon(qreal eps);

    Q_INVOKABLE void syncNow();

signals:
    void targetChanged();
    void enabledChanged();
    void syncHeightChanged();
    void syncWidthChanged();
    void policyChanged();
    void epsilonChanged();

private:
    void reconnect();
    void scheduleSync();
    bool applySync();
    qreal resolvedHeight(qreal current, qreal implicit) const;
    qreal resolvedWidth(qreal current, qreal implicit) const;

    QPointer<QQuickItem> m_target;
    bool m_enabled = true;
    bool m_syncHeight = true;
    bool m_syncWidth = false;
    bool m_applying = false;
    bool m_pending = false;
    int m_policy = AtLeastImplicit;
    qreal m_epsilon = 0.5;
};
