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
#include <QList>
#include <QLoggingCategory>

#include <applicationmanager.h>

namespace QtAM {
    class WindowManager;
}

class QQuickItem;

class ApplicationInfo;

Q_DECLARE_LOGGING_CATEGORY(appModel)

class ApplicationModel : public QAbstractListModel
{
    Q_OBJECT

    // TODO remove this. activeAppInfo replaces it
    Q_PROPERTY(QString activeAppId READ activeAppId NOTIFY activeAppIdChanged)

    Q_PROPERTY(ApplicationInfo* activeAppInfo READ activeAppInfo NOTIFY activeAppInfoChanged)
    Q_PROPERTY(int count READ count NOTIFY countChanged)
    Q_PROPERTY(QtAM::ApplicationManager* applicationManager READ applicationManager WRITE setApplicationManager NOTIFY applicationManagerChanged)
    Q_PROPERTY(QtAM::WindowManager* windowManager READ windowManager WRITE setWindowManager NOTIFY windowManagerChanged)
    Q_PROPERTY(qreal cellWidth READ cellWidth WRITE setCellWidth NOTIFY cellWidthChanged)
    Q_PROPERTY(qreal cellHeight READ cellHeight WRITE setCellHeight NOTIFY cellHeightChanged)
    Q_PROPERTY(bool readyToStartApps READ readyToStartApps WRITE setReadyToStartApps NOTIFY readyToStartAppsChanged)
public:
    ApplicationModel(QObject *parent = nullptr);
    virtual ~ApplicationModel();

    enum Roles {
        RoleAppInfo = Qt::UserRole,
        RoleIcon = Qt::UserRole + 1,
        RoleAppId = Qt::UserRole + 2,
        RoleName = Qt::UserRole + 3,
    };

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    QHash<int, QByteArray> roleNames() const override
    {
        QHash<int, QByteArray> roleNames;
        roleNames.insert(RoleAppInfo, "appInfo");
        roleNames.insert(RoleIcon, "icon");
        roleNames.insert(RoleAppId, "applicationId");
        roleNames.insert(RoleName, "name");
        return roleNames;
    }

    Q_INVOKABLE ApplicationInfo *application(const QString &appId);

    Q_INVOKABLE void goHome();

    QString activeAppId() const { return m_activeAppId; }

    QtAM::ApplicationManager *applicationManager() const { return m_appMan; }
    void setApplicationManager(QtAM::ApplicationManager *);

    QtAM::WindowManager *windowManager() const { return m_windowManager; }
    void setWindowManager(QtAM::WindowManager *);

    int count() const { return m_appInfoList.count(); }

    ApplicationInfo* activeAppInfo() { return m_activeAppInfo; }

    qreal cellWidth() const;
    void setCellWidth(qreal);

    qreal cellHeight() const;
    void setCellHeight(qreal);

    bool readyToStartApps() const;
    void setReadyToStartApps(bool);

signals:
    void activeAppIdChanged();
    void activeAppInfoChanged();
    void applicationManagerChanged();
    void windowManagerChanged();
    void countChanged();
    void cellWidthChanged();
    void cellHeightChanged();
    void readyToStartAppsChanged();

private slots:
    void onWindowReady(int index, QQuickItem *window);
    void onWindowLost(int index, QQuickItem *window);
    void onApplicationActivated(const QString &appId, const QString &aliasId);
    void onWindowPropertyChanged(QQuickItem *window, const QString &name, const QVariant &value);
    void onAsWidgetChanged(ApplicationInfo *appInfo);

private:
    void configureApps();
    void updateWindowStateProperty(ApplicationInfo *appInfo);
    void startApplication(const QString &appId);

    QList<ApplicationInfo*> m_appInfoList;
    QString m_activeAppId;
    QtAM::ApplicationManager *m_appMan{nullptr};
    QtAM::WindowManager *m_windowManager{nullptr};
    ApplicationInfo *m_activeAppInfo{nullptr};

    qreal m_cellWidth{0};
    qreal m_cellHeight{0};

    bool m_readyToStartApps{false};
    QStringList m_appStartQueue;
};

