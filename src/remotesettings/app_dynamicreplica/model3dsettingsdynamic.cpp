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
#include "model3dsettingsdynamic.h"

Model3DSettingsDynamic::Model3DSettingsDynamic()
{

}

bool Model3DSettingsDynamic::door1Open() const
{
    if (m_replicaPtr.isNull())
        return false;
    return m_replicaPtr.data()->property("door1Open").toBool();
}

bool Model3DSettingsDynamic::door2Open() const
{
    if (m_replicaPtr.isNull())
        return false;
    return m_replicaPtr.data()->property("door2Open").toBool();
}

void Model3DSettingsDynamic::initialize()
{
    connect(m_replicaPtr.data(),SIGNAL(door1OpenChanged(bool)),
            this,SIGNAL(door1OpenChanged(bool)));
    connect(m_replicaPtr.data(),SIGNAL(door2OpenChanged(bool)),
            this,SIGNAL(door2OpenChanged(bool)));
    emit door1OpenChanged(door1Open());
    emit door2OpenChanged(door2Open());
}

void Model3DSettingsDynamic::setDoor1Open(bool door1Open)
{
    if (m_replicaPtr.isNull())
        return;
    QMetaObject::invokeMethod(m_replicaPtr.data(),
                    "pushDoor1Open",Qt::DirectConnection,Q_ARG(bool,door1Open));
}

void Model3DSettingsDynamic::setDoor2Open(bool door2Open)
{
    if (m_replicaPtr.isNull())
        return;
    QMetaObject::invokeMethod(m_replicaPtr.data(),
                    "pushDoor2Open",Qt::DirectConnection,Q_ARG(bool,door2Open));
}
