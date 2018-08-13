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
#include <QtNetwork>
#include <QStandardPaths>
#include <QSysInfo>
#include <QLibraryInfo>

#include "systeminfo.h"

SystemInfo::SystemInfo(QObject *parent)
    : QObject(parent),
      m_online(true)
{
    m_networkManager = new QNetworkAccessManager(this);
    connect(
        m_networkManager, &QNetworkAccessManager::finished,
        this, &SystemInfo::replyFinished
    );
}

SystemInfo::~SystemInfo()
{
    killTimer(m_timerId);
#if QT_CONFIG(process)
    delete m_diagProc;
#endif
}

void SystemInfo::init()
{
    getAddress();
    m_timerId = startTimer(1000, Qt::VeryCoarseTimer);

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
    m_qtDiagContents.clear();
    // first try in the current Qt dir
    QString qtdiagExe = QStandardPaths::findExecutable(QStringLiteral("qtdiag"), {QLibraryInfo::location(QLibraryInfo::BinariesPath)});
    if (qtdiagExe.isEmpty()) {
        // try in $PATH
        qtdiagExe = QStandardPaths::findExecutable(QStringLiteral("qtdiag"));
    }
    if (qtdiagExe.isEmpty()) {
        m_qtDiagContents = QObject::tr("The qtdiag program could not be found.");
        emit qtDiagChanged();
        return;
    }

#if QT_CONFIG(process)
    m_diagProc = new QProcess;
    connect(m_diagProc, QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished), this,
            [this, qtdiagExe](int, QProcess::ExitStatus exitStatus) {
        if (exitStatus == QProcess::NormalExit) {
            m_qtDiagContents = QString::fromUtf8(m_diagProc->readAllStandardOutput());
        } else {
            m_qtDiagContents = QObject::tr("The qtdiag program exited unsuccessfully/crashed.");
        }
        m_diagProc->close();
        m_qtDiagContents.prepend(QObject::tr("Output from %1:").arg(qtdiagExe) + QStringLiteral("\n\n"));
        emit qtDiagChanged();
    });
    m_diagProc->start(qtdiagExe, QProcess::ReadOnly);
#endif
}

void SystemInfo::timerEvent(QTimerEvent *event)
{
    Q_UNUSED(event);
    auto reply = m_networkManager->get(QNetworkRequest(QUrl("https://www.google.com")));
    connect(reply, QOverload<QNetworkReply::NetworkError>::of(&QNetworkReply::error),
        [=](){ updateOnlineStatus(false);
    });
}

void SystemInfo::replyFinished(QNetworkReply *reply)
{
    if (reply->error()) {
        qDebug() << reply->errorString();
        updateOnlineStatus(false);
    } else {
        if (reply->bytesAvailable()) {
            updateOnlineStatus(true);
        } else {
            updateOnlineStatus(false);
        }
    }
    reply->deleteLater();
}

void SystemInfo::updateOnlineStatus(bool status)
{
    if (status != m_online) {
        m_online = status;
        emit onlineChanged();
        getAddress();
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
    getQtDiagInfo();
}

void SystemInfo::componentComplete()
{
    metaObject()->invokeMethod(this, "init", Qt::QueuedConnection);
}
