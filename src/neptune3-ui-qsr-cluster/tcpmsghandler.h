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

#ifndef TCPMSGHANDLER_H
#define TCPMSGHANDLER_H

#include <QTimer>
#include <QTcpServer>

#include <QtSafeRenderer/statemanager.h>

using namespace SafeRenderer;
QT_USE_NAMESPACE

class TcpMsgHandler : public QObject
{
    Q_OBJECT
public:
    explicit TcpMsgHandler(StateManager *manager, QObject *parent = nullptr);
    ~TcpMsgHandler() {
    }

    static const quint16 defaultPort;

    void onSpeedLabelsVisibilityChanged(bool visible);
    void onPowerLabelsVisibilityChanged(bool visible);
    void onErrorTextVisibilityChanged(bool visible);

private slots:
    void newConnection();
    void readData();
    void heartbeatTimeout();

private:
    void runServer(const quint16 port);

signals:
    void mainWindowPosGot(quint32 x, quint32 y);

private:
    StateManager *m_stateManager;
    QTcpServer   *m_tcpServer;

    quint32      m_timeout;
    bool         m_heartbeatUpdated;
    bool         m_mainUIFailed;

    QTimer       m_heartbeatTimer;
};

#endif // MSGHANDLER_H
