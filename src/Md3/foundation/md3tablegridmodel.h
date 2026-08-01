#pragma once

#include <QAbstractTableModel>
#include <QVariantList>
#include <QVector>
#include <QtQml/qqmlregistration.h>

/// Lightweight grid model for Md3DataTable TableView bodies.
/// Maps view (row, column) → page entry + logical column index / cell kind.
class Md3TableGridModel : public QAbstractTableModel
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QVariantList entries READ entries WRITE setEntries NOTIFY entriesChanged)
    Q_PROPERTY(QVariantList columnIndices READ columnIndices WRITE setColumnIndices NOTIFY columnIndicesChanged)
    Q_PROPERTY(bool leadingSelection READ leadingSelection WRITE setLeadingSelection NOTIFY leadingSelectionChanged)
    Q_PROPERTY(bool trailingActions READ trailingActions WRITE setTrailingActions NOTIFY trailingActionsChanged)

public:
    enum Roles {
        EntryRole = Qt::UserRole + 1,
        ColumnIndexRole,
        CellKindRole
    };
    Q_ENUM(Roles)

    enum CellKind {
        DataCell = 0,
        SelectionCell = 1,
        ActionsCell = 2
    };
    Q_ENUM(CellKind)

    explicit Md3TableGridModel(QObject *parent = nullptr);

    QVariantList entries() const { return m_entries; }
    void setEntries(const QVariantList &entries);

    QVariantList columnIndices() const;
    void setColumnIndices(const QVariantList &indices);

    bool leadingSelection() const { return m_leadingSelection; }
    void setLeadingSelection(bool on);

    bool trailingActions() const { return m_trailingActions; }
    void setTrailingActions(bool on);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int columnCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE int columnIndexAt(int viewColumn) const;
    Q_INVOKABLE int cellKindAt(int viewColumn) const;
    Q_INVOKABLE QVariant entryAt(int row) const;

signals:
    void entriesChanged();
    void columnIndicesChanged();
    void leadingSelectionChanged();
    void trailingActionsChanged();

private:
    int dataColumnCount() const { return m_columnIndices.size(); }

    QVariantList m_entries;
    QVector<int> m_columnIndices;
    bool m_leadingSelection = false;
    bool m_trailingActions = false;
};
