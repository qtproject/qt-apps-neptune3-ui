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
#ifndef ABSTRACTDYNAMIC_H
#define ABSTRACTDYNAMIC_H

#include <QObject>
#include <QSharedPointer>
#include <QRemoteObjectNode>

class AbstractDynamic : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool connected READ connected NOTIFY connectedChanged)

public:
    explicit AbstractDynamic(QObject *parent = nullptr);

    void resetReplica(QRemoteObjectDynamicReplica *replicaPtr);
    bool connected() const;

signals:
    void connectedChanged(bool connected);

protected:
    virtual void initialize()=0;

protected slots:
    void onInitialized();
    void onStateChanged(QRemoteObjectReplica::State newState,
                        QRemoteObjectReplica::State oldState);
    void setConnected(bool connected);

protected:
    QSharedPointer<QRemoteObjectDynamicReplica> m_replicaPtr;
    bool m_connected;
};

#endif // ABSTRACTDYNAMIC_H
