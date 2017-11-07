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
#include "WidgetListModel.h"

#include <QDebug>

int WidgetListModel::rowCount(const QModelIndex &/*parent*/) const
{
    return m_list.count();
}

QVariant WidgetListModel::data(const QModelIndex &index, int role) const
{
    if (index.row() >= 0 && index.row() < m_list.count()) {
        if (role == RoleAppInfo) {
            ApplicationInfo *appInfo = m_list.at(index.row());
            return QVariant::fromValue(appInfo);
        }
    }
    return QVariant();
}

QAbstractItemModel *WidgetListModel::applicationModel() const
{
    return m_applicationModel;
}

void WidgetListModel::setApplicationModel(QAbstractItemModel *appModel)
{
    if (appModel == m_applicationModel) {
        return;
    }

    disconnect(appModel, 0, this, 0);
    m_list.clear();

    m_applicationModel = appModel;
    emit applicationModelChanged();

    if (!appModel) {
        return;
    }

    fetchAppInfoRoleIndex();

    if (appModel->rowCount() > 0) {
        trackRowsFromApplicationModel(0, appModel->rowCount() - 1);
    }

    connect(appModel, &QAbstractItemModel::rowsInserted, this,
            [this](const QModelIndex & /*parent*/, int first, int last)
            {
                this->trackRowsFromApplicationModel(first, last);
            });

    connect(appModel, &QAbstractItemModel::rowsAboutToBeRemoved, this,
            [this](const QModelIndex & /*parent*/, int first, int last)
            {
                for (int i = first; i <= last; ++i) {
                    auto *appInfo = getApplicationInfoFromModelAt(i);
                    removeApplicationInfo(appInfo);
                    disconnect(appInfo, 0, this, 0);
                }
            });

    connect(appModel, &QAbstractItemModel::modelAboutToBeReset, this,
            [this]()
            {
                beginResetModel();
                m_resetting = true;
                m_list.clear();
            });

    connect(appModel, &QAbstractItemModel::modelReset, this,
            [this]()
            {
                trackRowsFromApplicationModel(0, m_applicationModel->rowCount() - 1);
                m_resetting = false;
                endResetModel();
            });

    connect(appModel, &QObject::destroyed, this,
            [this]()
            {
                this->setApplicationModel(nullptr);
            });
}

void WidgetListModel::fetchAppInfoRoleIndex()
{
    QHash<int, QByteArray> hash = m_applicationModel->roleNames();

    m_appInfoRoleIndex = -1;
    for (auto i = hash.begin(); i != hash.end() && m_appInfoRoleIndex == -1; ++i) {
        if (i.value() == QByteArray("appInfo"))
            m_appInfoRoleIndex = i.key();
    }

    Q_ASSERT(m_appInfoRoleIndex != -1);
}

ApplicationInfo *WidgetListModel::application(int rowIndex)
{
    QVariant variant = data(index(rowIndex, 0), m_appInfoRoleIndex);
    return variant.value<ApplicationInfo*>();
}

void WidgetListModel::move(int from, int to)
{
    qDebug().nospace() << "WidgetListModel::move(from="<<from<<", to="<<to<<")";

    if (from == to) return;

    if (from >= 0 && from < m_list.size() && to >= 0 && to < m_list.size()) {
        QModelIndex parent;
        /* When moving an item down, the destination index needs to be incremented
           by one, as explained in the documentation:
           http://qt-project.org/doc/qt-5.0/qtcore/qabstractitemmodel.html#beginMoveRows */

        beginMoveRows(parent, from, from, parent, to + (to > from ? 1 : 0));
        m_list.move(from, to);
        endMoveRows();
    }
}

void WidgetListModel::trackRowsFromApplicationModel(int first, int last)
{
    QList<ApplicationInfo*> newRows;

    for (int i = first; i <= last; ++i) {
        auto *appInfo = getApplicationInfoFromModelAt(i);
        if (appInfo->asWidget()) {
            newRows.append(appInfo);
        }
    }

    if (newRows.isEmpty()) {
        return;
    }

    if (!m_resetting) {
        beginInsertRows(QModelIndex(), rowCount()/*first*/, rowCount() + newRows.count() - 1/*last*/);
    }

    m_list.append(newRows);
    for (auto *appInfo : newRows) {
        connect(appInfo, &ApplicationInfo::asWidgetChanged, this,
                [this, appInfo]()
                {
                    if (appInfo->asWidget()) {
                        appendApplicationInfo(appInfo);
                    } else {
                        removeApplicationInfo(appInfo);
                    }
                });
    }

    if (!m_resetting) {
        endInsertRows();
    }
    emit countChanged();
}

void WidgetListModel::appendApplicationInfo(ApplicationInfo *appInfo)
{
    beginInsertRows(QModelIndex(), rowCount()/*first*/, rowCount()/*last*/);
    m_list.append(appInfo);
    endInsertRows();
}

void WidgetListModel::removeApplicationInfo(ApplicationInfo *appInfo)
{
    int index = m_list.indexOf(appInfo);
    Q_ASSERT(index != -1);
    if (index == -1) {
        return;
    }

    beginRemoveRows(QModelIndex(), index, index);
    m_list.removeAt(index);
    endRemoveRows();
}

ApplicationInfo *WidgetListModel::getApplicationInfoFromModelAt(int index)
{
    auto rowIndex = m_applicationModel->index(index, 0, QModelIndex());
    QVariant variant = m_applicationModel->data(rowIndex, m_appInfoRoleIndex);
    auto appInfo = variant.value<ApplicationInfo*>();

    if (!appInfo) {
        qFatal("WidgetListModel: Invalid source model");
    }

    return appInfo;
}
