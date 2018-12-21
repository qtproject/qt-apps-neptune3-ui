/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
** Copyright (C) 2018 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Neptune 3 IVI UI.
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
#ifndef SERVER_H
#define SERVER_H

#include <QObject>
#include <QSettings>
#include <QTimer>

#include "core.h"
#include "rep_uisettings_source.h"
#include "rep_instrumentcluster_source.h"
#include "rep_systemui_source.h"
#include "rep_connectionmonitoring_source.h"

Q_DECLARE_LOGGING_CATEGORY(remoteSettingsServer)

class Server : public QObject
{
    Q_OBJECT
public:
    explicit Server(QObject *parent = nullptr);

    void start();

public slots:
    void onROError(QRemoteObjectNode::ErrorCode code);
    void onAboutToQuit();

protected slots:
    void onTimeout();

protected:
    QScopedPointer<UISettingsSimpleSource> m_UISettingsService;
    QScopedPointer<InstrumentClusterSimpleSource> m_instrumentClusterService;
    QScopedPointer<SystemUISimpleSource> m_systemUIService;
    QScopedPointer<ConnectionMonitoringSimpleSource> m_connectionMonitoringService;

    void setInstrumentClusterDefaultValues();
    void initConnectionMonitoring();

private:
    QTimer m_heartBeatTimer;
};

#endif // SERVER_H
