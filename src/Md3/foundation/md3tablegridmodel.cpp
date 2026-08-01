#include "md3tablegridmodel.h"

Md3TableGridModel::Md3TableGridModel(QObject *parent)
    : QAbstractTableModel(parent)
{
}

void Md3TableGridModel::setEntries(const QVariantList &entries)
{
    if (m_entries == entries)
        return;
    beginResetModel();
    m_entries = entries;
    endResetModel();
    emit entriesChanged();
}

QVariantList Md3TableGridModel::columnIndices() const
{
    QVariantList out;
    out.reserve(m_columnIndices.size());
    for (int v : m_columnIndices)
        out.append(v);
    return out;
}

void Md3TableGridModel::setColumnIndices(const QVariantList &indices)
{
    QVector<int> next;
    next.reserve(indices.size());
    for (const QVariant &v : indices)
        next.append(v.toInt());
    if (next == m_columnIndices)
        return;
    beginResetModel();
    m_columnIndices = next;
    endResetModel();
    emit columnIndicesChanged();
}

void Md3TableGridModel::setLeadingSelection(bool on)
{
    if (m_leadingSelection == on)
        return;
    beginResetModel();
    m_leadingSelection = on;
    endResetModel();
    emit leadingSelectionChanged();
}

void Md3TableGridModel::setTrailingActions(bool on)
{
    if (m_trailingActions == on)
        return;
    beginResetModel();
    m_trailingActions = on;
    endResetModel();
    emit trailingActionsChanged();
}

int Md3TableGridModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;
    return m_entries.size();
}

int Md3TableGridModel::columnCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;
    return (m_leadingSelection ? 1 : 0) + dataColumnCount() + (m_trailingActions ? 1 : 0);
}

int Md3TableGridModel::cellKindAt(int viewColumn) const
{
    int c = viewColumn;
    if (m_leadingSelection) {
        if (c == 0)
            return SelectionCell;
        --c;
    }
    if (c < dataColumnCount())
        return DataCell;
    return ActionsCell;
}

int Md3TableGridModel::columnIndexAt(int viewColumn) const
{
    int c = viewColumn;
    if (m_leadingSelection) {
        if (c == 0)
            return -1;
        --c;
    }
    if (c >= 0 && c < dataColumnCount())
        return m_columnIndices.at(c);
    return -1;
}

QVariant Md3TableGridModel::entryAt(int row) const
{
    if (row < 0 || row >= m_entries.size())
        return {};
    return m_entries.at(row);
}

QVariant Md3TableGridModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_entries.size())
        return {};
    if (index.column() < 0 || index.column() >= columnCount())
        return {};

    switch (role) {
    case EntryRole:
    case Qt::DisplayRole:
        return m_entries.at(index.row());
    case ColumnIndexRole:
        return columnIndexAt(index.column());
    case CellKindRole:
        return cellKindAt(index.column());
    default:
        return {};
    }
}

QHash<int, QByteArray> Md3TableGridModel::roleNames() const
{
    return {
        { EntryRole, "entry" },
        { ColumnIndexRole, "columnIndex" },
        { CellKindRole, "cellKind" },
        { Qt::DisplayRole, "display" },
    };
}
