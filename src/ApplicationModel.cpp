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
    auto appMan = ApplicationManager::instance();
    connect(appMan, &ApplicationManager::applicationWasActivated, this, &ApplicationModel::onApplicationActivated);


    for (int i = 0; i < appMan->count(); ++i) {
        const QtAM::Application *application = appMan->application(i);
        ApplicationInfo *appInfo = new ApplicationInfo(application);
        m_appInfoList.append(appInfo);
    }

    // TODO: Load the widget configuration from some database or file
    configureApps();

    // TODO: Monitor appMan for Application additions and removals.

    auto windowManager = WindowManager::instance();
    connect(windowManager, &WindowManager::windowReady, this, &ApplicationModel::onWindowReady);

    connect(windowManager, &WindowManager::windowLost, this, [windowManager](int index, QQuickItem *window) {
        Q_UNUSED(index)
        // TODO care about animating before releasing
        windowManager->releaseWindow(window);
    });
}

ApplicationModel::~ApplicationModel()
{
    qDeleteAll(m_appInfoList);
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
