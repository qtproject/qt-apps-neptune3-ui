/****************************************************************************
**
** Copyright (C) 2017 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Triton IVI UI.
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
#include "abstractdynamic.h"

AbstractDynamic::AbstractDynamic(QObject *parent)
    : QObject(parent)
    , m_connected(false)
{
}

void AbstractDynamic::resetReplica(QRemoteObjectDynamicReplica *replicaPtr)
{
    if (m_replicaPtr.data()==replicaPtr)
        return;

    setConnected(false);
    if (m_replicaPtr.data()) {
        disconnect(m_replicaPtr.data(),&QRemoteObjectDynamicReplica::initialized,
                   this, &AbstractDynamic::onInitialized);
        disconnect(m_replicaPtr.data(),&QRemoteObjectDynamicReplica::stateChanged,
                   this, &AbstractDynamic::onStateChanged);
    }

    m_replicaPtr.reset(replicaPtr);
    if (m_replicaPtr.isNull())
        return;

    connect(m_replicaPtr.data(),&QRemoteObjectDynamicReplica::initialized,
            this, &AbstractDynamic::onInitialized);
    connect(m_replicaPtr.data(),&QRemoteObjectDynamicReplica::stateChanged,
            this, &AbstractDynamic::onStateChanged);

    if (m_replicaPtr.data()->isInitialized())
        onInitialized();
}

bool AbstractDynamic::connected() const
{
    return m_connected;
}

void AbstractDynamic::onInitialized()
{
    if (m_replicaPtr.isNull())
        return;

    initialize();
    if (m_replicaPtr->state()==QRemoteObjectReplica::Valid)
        setConnected(true);
}

void AbstractDynamic::onStateChanged(QRemoteObjectReplica::State newState,
                                     QRemoteObjectReplica::State oldState)
{
    Q_UNUSED(oldState);
    setConnected(newState==QRemoteObjectReplica::Valid &&
                 m_replicaPtr->isInitialized());
}

void AbstractDynamic::setConnected(bool connected)
{
    if (connected !=m_connected)
    {
        m_connected = connected;
        emit connectedChanged(m_connected);
    }
}

