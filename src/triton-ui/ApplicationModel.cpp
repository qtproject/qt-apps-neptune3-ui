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
#include <QtAppManWindow>

#include <QStringList>

#include <QDebug>

Q_LOGGING_CATEGORY(appModel, "appmodel")

using QtAM::WindowManager;
using QtAM::ApplicationManager;
using QtAM::Application;

ApplicationModel::ApplicationModel(QObject *parent)
    : QAbstractListModel(parent)
{
    setLangCode(QLocale::system().name());
}

ApplicationModel::~ApplicationModel()
{
    qDeleteAll(m_appInfoList);
    delete m_instrumentClusterApp;
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
    connect(appMan, &ApplicationManager::applicationRunStateChanged, this, &ApplicationModel::onApplicationRunStateChanged);

    for (int i = 0; i < appMan->count(); ++i) {
        const QtAM::Application *application = appMan->application(i);

        if (isInstrumentClusterApp(application)) {
            ApplicationInfo *appInfo = new ApplicationInfo(application);
            QQmlEngine::setObjectOwnership(appInfo, QQmlEngine::CppOwnership);
            setInstrumentClusterAppInfo(appInfo);
            startApplication(m_instrumentClusterApp->id());
        } else {
            append(application);
        }
    }

    // TODO: Load the widget configuration from some database or file
    configureApps();

    connect(appMan, &QAbstractItemModel::rowsInserted, this,
            [this](const QModelIndex & /*parent*/, int first, int last)
            {
                for (int i = first; i <= last; ++i) {
                    this->beginInsertRows(QModelIndex(), rowCount() /*first*/, rowCount() /*last*/);
                    const auto *application = m_appMan->application(i);
                    this->append(application);
                    this->endInsertRows();
                }
            });

    connect(appMan, &QAbstractItemModel::rowsAboutToBeRemoved, this,
            [this](const QModelIndex & /*parent*/, int first, int last)
            {
                for (int i = first; i <= last; ++i) {
                    const auto *application = m_appMan->application(i);
                    remove(application);
                }
            });

    endResetModel();
    emit countChanged();
}

void ApplicationModel::setWindowManager(QtAM::WindowManager *windowManager)
{
    if (m_windowManager == windowManager) {
        return;
    }

    if (m_windowManager) {
        disconnect(m_windowManager, 0, this, 0);
    }
    m_windowManager = windowManager;
    if (!windowManager) {
        return;
    }

    connect(windowManager, &WindowManager::windowReady, this, &ApplicationModel::onWindowReady);
    connect(windowManager, &WindowManager::windowLost, this, &ApplicationModel::onWindowLost);
    connect(windowManager, &WindowManager::windowPropertyChanged, this, &ApplicationModel::onWindowPropertyChanged);
}

void ApplicationModel::configureApps()
{
    auto *appInfo = application("com.pelagicore.calendar");
    appInfo->setAsWidget(true);
    appInfo->setHeightRows(2);

    appInfo = application("com.pelagicore.phone");
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
        auto application = static_cast<const Application*>(appInfo->application());
        if (role == RoleAppInfo) {
            return QVariant::fromValue(appInfo);
        } else if (role == RoleIcon) {
            return QVariant::fromValue(application->icon());
        } else if (role == RoleAppId) {
            return QVariant::fromValue(application->id());
        } else if (role == RoleName) {
            const QString translatedName = application->name(m_langCode);
            if (!translatedName.isEmpty()) { // the Add widget popup will discard empty entries otherwise
                return translatedName;
            }
            return application->name(QStringLiteral("en"));
        }
    }
    return QVariant();
}

