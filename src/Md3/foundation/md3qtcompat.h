#pragma once

#include <QObject>
#include <QString>
#include <QtQml/qqmlregistration.h>

class QQuickItem;

/// Compile + runtime Qt kit facts and the **unified** Md3 layout policy for
/// Qt 6.5 / 6.8 / 6.10. Geometry helpers live here so QML does not branch on
/// version for Column/Flickable height semantics.
class Md3QtCompat : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

    Q_PROPERTY(int qtMajor READ qtMajor CONSTANT)
    Q_PROPERTY(int qtMinor READ qtMinor CONSTANT)
    Q_PROPERTY(int qtPatch READ qtPatch CONSTANT)
    Q_PROPERTY(QString qtVersion READ qtVersion CONSTANT)
    Q_PROPERTY(bool atLeast65 READ atLeast65 CONSTANT)
    Q_PROPERTY(bool atLeast68 READ atLeast68 CONSTANT)
    Q_PROPERTY(bool atLeast610 READ atLeast610 CONSTANT)

    /// Always true: Column / layout shells must expose real height (not implicit-only).
    Q_PROPERTY(bool strictColumnHeight READ strictColumnHeight CONSTANT)
    /// Prefer Flickable.contentHeight = item.implicitHeight.
    Q_PROPERTY(bool flickableUsesImplicitHeight READ flickableUsesImplicitHeight CONSTANT)
    /// Never bind DataTable bodyHeight to height while height tracks implicitHeight.
    Q_PROPERTY(bool dataTableAvoidHeightLoop READ dataTableAvoidHeightLoop CONSTANT)
    /// Do not rely on Layout.useDefaultSizePolicy (since 6.8) in public Md3 paths.
    Q_PROPERTY(bool avoidUseDefaultSizePolicy READ avoidUseDefaultSizePolicy CONSTANT)
    /// Do not rely on SafeArea / ExpandedClientAreaHint (since 6.9) as the 6.5 baseline path.
    Q_PROPERTY(bool avoidSafeAreaBaseline READ avoidSafeAreaBaseline CONSTANT)
    /// Do not use FlexboxLayout (6.10 TP) in public Md3 layout shells.
    Q_PROPERTY(bool avoidFlexboxLayout READ avoidFlexboxLayout CONSTANT)

public:
    explicit Md3QtCompat(QObject *parent = nullptr);

    int qtMajor() const;
    int qtMinor() const;
    int qtPatch() const;
    QString qtVersion() const;
    bool atLeast65() const;
    bool atLeast68() const;
    bool atLeast610() const;

    bool strictColumnHeight() const { return true; }
    bool flickableUsesImplicitHeight() const { return true; }
    bool dataTableAvoidHeightLoop() const { return true; }
    bool avoidUseDefaultSizePolicy() const { return true; }
    bool avoidSafeAreaBaseline() const { return true; }
    bool avoidFlexboxLayout() const { return true; }

    /// max(height, implicitHeight) — stable child measure across kits.
    /// Take QObject* so QML Items convert reliably (raw QQuickItem* can be null).
    Q_INVOKABLE qreal preferredHeight(QObject *object) const;
    Q_INVOKABLE qreal preferredWidth(QObject *object) const;

    /// Align height with implicitHeight. exact=false → max(h, ih) (default);
    /// exact=true → height = ih (body slots). Returns true if height was written.
    Q_INVOKABLE bool syncHeightFromImplicit(QObject *object, bool exact = false) const;
    Q_INVOKABLE bool syncWidthFromImplicit(QObject *object, bool exact = false) const;

    /// Walk a subtree and sync heights (skips items with expand:true).
    /// Returns number of items updated.
    Q_INVOKABLE int syncSubtreeHeights(QObject *root, int maxDepth = 8) const;

private:
    static bool nearlyEqual(qreal a, qreal b);
    int syncSubtreeHeightsImpl(QQuickItem *item, int depthLeft) const;
};
