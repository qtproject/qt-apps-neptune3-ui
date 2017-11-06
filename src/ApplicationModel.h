#pragma once

#include <QAbstractListModel>
#include <QList>

namespace QtAM {
    class ApplicationManager;
    class WindowManager;
}

class QQuickItem;

class ApplicationInfo;

class ApplicationModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(QString activeAppId READ activeAppId NOTIFY activeAppIdChanged)
    Q_PROPERTY(int count READ count NOTIFY countChanged)
    Q_PROPERTY(QtAM::ApplicationManager* applicationManager READ applicationManager WRITE setApplicationManager NOTIFY applicationManagerChanged)
    Q_PROPERTY(QtAM::WindowManager* windowManager READ windowManager WRITE setWindowManager NOTIFY windowManagerChanged)
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

signals:
    void applicationSurfaceReady(ApplicationInfo *appInfo, QQuickItem *item);
    void activeAppIdChanged();
    void applicationManagerChanged();
    void windowManagerChanged();
    void countChanged();

private slots:
    void onWindowReady(int index, QQuickItem *window);
    void onApplicationActivated(const QString &appId, const QString &aliasId);

private:
    void configureApps();

    QList<ApplicationInfo*> m_appInfoList;
    QString m_activeAppId;
    QtAM::ApplicationManager *m_appMan{nullptr};
    QtAM::WindowManager *m_windowManager{nullptr};
};

