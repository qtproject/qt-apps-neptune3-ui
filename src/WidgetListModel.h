#pragma once

#include <QAbstractListModel>

#include "ApplicationInfo.h"

/*
    Filters ApplicationModel to only show the applications that have asWidget==true and also
    keeps its own order of applications, independently of ApplicationModel

    Similar to QSortFilterProxyModel but instead of sorting it keeps track of its own ordering,
    modified via its public move() function.
 */
class WidgetListModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(QAbstractItemModel* applicationModel READ applicationModel WRITE setApplicationModel NOTIFY applicationModelChanged)
    Q_PROPERTY(int count READ count NOTIFY countChanged)
public:
    enum Roles {
        RoleAppInfo = Qt::UserRole,
    };

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override
    {
        QHash<int, QByteArray> roleNames;
        roleNames.insert(RoleAppInfo, "appInfo");
        return roleNames;
    }

    QAbstractItemModel *applicationModel() const;
    void setApplicationModel(QAbstractItemModel *);

    Q_INVOKABLE ApplicationInfo *application(int index);

    Q_INVOKABLE void move(int fromIndex, int toIndex);

    int count() const { return rowCount(); }


signals:
    void applicationModelChanged();
    void countChanged();

private:
    void fetchAppInfoRoleIndex();

    void trackRowsFromApplicationModel(int first, int last);
    void appendApplicationInfo(ApplicationInfo *appInfo);
    void removeApplicationInfo(ApplicationInfo *appInfo);

    ApplicationInfo *getApplicationInfoFromModelAt(int index);

    int m_appInfoRoleIndex{-1};
    QAbstractItemModel *m_applicationModel{nullptr};
    QList<ApplicationInfo*> m_list;
    bool m_resetting{false}; // whether the model is being reset
};
