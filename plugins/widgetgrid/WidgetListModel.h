/****************************************************************************
**
** Copyright (C) 2017 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Neptune 3 IVI UI.
**
** $QT_BEGIN_LICENSE:GPL-QTAS$
** Commercial License Usage
** Licensees holding valid commercial Qt Automotive Suite licenses may use
** this file in accordance with the commercial license agreement provided
** with the Software or, alternatively, in accordance with the terms
** contained in a written agreement between you and The Qt Company.  For
** licensing terms and conditions see https://www.qt.io/terms-conditions.
** For further information use the contact form at https://www.qt.io/contact-us.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3 or (at your option) any later version
** approved by the KDE Free Qt Foundation. The licenses are as published by
** the Free Software Foundation and appearing in the file LICENSE.GPL3
** included in the packaging of this file. Please review the following
** information to ensure the GNU General Public License requirements will
** be met: https://www.gnu.org/licenses/gpl-3.0.html.
**
** $QT_END_LICENSE$
**
** SPDX-License-Identifier: GPL-3.0
**
****************************************************************************/
#pragma once

#include <QAbstractListModel>
#include <QObject>

/*
    Filters ApplicationModel to only show the applications that have asWidget==true and also
    keeps its own order of applications, independently of ApplicationModel

    Also defines the position of widgets in the grid (rowIndex role) and ensures they correctly
    fill the grid (manipulates ApplicationInfo::heightRows)
 */
class WidgetListModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(QAbstractItemModel* applicationModel READ applicationModel WRITE setApplicationModel NOTIFY applicationModelChanged)
    Q_PROPERTY(int count READ count NOTIFY countChanged)
    Q_PROPERTY(bool populating READ populating NOTIFY populatingChanged)
    Q_PROPERTY(int numRows READ numRows CONSTANT)
    Q_PROPERTY(int maxWidgetHeightRows READ maxWidgetHeightRows CONSTANT)
public:
    enum Roles {
        RoleAppInfo = Qt::UserRole,
        RoleRowIndex = Qt::UserRole + 1,
    };

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override
    {
        QHash<int, QByteArray> roleNames;
        roleNames.insert(RoleAppInfo, "appInfo");
        roleNames.insert(RoleRowIndex, "rowIndex");
        return roleNames;
    }

    QAbstractItemModel *applicationModel() const;
    void setApplicationModel(QAbstractItemModel *);

    Q_INVOKABLE QObject *application(int index);

    Q_INVOKABLE void move(int fromIndex, int toIndex);
    Q_INVOKABLE void remove(int index);

    int count() const { return rowCount(); }

    bool populating() const { return m_populating; }

    int numRows() const { return m_totalNumRows; }
    int maxWidgetHeightRows() const { return m_maxWidgetHeightRows; }

signals:
    void applicationModelChanged();
    void countChanged();
    void populatingChanged();

private slots:
    void onAppWidgetStateChanged();
    void updateRowIndexes();

private:
    void fetchAppInfoRoleIndex();

    void trackRowsFromApplicationModel(int first, int last);
    void appendApplicationInfo(QObject *appInfo);

    void detachApplicationInfo(QObject *appInfo);

    int indexFromAppInfo(QObject *appInfo);

    QObject *getApplicationInfoFromModelAt(int index);

    // some helpers to make code more readable when dealing with QObject properties
    int heightRows(QObject *appInfo) const;
    void setHeightRows(QObject *appInfo, int value) const;
    bool asWidget(QObject *appInfo) const;
    QString id(QObject *appInfo) const;
    bool hasWidgetSupport(QObject *appInfo) const;

    void setPopulating(bool);
    void distributeHeightOfDetachedAppInfo(int index);

    int m_appInfoRoleIndex{-1};
    QAbstractItemModel *m_applicationModel{nullptr};

    struct ListItem {
        ListItem() : appInfo(nullptr), rowIndex(0) {}
        ListItem(QObject *appInfo) : appInfo(appInfo),rowIndex(0) {}
        bool operator==(const ListItem &other) const { return appInfo == other.appInfo && rowIndex == other.rowIndex && detached == other.detached; }

        QObject *appInfo;
        int rowIndex;

        // A detached item doesn't occupy any space in the grid. It's not in the grid anymore
        // but is still in the model.
        // Useful for animating the widget removal, before it finally leaves the model
        bool detached{false};
    };
    QList<ListItem*> filterOutDetachedItems(QList<ListItem> &list) const;

    QList<ListItem> m_list;
    bool m_resetting{false}; // whether the model is being reset

    bool m_updatingRowIndexes{false};

    int m_totalNumRows{5};
    int m_maxWidgetHeightRows{3};

    bool m_populating{true};

    // Mappings between an ApplicatioInfo object and its index in the set ApplicationModel
    QMap<QObject*, int> m_appInfoToAppModelIndex;
    QMap<int, QObject*> m_appModelIndexToAppInfo;
};
