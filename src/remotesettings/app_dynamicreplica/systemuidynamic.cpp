/****************************************************************************
**
** Copyright (C) 2018 Pelagicore AG
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

#include "systemuidynamic.h"

void SystemUIDynamic::initialize()
{
    connect(m_replicaPtr.data(), SIGNAL(secondaryWindowSwitchCountChanged(int)),
            this, SIGNAL(secondaryWindowSwitchCountChanged(int)));

    emit secondaryWindowSwitchCountChanged(secondaryWindowSwitchCount());
}

int SystemUIDynamic::secondaryWindowSwitchCount() const
{
    if (m_replicaPtr.isNull())
        return 0;
    return m_replicaPtr.data()->property("secondaryWindowSwitchCount").toInt();
}

void SystemUIDynamic::setSecondaryWindowSwitchCount(int value)
{
    if (m_replicaPtr.isNull())
        return;
    QMetaObject::invokeMethod(m_replicaPtr.data(),
            "pushSecondaryWindowSwitchCount", Qt::DirectConnection, Q_ARG(int, value));
}
