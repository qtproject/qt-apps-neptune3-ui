#pragma once

#include <QAbstractListModel>
#include <QList>

class QQuickItem;

class ApplicationInfo;

class ApplicationModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(QString activeAppId READ activeAppId NOTIFY activeAppIdChanged)
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

signals:
    void applicationSurfaceReady(ApplicationInfo *appInfo, QQuickItem *item);
    void activeAppIdChanged();

private slots:
    void onWindowReady(int index, QQuickItem *window);
    void onApplicationActivated(const QString &appId, const QString &aliasId);

private:
    void configureApps();

    QList<ApplicationInfo*> m_appInfoList;
    QString m_activeAppId;
};