void ApplicationModel::onWindowReady(int index, QQuickItem *window)
{
    auto windowManager = WindowManager::instance();

    QString appID = windowManager->get(index)["applicationId"].toString();
    ApplicationInfo *appInfo = application(appID);

    bool isRegularApp = appInfo != nullptr;

    windowManager->setWindowProperty(window, QStringLiteral("cellWidth"), QVariant(m_cellWidth));
    windowManager->setWindowProperty(window, QStringLiteral("cellHeight"), QVariant(m_cellHeight));

    if (isRegularApp) {
        bool isSecondaryWindow = windowManager->windowProperty(window, QStringLiteral("windowType")).toString()
            == QStringLiteral("secondary");

        if (isSecondaryWindow) {
            appInfo->setSecondaryWindow(window);
        } else {
            windowManager->setWindowProperty(window, QStringLiteral("homePageRowHeight"), QVariant(m_homePageRowHeight));
            windowManager->setWindowProperty(window, QStringLiteral("tritonWidgetHeight"), QVariant(appInfo->widgetHeight()));
            windowManager->setWindowProperty(window, QStringLiteral("tritonCurrentWidth"), QVariant(appInfo->currentWidth()));
            windowManager->setWindowProperty(window, QStringLiteral("tritonCurrentHeight"), QVariant(appInfo->currentHeight()));
            windowManager->setWindowProperty(window, QStringLiteral("tritonState"), QVariant(appInfo->windowState()));
            windowManager->setWindowProperty(window, QStringLiteral("exposedRectBottomMargin"), QVariant(appInfo->exposedRectBottomMargin()));
            windowManager->setWindowProperty(window, QStringLiteral("exposedRectTopMargin"), QVariant(appInfo->exposedRectTopMargin()));
            appInfo->setWindow(window);
            appInfo->setCanBeActive(true);
        }
    } else {
        // must be the instrument cluster, which is set apart
        Q_ASSERT(m_instrumentClusterApp && m_instrumentClusterApp->id() == appID);
        m_instrumentClusterApp->setWindow(window);
    }
}

void ApplicationModel::onWindowLost(int index, QQuickItem *window)
{
    auto windowManager = WindowManager::instance();
    QString appID = windowManager->get(index)["applicationId"].toString();

    ApplicationInfo *appInfo = application(appID);
    if (!appInfo) {
        // must be the instrument cluster, which is set apart
        Q_ASSERT(m_instrumentClusterApp && m_instrumentClusterApp->id() == appID);
        appInfo = m_instrumentClusterApp;
    }

    if (appInfo->window() == window) {
        appInfo->setWindow(nullptr);
    } else if (appInfo->secondaryWindow() == window) {
        appInfo->setSecondaryWindow(nullptr);
    }

    // TODO care about animating before releasing
    windowManager->releaseWindow(window);
}

