/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Neptune 3 UI.
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

#include <QTcpSocket>
#include <QNetworkInterface>
#include <QtCore>

#include <QtSafeRenderer/qsafeevent.h>
#include <QtSafeRenderer/qsafechecksum.h>

#include "tcpmsghandler.h"

Q_LOGGING_CATEGORY(qsrClusterApp, "qsrcluster.App")

const SafeRenderer::quint16 TcpMsgHandler::defaultPort = 1111U;

TcpMsgHandler::TcpMsgHandler(NeptuneSafeStateManager *manager, QObject *parent)
    : QObject(parent), m_stateManager(manager), m_timeout(0U),
      m_heartbeatUpdated(false), m_mainUIFailed(false)

{
    QObject::connect(&m_heartbeatTimer, &QTimer::timeout, this, &TcpMsgHandler::heartbeatTimeout);

    QSettings settings(QStringLiteral("Luxoft Sweden AB"), QStringLiteral("QSRCluster"));
    SafeRenderer::quint16 port = static_cast<SafeRenderer::quint16>(settings.value(QStringLiteral("connection/listen_port"), defaultPort).toInt());

    runServer(port);
}

void TcpMsgHandler::runServer(const quint16 port)
{
    m_tcpServer = new QTcpServer(this);
    if (!m_tcpServer->listen(QHostAddress::Any, port)) {
        qCritical() << "Unable to start the server on port: " << port << m_tcpServer->errorString();
        return;
    }

    connect(m_tcpServer, &QTcpServer::newConnection, this, &TcpMsgHandler::newConnection);

    QString ipAddress;
    QList<QHostAddress> ipAddressesList = QNetworkInterface::allAddresses();
    // use the first non-localhost IPv4 address
    for (int i = 0U; i < ipAddressesList.size(); ++i) {
        if (ipAddressesList.at(i) != QHostAddress::LocalHost &&
            ipAddressesList.at(i).toIPv4Address()) {
            ipAddress = ipAddressesList.at(i).toString();
            break;
        }
    }
    // if we did not find one, use IPv4 localhost
    if (ipAddress.isEmpty())
        ipAddress = QHostAddress(QHostAddress::LocalHost).toString();

    qCWarning(qsrClusterApp) << "Started server on port: " << port;
}

void TcpMsgHandler::newConnection()
{
    QTcpSocket *clientConnection = m_tcpServer->nextPendingConnection();
    connect(clientConnection, &QAbstractSocket::disconnected,
            clientConnection, &QObject::deleteLater);

    connect(clientConnection, &QAbstractSocket::readyRead,
            this, &TcpMsgHandler::readData);

}

void TcpMsgHandler::heartbeatTimeout()
{
    if (m_heartbeatUpdated == false) {
        //got heartbeat, started timer, no heartbeat, timer fired -> non-safe gui failed

        if (m_mainUIFailed == false) { //no more main UI, first time check, show error message
            onErrorTextVisibilityChanged(true);
            onPowerLabelsVisibilityChanged(true);
            onSpeedLabelsVisibilityChanged(true);

            //reset for repaired cluster
            m_mainUIFailed = true;
            m_timeout = 0;
            m_heartbeatTimer.stop();
        }
    } else {

        if (m_timeout > 0) { //not first time run after non-safe cluster connection

            if (m_mainUIFailed) { //repair after fail
                onErrorTextVisibilityChanged(false);
                onPowerLabelsVisibilityChanged(false);
                onSpeedLabelsVisibilityChanged(false);
                m_mainUIFailed = false;
            }

            m_heartbeatUpdated = false; //reset flag for next timeout check
            m_heartbeatTimer.setInterval(m_timeout); //reset interval for new value
        }
    }
}

void TcpMsgHandler::readData()
{
    QTcpSocket *clientConnection = qobject_cast<QTcpSocket *>(QObject::sender());
    if (clientConnection) {
        unsigned char dataBuffer[SafeRenderer::QSafeEvent::messageLength];
        unsigned int datalength = 0U;
        do {
            QByteArray data = clientConnection->read(SafeRenderer::QSafeEvent::messageLength);
            datalength = data.length();
            if (datalength == SafeRenderer::QSafeEvent::messageLength) {
                memcpy (&dataBuffer[0U], data.data(), SafeRenderer::QSafeEvent::messageLength);
                SafeRenderer::QSafeEvent event(dataBuffer);

                if (event.type() == SafeRenderer::EventHeartbeatUpdate) {
                    const QSafeEventHeartbeat &heartbeat = static_cast<const QSafeEventHeartbeat &>(event);

                    if (m_timeout == 0U) { //first message -> start timer
                        m_heartbeatUpdated = true; //reset updated flag
                        m_heartbeatTimer.start(heartbeat.timeout());
                    }

                    if (m_heartbeatUpdated == false) {
                        m_heartbeatUpdated = true; //reset flag for next timeout check
                    }
                    m_timeout = heartbeat.timeout();
                }

                if (event.type() == SafeRenderer::EventSetPosition) {
                    const QSafeEventPosition &movePos = static_cast<const QSafeEventPosition &>(event);
                    const char* item = "mainWindow";
                    //Demo case, move telltales over Cluster window
                    if (movePos.id() == qsafe_hash(item, safe_strlen(item))) {
                        //skip handling, just apply position
                        emit mainWindowPosGot(static_cast<int>(movePos.x()), static_cast<int>(movePos.y()));
                        continue;
                    }
                }

                m_stateManager->handleEvent(event);
            }
        } while (datalength > 0U);

        clientConnection->disconnectFromHost();
    }
}

void TcpMsgHandler::onSpeedLabelsVisibilityChanged(bool visible)
{
    m_stateManager->setIsSpeedVisible(visible);

    QSafeEventVisibility event;

    const char* item0 = "speedTextLabel";
    const char* item1 = "speedUnitsText";
    const char* item2 = "speedText";

    event.setId(qsafe_hash(item0, safe_strlen(item0)));
    event.setValue(visible);
    m_stateManager->handleEvent(event);

    event.setId(qsafe_hash(item1, safe_strlen(item1)));
    event.setValue(visible);
    m_stateManager->handleEvent(event);

    event.setId(qsafe_hash(item2, safe_strlen(item2)));
    event.setValue(visible);
    m_stateManager->handleEvent(event);
}

void TcpMsgHandler::onPowerLabelsVisibilityChanged(bool visible)
{
    m_stateManager->setIsPowerVisible(visible);

    QSafeEventVisibility event;

    const char* item0 = "powerTextLabel";
    const char* item1 = "powerUnitsText";
    const char* item2 = "powerText";

    event.setId(qsafe_hash(item0, safe_strlen(item0)));
    event.setValue(visible);
    m_stateManager->handleEvent(event);

    event.setId(qsafe_hash(item1, safe_strlen(item1)));
    event.setValue(visible);
    m_stateManager->handleEvent(event);

    event.setId(qsafe_hash(item2, safe_strlen(item2)));
    event.setValue(visible);
    m_stateManager->handleEvent(event);
}

void TcpMsgHandler::onErrorTextVisibilityChanged(bool visible)
{
    QSafeEventVisibility event;
    const char* item = "errorText";
    event.setId(qsafe_hash(item, safe_strlen(item)));
    event.setValue(visible);
    m_stateManager->handleEvent(event);
}
