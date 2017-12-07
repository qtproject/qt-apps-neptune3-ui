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
#include "model3dsettingsservice.h"

const QString Model3DSettingsService::baseKey=QStringLiteral("model3d");
const QString Model3DSettingsService::door1OpenKey=baseKey+QStringLiteral("/door1Open");
const QString Model3DSettingsService::door2OpenKey=baseKey+QStringLiteral("/door2Open");

Model3DSettingsService::Model3DSettingsService(QSettings *settings)
    :m_settings(settings)
{
    Model3DSettingsSource::setDoor1Open(m_settings->value(door1OpenKey).toBool());
    Model3DSettingsSource::setDoor2Open(m_settings->value(door2OpenKey).toBool());
}

void Model3DSettingsService::setDoor1Open(bool door1Open)
{
    m_settings->setValue(door1OpenKey,door1Open);
    Model3DSettingsSource::setDoor1Open(door1Open);
}

void Model3DSettingsService::setDoor2Open(bool door2Open)
{
    m_settings->setValue(door2OpenKey,door2Open);
    Model3DSettingsSource::setDoor2Open(door2Open);
}