ApplicationInfo *ApplicationModel::application(const QString &appId)
{
    for (auto *appInfo : qAsConst(m_appInfoList)) {
        if (appInfo->id() == appId) {
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
        qCDebug(appModel).nospace() << "activeAppId=" << m_activeAppId;
        m_activeAppInfo = nullptr;
        emit activeAppInfoChanged();
    }
}

void ApplicationModel::onApplicationActivated(const QString &appId, const QString &/*aliasId*/)
{
    if (appId == m_activeAppId)
        return;

    auto *appInfo = application(appId);
    if (!appInfo || !appInfo->canBeActive())
        return;

    appInfo->setActive(true);

    {
        auto *oldAppInfo = application(m_activeAppId);
        if (oldAppInfo)
            oldAppInfo->setActive(false);
    }

    m_activeAppId = appId;
    emit activeAppIdChanged();
    qCDebug(appModel).nospace() << "activeAppId=" << m_activeAppId;
    m_activeAppInfo = appInfo;
    emit activeAppInfoChanged();
}

void ApplicationModel::onApplicationRunStateChanged(const QString &id, QtAM::ApplicationManager::RunState runState)
{
    ApplicationInfo *appInfo = application(id);
    if (!appInfo) {
        return;
    }

    appInfo->setRunning(runState == ApplicationManager::Running);

    if (runState == ApplicationManager::NotRunning) {
        if (appInfo == m_activeAppInfo) {
            goHome();
        }
        if (appInfo->asWidget()) {
            // otherwise the widget would get maximized once restarted.
            appInfo->setCanBeActive(false);

            // Application was killed or crashed while being displayed as a widget.
            // Restart it after a short respite.
            QTimer::singleShot(1000, this, [this, id](){
                m_appMan->startApplication(id);
            });

            // TODO: Give up if the application is crashing during start up (or shortly after) to avoid an endless
            //       crash-restart-crash-restart[...] cycle
        }
    }
}

void ApplicationModel::onWindowPropertyChanged(QQuickItem *window, const QString &name, const QVariant & /*value*/) {
    if (name == "activationCount") {
        auto windowManager = WindowManager::instance();
        QString appId = windowManager->get(windowManager->indexOfWindow(window))["applicationId"].toString();
        emit m_appMan->application(appId)->activated();
        onApplicationActivated(appId, appId);
    }
}

void ApplicationModel::updateWidgetHeightProperty(ApplicationInfo *appInfo)
{
    QQuickItem *window = appInfo->window();
    if (!window) {
        return;
    }

    auto windowManager = WindowManager::instance();
    windowManager->setWindowProperty(window, QStringLiteral("tritonWidgetHeight"), QVariant(appInfo->widgetHeight()));
}

void ApplicationModel::updateCurrentWidthProperty(ApplicationInfo *appInfo)
{
    QQuickItem *window = appInfo->window();
    if (!window) {
        return;
    }

    auto windowManager = WindowManager::instance();
    windowManager->setWindowProperty(window, QStringLiteral("tritonCurrentWidth"), QVariant(appInfo->currentWidth()));
}

void ApplicationModel::updateCurrentHeightProperty(ApplicationInfo *appInfo)
{
    QQuickItem *window = appInfo->window();
    if (!window) {
        return;
    }

    auto windowManager = WindowManager::instance();
    windowManager->setWindowProperty(window, QStringLiteral("tritonCurrentHeight"), QVariant(appInfo->currentHeight()));
}

void ApplicationModel::updateWindowStateProperty(ApplicationInfo *appInfo)
{
    QQuickItem *window = appInfo->window();
    if (!window) {
        return;
    }

    auto windowManager = WindowManager::instance();
    windowManager->setWindowProperty(window, QStringLiteral("tritonState"), QVariant(appInfo->windowState()));
}

void ApplicationModel::updateExposedRectBottomMarginProperty(ApplicationInfo *appInfo)
{
    QQuickItem *window = appInfo->window();
    if (!window) {
        return;
    }

    auto windowManager = WindowManager::instance();
    windowManager->setWindowProperty(window, QStringLiteral("exposedRectBottomMargin"), QVariant(appInfo->exposedRectBottomMargin()));
}

void ApplicationModel::updateExposedRectTopMarginProperty(ApplicationInfo *appInfo)
{
    QQuickItem *window = appInfo->window();
    if (!window) {
        return;
    }

    auto windowManager = WindowManager::instance();
    windowManager->setWindowProperty(window, QStringLiteral("exposedRectTopMargin"), QVariant(appInfo->exposedRectTopMargin()));
}

qreal ApplicationModel::cellWidth() const
{
    return m_cellWidth;
}

void ApplicationModel::setCellWidth(qreal value)
{
    if (m_cellWidth == value) {
        return;
    }

    m_cellWidth = value;

    auto windowManager = WindowManager::instance();
    for (ApplicationInfo *appInfo : qAsConst(m_appInfoList)) {
        windowManager->setWindowProperty(appInfo->window(), QStringLiteral("cellWidth"), QVariant(m_cellWidth));
    }

    emit cellWidthChanged();
}

qreal ApplicationModel::cellHeight() const
{
    return m_cellHeight;
}

void ApplicationModel::setCellHeight(qreal value)
{
    if (m_cellHeight == value) {
        return;
    }

    m_cellHeight = value;

    auto windowManager = WindowManager::instance();
    for (ApplicationInfo *appInfo : qAsConst(m_appInfoList)) {
        windowManager->setWindowProperty(appInfo->window(), QStringLiteral("cellHeight"), QVariant(m_cellHeight));
    }

    emit cellHeightChanged();
}

qreal ApplicationModel::homePageRowHeight() const
{
    return m_homePageRowHeight;
}

void ApplicationModel::setHomePageRowHeight(qreal value)
{
    if (m_homePageRowHeight == value) {
        return; // NOOP
    }

    m_homePageRowHeight = value;

    auto windowManager = WindowManager::instance();
    for (ApplicationInfo *appInfo : qAsConst(m_appInfoList)) {
        windowManager->setWindowProperty(appInfo->window(), QStringLiteral("homePageRowHeight"),
                QVariant(m_homePageRowHeight));
    }

    emit homePageRowHeightChanged();
}

void ApplicationModel::onAsWidgetChanged(ApplicationInfo *appInfo)
{
    if (appInfo->asWidget() && m_appMan->applicationRunState(appInfo->id()) == ApplicationManager::NotRunning) {
        // Starting an app causes it to emit activated() but we don't want it to go active (as being
        // active makes it maximized/fullscreen). We want it to stay as a widget.
        appInfo->setCanBeActive(false);
        startApplication(appInfo->id());
    }
}

void ApplicationModel::startApplication(const QString &appId)
{
    if (m_readyToStartApps) {
        m_appMan->startApplication(appId);
    } else {
        m_appStartQueue.append(appId);
    }
}

bool ApplicationModel::readyToStartApps() const
{
    return m_readyToStartApps;
}

void ApplicationModel::setReadyToStartApps(bool value)
{
    if (m_readyToStartApps == value) {
        return;
    }

    m_readyToStartApps = value;

    if (m_readyToStartApps) {
        for (const QString &appId : qAsConst(m_appStartQueue)) {
            m_appMan->startApplication(appId);
        }
        m_appStartQueue.clear();
    }

    emit readyToStartAppsChanged();
}

QString ApplicationModel::langCode() const
{
    return m_langCode;
}

void ApplicationModel::setLangCode(const QString &locale)
{
    const QString langCode = locale.left(locale.indexOf(QLatin1Char('_')));

    if (langCode != m_langCode) {
        m_langCode = langCode;
        emit dataChanged(index(0), index(count() - 1), {RoleName});
        emit langCodeChanged();

        // broadcast to apps
        auto windowManager = WindowManager::instance();
        for (ApplicationInfo *appInfo : qAsConst(m_appInfoList)) {
            windowManager->setWindowProperty(appInfo->window(), QStringLiteral("locale"), locale);
        }
    }
}

bool ApplicationModel::isInstrumentClusterApp(const QtAM::Application *app)
{
    return app->categories().contains("cluster");
}

void ApplicationModel::setInstrumentClusterAppInfo(ApplicationInfo *appInfo)
{
    if (appInfo != m_instrumentClusterApp) {
        m_instrumentClusterApp = appInfo;
        emit instrumentClusterAppInfoChanged();
    }
}

void ApplicationModel::append(const QtAM::Application *application)
{
    connect(application, &QtAM::Application::bulkChange, this, [this, application](){
        onApplicationChanged(application);
    });

    ApplicationInfo *appInfo = new ApplicationInfo(application);
    QQmlEngine::setObjectOwnership(appInfo, QQmlEngine::CppOwnership);

    connect(appInfo, &ApplicationInfo::startRequested, this, [this, appInfo]() {
        if (m_appMan) {
            m_appMan->startApplication(appInfo->id());
        }
    });
    connect(appInfo, &ApplicationInfo::stopRequested, this, [this, appInfo]() {
        if (m_appMan) {
            m_appMan->stopApplication(appInfo->id());
        }
    });
    connect(appInfo, &ApplicationInfo::widgetHeightChanged, this, [this, appInfo]() {
        updateWidgetHeightProperty(appInfo);
    });
    connect(appInfo, &ApplicationInfo::currentWidthChanged, this, [this, appInfo]() {
        updateCurrentWidthProperty(appInfo);
    });
    connect(appInfo, &ApplicationInfo::currentHeightChanged, this, [this, appInfo]() {
        updateCurrentHeightProperty(appInfo);
    });
    connect(appInfo, &ApplicationInfo::windowStateChanged, this, [this, appInfo]() {
        updateWindowStateProperty(appInfo);
    });
    connect(appInfo, &ApplicationInfo::exposedRectBottomMarginChanged, this, [this, appInfo]() {
        updateExposedRectBottomMarginProperty(appInfo);
    });
    connect(appInfo, &ApplicationInfo::exposedRectTopMarginChanged, this, [this, appInfo]() {
        updateExposedRectTopMarginProperty(appInfo);
    });
    connect(appInfo, &ApplicationInfo::asWidgetChanged, this, [this, appInfo]() {
        onAsWidgetChanged(appInfo);
    });
    m_appInfoList.append(appInfo);
}

void ApplicationModel::remove(const QtAM::Application *application)
{
    disconnect(application, 0, this, 0);

    int index = indexFromApplication(application);
    Q_ASSERT(index != -1);

    beginRemoveRows(QModelIndex() /* parent */,  index /* first */, index /* last */);
    delete m_appInfoList.takeAt(index);
    endRemoveRows();
}

void ApplicationModel::onApplicationChanged(const QtAM::Application *application)
{
    int i = indexFromApplication(application);
    if (i == -1) {
        return;
    }

    // it's a bulk change
    dataChanged(index(i), index(i), {RoleIcon, RoleName});
}

int ApplicationModel::indexFromApplication(const QtAM::Application *application)
{
    int index = 0;
    bool found = false;

    while (index < m_appInfoList.count() && !found) {
        found = m_appInfoList[index]->id() == application->id();
        if (!found)
            ++index;
    }

    return found ? index : -1;
}
