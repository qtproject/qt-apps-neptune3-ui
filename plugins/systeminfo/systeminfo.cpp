/****************************************************************************
**
** Copyright (C) 2017-2018 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Neptune IVI UI.
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

#include <QNetworkInterface>

#include <QDBusConnection>
#include <QDBusPendingReply>
#include <QStandardPaths>
#include <QSysInfo>
#include <QTimer>

#include "systeminfo.h"

#define NM_SERVICE QStringLiteral("org.freedesktop.NetworkManager")
#define NM_PATH QStringLiteral("/org/freedesktop/NetworkManager")
#define NM_IFACE QStringLiteral("org.freedesktop.NetworkManager")

#define SD_SERVICE QStringLiteral("org.freedesktop.network1")
#define SD_PATH QStringLiteral("/org/freedesktop/network1")
#define SD_IFACE QStringLiteral("org.freedesktop.DBus.Properties")
#define SD_PROPPATH QStringLiteral("org.freedesktop.network1.Manager")
#define SD_PROP QStringLiteral("OperationalState")

SystemInfo::SystemInfo(QObject *parent)
    : QObject(parent)
{
}

SystemInfo::~SystemInfo()
{
    delete m_diagProc;
}

void SystemInfo::init()
{
    getAddress();
}

/*
 * This function will return all available Addresses of your device in list.
*/
void SystemInfo::getAddress()
{
    m_addressList.clear();
    for (const QNetworkInterface &interface : QNetworkInterface::allInterfaces())
    {
        if (interface.flags().testFlag(QNetworkInterface::IsUp) && !interface.flags().testFlag(QNetworkInterface::IsLoopBack)) {
            for (const QNetworkAddressEntry &entry : interface.addressEntries())
            {
                if (interface.hardwareAddress() != QLatin1String("00:00:00:00:00:00")) {
                    m_addressList.append(interface.name() + QLatin1String(" ") + entry.ip().toString() + QLatin1String(" ") + interface.hardwareAddress());
                    emit addressListChanged();
                }
            }
        }
    }
    if (m_addressList.removeDuplicates() > 0) {
        emit addressListChanged();
    }

}

void SystemInfo::getQtDiagInfo()
{
    const QString qtdiagExe = QStandardPaths::findExecutable(QStringLiteral("qtdiag"));
    if (qtdiagExe.isEmpty()) {
        m_qtDiagContents = QObject::tr("The qtdiag program could not be found.");
        emit this->qtDiagChanged();
        return;
    }

    m_diagProc = new QProcess;
    connect(m_diagProc, QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished), this,
            [this](int, QProcess::ExitStatus exitStatus) {
        if (exitStatus == QProcess::NormalExit) {
            m_qtDiagContents = QString::fromUtf8(m_diagProc->readAllStandardOutput());
        } else {
            m_qtDiagContents = QObject::tr("The qtdiag program exited unsuccessfully/crashed.");
        }
        m_diagProc->close();
        emit this->qtDiagChanged();
    });
    m_diagProc->start(qtdiagExe, QProcess::ReadOnly);
}

void SystemInfo::updateOnlineStatusNm(quint32 state)
{
    const bool online = state == 70; // NM_STATE_CONNECTED_GLOBAL
    if (online != m_online) {
        m_online = online;
        emit onlineChanged();
        QTimer::singleShot(1000, this, &SystemInfo::getAddress);
    }
}

void SystemInfo::updateOnlineStatusSd(const QVariant &state)
{
    const bool online = state.toString() == QStringLiteral("routable");
    if (online != m_online) {
        m_online = online;
        emit onlineChanged();
        QTimer::singleShot(1000, this, &SystemInfo::getAddress);
    }
}

void SystemInfo::updateOnlineStatusSdPropChange(const QString &interface, const QVariantMap &changedprop, const QStringList &)
{
    if (interface == QStringLiteral("org.freedesktop.network1.Manager")) {
        if (changedprop.contains(QStringLiteral("OperationalState"))) {
            updateOnlineStatusSd(changedprop[QStringLiteral("OperationalState")]);
        };
    }
}

QStringList SystemInfo::addressList() const
{
    return m_addressList;
}

bool SystemInfo::online() const
{
    return m_online;
}

QString SystemInfo::qtVersion() const
{
    return QString::fromLatin1(qVersion());
}

QString SystemInfo::productName() const
{
    return QSysInfo::prettyProductName();
}

QString SystemInfo::cpu() const
{
    return QSysInfo::currentCpuArchitecture();
}

QString SystemInfo::kernel() const
{
    return QSysInfo::kernelType() + QStringLiteral(" ") + QSysInfo::kernelVersion();
}

QString SystemInfo::qtDiag() const
{
    return m_qtDiagContents;
}

void SystemInfo::classBegin()
{
    //TODO: Refactoring needed. This code does not check presence of systemd-networkd or network manager
    auto conn = QDBusConnection::systemBus();
    conn.connect(NM_SERVICE, NM_PATH, NM_IFACE, QStringLiteral("StateChanged"),
                 this, SLOT(updateOnlineStatusNm(quint32)));
    conn.connect(SD_SERVICE, SD_PATH, SD_IFACE, QStringLiteral("PropertiesChanged"),
                 this, SLOT(updateOnlineStatusSdPropChange(QString, QVariantMap, QStringList)));


    QDBusMessage msg = QDBusMessage::createMethodCall(NM_SERVICE, NM_PATH, NM_IFACE, QStringLiteral("state"));
    QDBusPendingCall pCall1 = conn.asyncCall(msg);
    QDBusPendingCallWatcher *watcher1 = new QDBusPendingCallWatcher(pCall1, this);
    connect(watcher1, &QDBusPendingCallWatcher::finished, [this](QDBusPendingCallWatcher *self) {
        QDBusPendingReply<quint32> reply = *self;
        self->deleteLater();
        if (reply.isValid()) {
            updateOnlineStatusNm(reply.value());
        } else {
            qWarning() << "Error getting online status from NetworkManager" << reply.error().name() << reply.error().message();
        }
    });

    msg = QDBusMessage::createMethodCall(SD_SERVICE, SD_PATH, SD_IFACE, QStringLiteral("Get"));
    QList<QVariant> arguments;
    arguments << SD_PROPPATH << SD_PROP;
    msg.setArguments(arguments);
    QDBusPendingCall pCall2 = conn.asyncCall(msg);
    QDBusPendingCallWatcher *watcher2 = new QDBusPendingCallWatcher(pCall2, this);
    connect(watcher2, &QDBusPendingCallWatcher::finished, [this](QDBusPendingCallWatcher *self) {
        QDBusPendingReply<QVariant> reply = *self;
        self->deleteLater();
        if (reply.isValid()) {
            updateOnlineStatusSd(reply.value());
        } else {
            qWarning() << "Error getting online status from Systemd-Networkd" << reply.error().name() << reply.error().message();
        }
    });

    getQtDiagInfo();
}

void SystemInfo::componentComplete()
{
    metaObject()->invokeMethod(this, "init", Qt::QueuedConnection);
}
