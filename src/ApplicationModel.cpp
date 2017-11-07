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
#include "ApplicationModel.h"
#include "ApplicationInfo.h"

// QtAM
#include <application.h>
#include <applicationmanager.h>
#include <QtAppManWindow>

#include <QStringList>

#include <QDebug>

using QtAM::WindowManager;
using QtAM::ApplicationManager;

ApplicationModel::ApplicationModel(QObject *parent)
    : QAbstractListModel(parent)
{
}

ApplicationModel::~ApplicationModel()
{
    qDeleteAll(m_appInfoList);
}

void ApplicationModel::setApplicationManager(QtAM::ApplicationManager *appMan)
{
    if (appMan == m_appMan) {
        return;
    }

    beginResetModel();

    if (m_appMan) {
        disconnect(m_appMan, 0, this, 0);
    }
    m_appMan = appMan;
    if (!appMan) {
        return;
    }

    connect(appMan, &ApplicationManager::applicationWasActivated, this, &ApplicationModel::onApplicationActivated);

    for (int i = 0; i < appMan->count(); ++i) {
        const QtAM::Application *application = appMan->application(i);
        ApplicationInfo *appInfo = new ApplicationInfo(application);
        connect(appInfo, &ApplicationInfo::startRequested, this, [this, appInfo]() {
            if (m_appMan) {
                m_appMan->startApplication(appInfo->application()->id());
            }
        });
        m_appInfoList.append(appInfo);
    }

    // TODO: Load the widget configuration from some database or file
    configureApps();

    // TODO: Monitor appMan for Application additions and removals.

    endResetModel();
    emit countChanged();
}

void ApplicationModel::setWindowManager(QtAM::WindowManager *windowManager)
{
    if (m_windowManager) {
        disconnect(m_windowManager, 0, this, 0);
    }
    m_windowManager = windowManager;
    if (!windowManager) {
        return;
    }

    connect(windowManager, &WindowManager::windowReady, this, &ApplicationModel::onWindowReady);

    connect(windowManager, &WindowManager::windowLost, this, [windowManager](int index, QQuickItem *window) {
        Q_UNUSED(index)
        // TODO care about animating before releasing
        windowManager->releaseWindow(window);
    });
}

void ApplicationModel::configureApps()
{
    auto *appInfo = application("com.pelagicore.calendar");
    appInfo->setAsWidget(true);
    appInfo->setHeightRows(2);

    appInfo = application("com.pelagicore.maps");
    appInfo->setAsWidget(true);
    appInfo->setHeightRows(2);

    appInfo = application("com.pelagicore.music");
    appInfo->setAsWidget(true);
}

int ApplicationModel::rowCount(const QModelIndex &) const
{
    return m_appInfoList.count();
}

QVariant ApplicationModel::data(const QModelIndex &index, int role) const
{
    if (index.row() >= 0 && index.row() < m_appInfoList.count()) {
        ApplicationInfo *appInfo = m_appInfoList.at(index.row());
        if (role == RoleAppInfo) {
            return QVariant::fromValue(appInfo);
        } else if (role == RoleIcon) {
            return QVariant::fromValue(appInfo->application()->icon());
        } else if (role == RoleAppId) {
            return QVariant::fromValue(appInfo->application()->id());
        } else if (role == RoleName) {
            // FIXME: use locale
            return QVariant::fromValue(appInfo->application()->name(QStringLiteral("en")));
        }
    }
    return QVariant();
}

void ApplicationModel::onWindowReady(int index, QQuickItem *window)
{
    auto windowManager = WindowManager::instance();

    QString appID = windowManager->get(index)["applicationId"].toString();

    ApplicationInfo *appInfo = application(appID);
    appInfo->setWindow(window);

    emit applicationSurfaceReady(appInfo, window);
}

ApplicationInfo *ApplicationModel::application(const QString &appId)
{
    for (auto *appInfo : m_appInfoList) {
        if (appInfo->application()->id() == appId) {
            return appInfo;
        }
    }
    return nullptr;
}

void ApplicationModel::goHome()
{
    if (!m_activeAppId.isEmpty()) {
        auto *appInfo = application(m_activeAppId);
        Q_ASSERT(appInfo);

        appInfo->setActive(false);

        m_activeAppId.clear();
        emit activeAppIdChanged();
    }
}

void ApplicationModel::onApplicationActivated(const QString &appId, const QString &/*aliasId*/)
{
    if (appId == m_activeAppId)
        return;

    auto *appInfo = application(appId);
    if (!appInfo->canBeActive())
        return;

    appInfo->setActive(true);

    {
        auto *oldAppInfo = application(m_activeAppId);
        if (oldAppInfo)
            oldAppInfo->setActive(false);
    }

    m_activeAppId = appId;
    emit activeAppIdChanged();

    auto windowManager = WindowManager::instance();
    for (int i = 0; i < windowManager->count(); ++i) {
        auto wmItem = windowManager->get(i);
        if (!wmItem["isClosing"].toBool() && wmItem["applicationId"].toString() == appId) {
            auto *item = wmItem["windowItem"].value<QQuickItem*>();
            emit applicationSurfaceReady(appInfo, item);
            break;
        }
    }
}
