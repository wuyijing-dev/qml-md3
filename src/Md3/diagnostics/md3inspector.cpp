#include "md3inspector.h"

#include <QByteArray>
#include <QMetaObject>
#include <QQuickItem>
#include <QRectF>
#include <QString>

Md3Inspector::Md3Inspector(QObject *parent)
    : QObject(parent)
{
}

static QString cleanTypeName(const QMetaObject *mo)
{
    QString typeName = QString::fromUtf8(mo ? mo->className() : "QObject");
    const int qml = typeName.indexOf(QLatin1String("_QML"));
    if (qml > 0)
        typeName = typeName.left(qml);
    return typeName;
}

static bool isUnder(QQuickItem *item, QQuickItem *ancestor)
{
    for (QQuickItem *p = item; p; p = p->parentItem()) {
        if (p == ancestor)
            return true;
    }
    return false;
}

/// Input / chrome leaves that should not be reported as the "selected component".
static bool isInputChrome(QQuickItem *item)
{
    if (!item)
        return true;
    const QByteArray cn = item->metaObject()->className();
    const QString t = cleanTypeName(item->metaObject());
    if (t == QLatin1String("Md3ElementPicker")
            || t == QLatin1String("Md3PerformancePanel")
            || t == QLatin1String("Md3Sparkline")
            || t == QLatin1String("Md3Inspector")
            || t.startsWith(QLatin1String("Md3Performance")))
        return true;
    return cn.contains("MouseArea")
            || cn.contains("TapHandler")
            || cn.contains("HoverHandler")
            || cn.contains("WheelHandler")
            || cn.contains("DragHandler")
            || cn.contains("PinchHandler")
            || cn.contains("PointHandler")
            || cn.contains("PointerHandler")
            || cn.contains("MultiPointTouchArea")
            || cn.contains("TouchArea")
            || cn == "QQuickItem"
            || cn.startsWith("QQuickRectangle")
            || cn.startsWith("QQuickText")
            || cn.startsWith("QQuickImage")
            || cn.startsWith("QQuickShape")
            || cn.startsWith("QQuickLoader")
            || cn.contains("Ripple")
            || cn.contains("StateOverlay")
            || cn.contains("FocusRing")
            || cn.contains("Shadow");
}

static bool isPreferredComponent(QQuickItem *item)
{
    if (!item)
        return false;
    const QString t = cleanTypeName(item->metaObject());
    return t.startsWith(QLatin1String("Md3"))
            || (!t.startsWith(QLatin1String("QQuick")) && !t.startsWith(QLatin1String("QQml")));
}

/// Climb from a leaf hit to something useful for the developer.
static QQuickItem *resolveMeaningful(QQuickItem *hit, QQuickItem *root)
{
    if (!hit)
        return nullptr;

    QQuickItem *cur = hit;
    while (cur && cur != root && isInputChrome(cur))
        cur = cur->parentItem();
    if (!cur || cur == root)
        cur = hit->parentItem() ? hit->parentItem() : hit;

    // Prefer nearest Md3* / non-QQuick ancestor within a short climb.
    for (QQuickItem *p = cur; p && p != root; p = p->parentItem()) {
        if (isPreferredComponent(p))
            return p;
    }
    // Skip remaining chrome one more level if still on a primitive.
    while (cur && cur != root && isInputChrome(cur))
        cur = cur->parentItem();
    return cur ? cur : hit;
}

static bool isExcluded(QQuickItem *item, QQuickItem *exclude, QQuickItem *exclude2)
{
    if (!item)
        return true;
    if (exclude && (item == exclude || isUnder(item, exclude)))
        return true;
    if (exclude2 && (item == exclude2 || isUnder(item, exclude2)))
        return true;
    return false;
}

static QQuickItem *pickRecursive(QQuickItem *item, qreal x, qreal y,
                                 QQuickItem *exclude, QQuickItem *exclude2)
{
    if (!item || !item->isVisible() || item->opacity() <= 0.01
            || item->width() <= 0 || item->height() <= 0)
        return nullptr;
    if (isExcluded(item, exclude, exclude2))
        return nullptr;

    const QList<QQuickItem *> kids = item->childItems();
    for (int i = kids.size() - 1; i >= 0; --i) {
        QQuickItem *child = kids.at(i);
        if (!child || !child->isVisible() || child->opacity() <= 0.01)
            continue;
        if (isExcluded(child, exclude, exclude2))
            continue;
        const QPointF local = item->mapToItem(child, QPointF(x, y));
        if (local.x() < 0 || local.y() < 0
                || local.x() > child->width() || local.y() > child->height())
            continue;
        if (QQuickItem *hit = pickRecursive(child, local.x(), local.y(), exclude, exclude2))
            return hit;
    }

    return item;
}

QQuickItem *Md3Inspector::itemAt(QQuickItem *root, qreal x, qreal y,
                                 QQuickItem *exclude, QQuickItem *exclude2) const
{
    if (!root)
        return nullptr;
    QQuickItem *raw = pickRecursive(root, x, y, exclude, exclude2);
    if (!raw || raw == root)
        return nullptr;
    QQuickItem *resolved = resolveMeaningful(raw, root);
    if (resolved && isExcluded(resolved, exclude, exclude2))
        return nullptr;
    const QString t = cleanTypeName(resolved ? resolved->metaObject() : nullptr);
    if (t == QLatin1String("Md3ElementPicker")
            || t == QLatin1String("Md3PerformancePanel"))
        return nullptr;
    return resolved;
}

QVariantMap Md3Inspector::describe(QObject *obj) const
{
    QVariantMap out;
    if (!obj)
        return out;

    const QString typeName = cleanTypeName(obj->metaObject());
    out.insert(QStringLiteral("typeName"), typeName);
    out.insert(QStringLiteral("objectName"), obj->objectName());

    if (auto *item = qobject_cast<QQuickItem *>(obj)) {
        out.insert(QStringLiteral("width"), item->width());
        out.insert(QStringLiteral("height"), item->height());
        out.insert(QStringLiteral("x"), item->x());
        out.insert(QStringLiteral("y"), item->y());
        out.insert(QStringLiteral("opacity"), item->opacity());
        out.insert(QStringLiteral("visible"), item->isVisible());
        out.insert(QStringLiteral("enabled"), item->isEnabled());
        out.insert(QStringLiteral("childCount"), item->childItems().size());
        out.insert(QStringLiteral("z"), item->z());
        if (QQuickItem *parent = item->parentItem()) {
            out.insert(QStringLiteral("parentType"), cleanTypeName(parent->metaObject()));
        }
    }
    return out;
}

QVariantMap Md3Inspector::mapBounds(QQuickItem *item, QQuickItem *into) const
{
    QVariantMap out;
    if (!item || !into)
        return out;
    const QRectF r(0, 0, item->width(), item->height());
    const QRectF mapped = item->mapRectToItem(into, r);
    out.insert(QStringLiteral("x"), mapped.x());
    out.insert(QStringLiteral("y"), mapped.y());
    out.insert(QStringLiteral("width"), mapped.width());
    out.insert(QStringLiteral("height"), mapped.height());
    return out;
}
