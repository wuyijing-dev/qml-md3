#pragma once

#include <QObject>
#include <QQuickItem>
#include <QVariantMap>
#include <QtQml/qqmlregistration.h>

/// Hit-test / describe helpers for the performance element picker.
class Md3Inspector : public QObject
{
    Q_OBJECT
    QML_ELEMENT

public:
    explicit Md3Inspector(QObject *parent = nullptr);

    /// Deepest visible item under (x,y). Skips exclude / exclude2 and resolves past
    /// MouseArea/handlers to a meaningful component (prefers Md3*).
    Q_INVOKABLE QQuickItem *itemAt(QQuickItem *root, qreal x, qreal y,
                                   QQuickItem *exclude = nullptr,
                                   QQuickItem *exclude2 = nullptr) const;

    Q_INVOKABLE QVariantMap describe(QObject *obj) const;

    /// Map item's scene bounding box into `into`'s local coordinates.
    Q_INVOKABLE QVariantMap mapBounds(QQuickItem *item, QQuickItem *into) const;
};
