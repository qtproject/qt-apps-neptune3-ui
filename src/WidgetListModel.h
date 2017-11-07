/****************************************************************************
**
** Copyright (C) 2017 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Triton IVI UI.
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
