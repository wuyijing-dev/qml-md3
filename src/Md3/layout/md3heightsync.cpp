#include "md3heightsync.h"

#include <QMetaObject>
#include <QQuickItem>
#include <cmath>

Md3HeightSync::Md3HeightSync(QObject *parent)
    : QObject(parent)
{
}

Md3HeightSync::~Md3HeightSync() = default;

QQuickItem *Md3HeightSync::target() const
{
    return m_target.data();
}

void Md3HeightSync::setTarget(QQuickItem *item)
{
    if (m_target.data() == item)
        return;
    if (m_target)
        disconnect(m_target, nullptr, this, nullptr);
    m_target = item;
    reconnect();
    emit targetChanged();
    scheduleSync();
}

void Md3HeightSync::setEnabled(bool on)
{
    if (m_enabled == on)
        return;
    m_enabled = on;
    emit enabledChanged();
    scheduleSync();
}

void Md3HeightSync::setSyncHeight(bool on)
{
    if (m_syncHeight == on)
        return;
    m_syncHeight = on;
    emit syncHeightChanged();
    scheduleSync();
}

void Md3HeightSync::setSyncWidth(bool on)
{
    if (m_syncWidth == on)
        return;
    m_syncWidth = on;
    emit syncWidthChanged();
    scheduleSync();
}

void Md3HeightSync::setPolicy(int policy)
{
    if (policy != Exact && policy != AtLeastImplicit)
        policy = AtLeastImplicit;
    if (m_policy == policy)
        return;
    m_policy = policy;
    emit policyChanged();
    scheduleSync();
}

void Md3HeightSync::setEpsilon(qreal eps)
{
    if (eps < 0)
        eps = 0;
    if (std::abs(m_epsilon - eps) < 1e-6)
        return;
    m_epsilon = eps;
    emit epsilonChanged();
}

void Md3HeightSync::syncNow()
{
    applySync();
}

void Md3HeightSync::reconnect()
{
    if (!m_target)
        return;

    connect(m_target, &QQuickItem::implicitHeightChanged, this, &Md3HeightSync::scheduleSync);
    connect(m_target, &QQuickItem::implicitWidthChanged, this, &Md3HeightSync::scheduleSync);
}

void Md3HeightSync::scheduleSync()
{
    if (!m_enabled || !m_target || m_pending)
        return;
    m_pending = true;
    QMetaObject::invokeMethod(this, [this]() {
        m_pending = false;
        applySync();
    }, Qt::QueuedConnection);
}

qreal Md3HeightSync::resolvedHeight(qreal current, qreal implicit) const
{
    if (m_policy == Exact)
        return implicit;
    return std::max(current, implicit);
}

qreal Md3HeightSync::resolvedWidth(qreal current, qreal implicit) const
{
    if (m_policy == Exact)
        return implicit;
    return std::max(current, implicit);
}

bool Md3HeightSync::applySync()
{
    if (!m_enabled || !m_target || m_applying)
        return false;

    m_applying = true;
    bool wrote = false;

    if (m_syncHeight) {
        const qreal next = resolvedHeight(m_target->height(), m_target->implicitHeight());
        if (std::abs(m_target->height() - next) >= m_epsilon) {
            m_target->setHeight(next);
            wrote = true;
        }
    }
    if (m_syncWidth) {
        const qreal next = resolvedWidth(m_target->width(), m_target->implicitWidth());
        if (std::abs(m_target->width() - next) >= m_epsilon) {
            m_target->setWidth(next);
            wrote = true;
        }
    }

    m_applying = false;
    return wrote;
}
