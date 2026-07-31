#include "md3qtcompat.h"

#include <QQuickItem>
#include <QtGlobal>
#include <algorithm>
#include <cmath>

namespace {
constexpr qreal kEps = 0.5;

bool childExpandTrue(const QQuickItem *item)
{
    if (!item)
        return false;
    const QVariant v = item->property("expand");
    return v.isValid() && v.toBool();
}
} // namespace

Md3QtCompat::Md3QtCompat(QObject *parent)
    : QObject(parent)
{
}

int Md3QtCompat::qtMajor() const
{
    return QT_VERSION_MAJOR;
}

int Md3QtCompat::qtMinor() const
{
    return QT_VERSION_MINOR;
}

int Md3QtCompat::qtPatch() const
{
    return QT_VERSION_PATCH;
}

QString Md3QtCompat::qtVersion() const
{
    return QStringLiteral("%1.%2.%3")
        .arg(QT_VERSION_MAJOR)
        .arg(QT_VERSION_MINOR)
        .arg(QT_VERSION_PATCH);
}

bool Md3QtCompat::atLeast65() const
{
    return QT_VERSION >= QT_VERSION_CHECK(6, 5, 0);
}

bool Md3QtCompat::atLeast68() const
{
    return QT_VERSION >= QT_VERSION_CHECK(6, 8, 0);
}

bool Md3QtCompat::atLeast610() const
{
    return QT_VERSION >= QT_VERSION_CHECK(6, 10, 0);
}

bool Md3QtCompat::nearlyEqual(qreal a, qreal b)
{
    return std::abs(a - b) < kEps;
}

qreal Md3QtCompat::preferredHeight(QQuickItem *item) const
{
    if (!item)
        return 0;
    return std::max<qreal>({ item->height(), item->implicitHeight(), qreal(0) });
}

qreal Md3QtCompat::preferredWidth(QQuickItem *item) const
{
    if (!item)
        return 0;
    return std::max<qreal>({ item->width(), item->implicitWidth(), qreal(0) });
}

bool Md3QtCompat::syncHeightFromImplicit(QQuickItem *item, bool exact) const
{
    if (!item)
        return false;
    const qreal ih = item->implicitHeight();
    const qreal next = exact ? ih : std::max(item->height(), ih);
    if (nearlyEqual(item->height(), next))
        return false;
    item->setHeight(next);
    return true;
}

bool Md3QtCompat::syncWidthFromImplicit(QQuickItem *item, bool exact) const
{
    if (!item)
        return false;
    const qreal iw = item->implicitWidth();
    const qreal next = exact ? iw : std::max(item->width(), iw);
    if (nearlyEqual(item->width(), next))
        return false;
    item->setWidth(next);
    return true;
}

int Md3QtCompat::syncSubtreeHeights(QQuickItem *root, int maxDepth) const
{
    if (!root || maxDepth < 0)
        return 0;
    return syncSubtreeHeightsImpl(root, maxDepth);
}

int Md3QtCompat::syncSubtreeHeightsImpl(QQuickItem *item, int depthLeft) const
{
    if (!item)
        return 0;

    int n = 0;
    if (!childExpandTrue(item)) {
        if (syncHeightFromImplicit(item))
            ++n;
    }

    if (depthLeft <= 0)
        return n;

    const auto kids = item->childItems();
    for (QQuickItem *child : kids) {
        if (!child || !child->isVisible())
            continue;
        n += syncSubtreeHeightsImpl(child, depthLeft - 1);
    }
    return n;
}
