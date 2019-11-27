/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
** Copyright (C) 2018 Pelagicore AG
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
#include <QtQml/qqmlinfo.h>
#include <QtGui/QOpenGLContext>
#include <QtGlobal>

#include "systeminfo.h"

/*!
  \qmltype SystemInfo
  \instantiates QObject
  \inqmlmodule shared.com.pelagicore.systeminfo
  \since 5.11
  \brief Provides information about Qt configuration, network state, operating system and hardware.

  A SystemInfo type provides information about the system, in this case the device and the
  Operating System, which the app runs on. It provides Network availability related properties and
  a subset of the C++ \l{QSysInfo} API. All of these properties are read-only.

  \sa QSysInfo
*/
SystemInfo::SystemInfo(QObject *parent)
    : QObject(parent)
    , m_networkManager(new QNetworkAccessManager(this))
{
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
    if (QSslSocket::supportsSsl()) {
        m_timerId = startTimer(1000, Qt::VeryCoarseTimer);
    } else {
        updateInternetAccessStatus(false);
        qmlWarning(this) << "SSL/TLS is not supported in this installation. HTTPS connections can't be established";
        qmlWarning(this) << "Please verify, SSL library is installed and/or updated";
        qmlWarning(this) << "This installation was build with: " << QSslSocket::sslLibraryBuildVersionString();
    }
}

/*
 * This function fills all available Addresses of your device in a list.
*/
void SystemInfo::getAddress()
{
    m_addressList.clear();
    for (const QNetworkInterface &interface : QNetworkInterface::allInterfaces()) {
        if (interface.flags().testFlag(QNetworkInterface::IsUp)
                && !interface.flags().testFlag(QNetworkInterface::IsLoopBack)
                && interface.type() != QNetworkInterface::InterfaceType::Unknown
                && interface.type() != QNetworkInterface::InterfaceType::Loopback
                && interface.type() != QNetworkInterface::InterfaceType::Virtual) {
            for (const QNetworkAddressEntry &entry : interface.addressEntries()) {
                if (interface.hardwareAddress() != QLatin1String("00:00:00:00:00:00")) {
                    m_addressList.append(interface.name() + QLatin1String(" ") + entry.ip().toString() + QLatin1String(" ") + interface.hardwareAddress());
                    emit addressListChanged();
                }
            }
        }
    }

    if (m_addressList.removeDuplicates() > 0 || m_addressList.isEmpty()) {
        emit addressListChanged();
    }

    // Here we suppose that if there is any physical connection, then device is connected
    updateConnectedStatus(!m_addressList.isEmpty());
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

bool SystemInfo::allow3dStudioPresentations()
{
    QOpenGLContext *globalShareContext = QOpenGLContext::globalShareContext();
    if (globalShareContext && globalShareContext->isValid()) {
        return (globalShareContext->isOpenGLES()
                        && globalShareContext->format().version() >= qMakePair(3,0))
                || (!globalShareContext->isOpenGLES()
                        && globalShareContext->format().version() >= qMakePair(4,3));
    }

    return false;
}

void SystemInfo::timerEvent(QTimerEvent *event)
{
    Q_UNUSED(event);
    getAddress();
    auto reply = m_networkManager->get(QNetworkRequest(QUrl("https://www.google.com")));
    connect(reply, QOverload<QNetworkReply::NetworkError>::of(&QNetworkReply::error),
        [=](QNetworkReply::NetworkError code) {
            updateInternetAccessStatus(code == QNetworkReply::NetworkError::NoError);
        }
    );
}

void SystemInfo::updateConnectedStatus(bool status)
{
    if (m_connected != status) {
        m_connected = status;
        emit connectedChanged();
    }
}

void SystemInfo::replyFinished(QNetworkReply *reply)
{
    if (reply->error()) {
        qDebug() << reply->errorString();
        updateInternetAccessStatus(false);
    } else {
        if (reply->bytesAvailable()) {
            updateInternetAccessStatus(true);
        } else {
            updateInternetAccessStatus(false);
        }
    }

    reply->deleteLater();
}

void SystemInfo::updateInternetAccessStatus(bool status)
{
    if (status != m_internetAccess) {
        m_internetAccess = status;
        emit internetAccessChanged();
    }
}

/*!
  \qmlproperty var SystemInfo::addressList

   Returns addresses for all available network interfaces of the device in the following format:

   \c {<interface name> <ip address> <hardware address>}

   \code
   SystemInfo {
        id: sysinfo
   }
   Text {
        text: sysinfo.addressList.join("\n")
   }
   \endcode

   \sa {QNetworkInterface::allInterfaces()}
*/

QStringList SystemInfo::addressList() const
{
    return m_addressList;
}

/*!
    \qmlproperty bool SystemInfo::connected

    Specifies whether the device is connected to the network.
*/
bool SystemInfo::connected() const
{
    return m_connected;
}

/*!
    \qmlproperty bool SystemInfo::internetAccess

    Specifies whether the device has connection to the Internet.
*/
bool SystemInfo::internetAccess() const
{
    return m_internetAccess;
}

/*!
    \qmlproperty string SystemInfo::qtVersion

    Returns the Qt version.

    \sa {QtCore}{qVersion}
*/
QString SystemInfo::qtVersion() const
{
    return QString::fromLatin1(qVersion());
}

/*!
    \qmlproperty string SystemInfo::productName

    Returns a product type, version, as well as tokens like the Operating System type, codenames,
    and more. The result of this function is suitable to display to the user, but not for
    long-term storage, as the string may change in future versions of Qt.

    \sa {QSysInfo::prettyProductName()}
*/
QString SystemInfo::productName() const
{
    return QSysInfo::prettyProductName();
}

/*!
    \qmlproperty string SystemInfo::cpu

    Returns the full architecture string that Qt was compiled for: CPU Architecture, endianness,
    word size and ABI (optional).

    \sa {QSysInfo::buildAbi()}
*/
QString SystemInfo::cpu() const
{
    return QSysInfo::buildAbi();
}

/*!
    \qmlproperty string SystemInfo::kernel

    Returns the Operating System kernel type, for which Qt was compiled.

    \sa {QSysInfo::kernelType()}
*/
QString SystemInfo::kernel() const
{
    return QSysInfo::kernelType();
}

/*!
    \qmlproperty string SystemInfo::kernelVersion

    Returns the Operating System's kernel version.

    \sa {QSysInfo::kernelVersion()}
*/
QString SystemInfo::kernelVersion() const
{
    return QSysInfo::kernelVersion();
}

/*!
    \qmlproperty string SystemInfo::qtDiag

    Returns the output from a \c qtdiag run, which contains information on the current Qt
    installation.
*/

QString SystemInfo::qtDiag() const
{
    return m_qtDiagContents;
}

QVariant SystemInfo::readEnvironmentVariable(const QString &name) const
{
    return qgetenv(name.toLocal8Bit());
}

bool SystemInfo::isEnvironmentVariableSet(const QString &name) const
{
    return !qgetenv(name.toLocal8Bit()).isNull();
}

bool SystemInfo::isEnvironmentVariableEmpty(const QString &name) const
{
    return qgetenv(name.toLocal8Bit()).isEmpty();
}

void SystemInfo::classBegin()
{
    getQtDiagInfo();
}

void SystemInfo::componentComplete()
{
    metaObject()->invokeMethod(this, "init", Qt::QueuedConnection);
}
