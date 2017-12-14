#include "uisettingsdynamic.h"

UISettingsDynamic::UISettingsDynamic()
{

}

QString UISettingsDynamic::language() const
{
    if (m_replicaPtr.isNull())
        return "";
    return m_replicaPtr.data()->property("language").toString();
}

QVariantList UISettingsDynamic::languages() const
{
    if (m_replicaPtr.isNull())
        return QVariantList();
    return m_replicaPtr.data()->property("languages").toList();
}

qreal UISettingsDynamic::volume() const
{
    if (m_replicaPtr.isNull())
        return -1;
    return m_replicaPtr.data()->property("volume").toReal();
}

bool UISettingsDynamic::muted() const
{
    if (m_replicaPtr.isNull())
        return false;
    return m_replicaPtr.data()->property("muted").toBool();
}

qreal UISettingsDynamic::balance() const
{
    if (m_replicaPtr.isNull())
        return -1;
    return m_replicaPtr.data()->property("balance").toReal();
}

int UISettingsDynamic::theme() const
{
    if (m_replicaPtr.isNull())
        return 0;
    return m_replicaPtr.data()->property("theme").toUInt();
}

bool UISettingsDynamic::door1Open() const
{
    if (m_replicaPtr.isNull())
        return false;
    return m_replicaPtr.data()->property("door1Open").toBool();
}

bool UISettingsDynamic::door2Open() const
{
    if (m_replicaPtr.isNull())
        return false;
    return m_replicaPtr.data()->property("door2Open").toBool();
}

void UISettingsDynamic::initialize()
{
    connect(m_replicaPtr.data(),SIGNAL(languageChanged(QString)),
            this,SIGNAL(languageChanged(QString)));
    connect(m_replicaPtr.data(),SIGNAL(languagesChanged(QVariantList)),
            this,SIGNAL(languagesChanged(QVariantList)));
    connect(m_replicaPtr.data(),SIGNAL(volumeChanged(qreal)),
            this,SIGNAL(volumeChanged(qreal)));
    connect(m_replicaPtr.data(),SIGNAL(mutedChanged(bool)),
            this,SIGNAL(mutedChanged(bool)));
    connect(m_replicaPtr.data(),SIGNAL(balanceChanged(qreal)),
            this,SIGNAL(balanceChanged(qreal)));
    connect(m_replicaPtr.data(),SIGNAL(themeChanged(int)),
            this,SIGNAL(themeChanged(int)));
    connect(m_replicaPtr.data(),SIGNAL(door1OpenChanged(bool)),
            this,SIGNAL(door1OpenChanged(bool)));
    connect(m_replicaPtr.data(),SIGNAL(door2OpenChanged(bool)),
            this,SIGNAL(door2OpenChanged(bool)));

    emit languagesChanged(languages());
    emit languageChanged(language());
    emit volumeChanged(volume());
    emit mutedChanged(muted());
    emit balanceChanged(balance());
    emit themeChanged(theme());
    emit door1OpenChanged(door1Open());
    emit door2OpenChanged(door2Open());
}

void UISettingsDynamic::setLanguage(const QString &language)
{
    if (m_replicaPtr.isNull())
        return;
    QMetaObject::invokeMethod(m_replicaPtr.data(),
                    "pushLanguage",Qt::DirectConnection,Q_ARG(QString,language));
}

void UISettingsDynamic::setVolume(qreal volume)
{
    if (m_replicaPtr.isNull())
        return;
    QMetaObject::invokeMethod(m_replicaPtr.data(),
                    "pushVolume",Qt::DirectConnection,Q_ARG(qreal,volume));
}

void UISettingsDynamic::setMuted(bool muted)
{
    if (m_replicaPtr.isNull())
        return;
    QMetaObject::invokeMethod(m_replicaPtr.data(),
                    "pushMuted",Qt::DirectConnection,Q_ARG(bool,muted));
}

void UISettingsDynamic::setBalance(qreal balance)
{
    if (m_replicaPtr.isNull())
        return;
    QMetaObject::invokeMethod(m_replicaPtr.data(),
                    "pushBalance",Qt::DirectConnection,Q_ARG(qreal,balance));
}

void UISettingsDynamic::setTheme(int theme)
{
    if (m_replicaPtr.isNull())
        return;
    QMetaObject::invokeMethod(m_replicaPtr.data(),
                    "pushTheme",Qt::DirectConnection,Q_ARG(int,theme));
}

void UISettingsDynamic::setDoor1Open(bool door1Open)
{
    if (m_replicaPtr.isNull())
        return;
    QMetaObject::invokeMethod(m_replicaPtr.data(),
                    "pushDoor1Open",Qt::DirectConnection,Q_ARG(bool,door1Open));
}

void UISettingsDynamic::setDoor2Open(bool door2Open)
{
    if (m_replicaPtr.isNull())
        return;
    QMetaObject::invokeMethod(m_replicaPtr.data(),
                    "pushDoor2Open",Qt::DirectConnection,Q_ARG(bool,door2Open));
}
