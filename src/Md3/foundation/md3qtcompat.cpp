#include "md3qtcompat.h"
#include "md3qtversion.h"

#include <QQuickItem>
#include <QtGlobal>
#include <algorithm>
#include <cmath>

namespace {
constexpr qreal kEps = 0.5;

QQuickItem *asItem(QObject *object)
{
    return qobject_cast<QQuickItem *>(object);
}

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
    return MD3_QT_AT_LEAST_65;
}

bool Md3QtCompat::atLeast66() const
{
    return MD3_QT_AT_LEAST_66;
}

bool Md3QtCompat::atLeast67() const
{
    return MD3_QT_AT_LEAST_67;
}

bool Md3QtCompat::atLeast68() const
{
    return MD3_QT_AT_LEAST_68;
}

bool Md3QtCompat::atLeast69() const
{
    return MD3_QT_AT_LEAST_69;
}

bool Md3QtCompat::atLeast610() const
{
    return MD3_QT_AT_LEAST_610;
}

bool Md3QtCompat::hasQuickEffects() const
{
    return MD3_HAS_QUICK_EFFECTS;
}

bool Md3QtCompat::hasQuickShapes() const
{
    return MD3_HAS_QUICK_SHAPES;
}

bool Md3QtCompat::atLeast(int major, int minor) const
{
    if (major < 0 || minor < 0)
        return false;
    if (QT_VERSION_MAJOR > major)
        return true;
    if (QT_VERSION_MAJOR < major)
        return false;
    return QT_VERSION_MINOR >= minor;
}

bool Md3QtCompat::nearlyEqual(qreal a, qreal b)
{
    return std::abs(a - b) < kEps;
}

qreal Md3QtCompat::preferredHeight(QObject *object) const
{
    QQuickItem *item = asItem(object);
    if (!item)
        return 0;
    return std::max<qreal>({ item->height(), item->implicitHeight(), qreal(0) });
}

qreal Md3QtCompat::preferredWidth(QObject *object) const
{
    QQuickItem *item = asItem(object);
    if (!item)
        return 0;
    return std::max<qreal>({ item->width(), item->implicitWidth(), qreal(0) });
}

bool Md3QtCompat::syncHeightFromImplicit(QObject *object, bool exact) const
{
    QQuickItem *item = asItem(object);
    if (!item)
        return false;
    const qreal ih = item->implicitHeight();
    const qreal next = exact ? ih : std::max(item->height(), ih);
    if (nearlyEqual(item->height(), next))
        return false;
    item->setHeight(next);
    return true;
}

bool Md3QtCompat::syncWidthFromImplicit(QObject *object, bool exact) const
{
    QQuickItem *item = asItem(object);
    if (!item)
        return false;
    const qreal iw = item->implicitWidth();
    const qreal next = exact ? iw : std::max(item->width(), iw);
    if (nearlyEqual(item->width(), next))
        return false;
    item->setWidth(next);
    return true;
}

int Md3QtCompat::syncSubtreeHeights(QObject *root, int maxDepth) const
{
    QQuickItem *item = asItem(root);
    if (!item || maxDepth < 0)
        return 0;
    return syncSubtreeHeightsImpl(item, maxDepth);
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
