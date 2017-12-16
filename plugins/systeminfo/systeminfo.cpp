/****************************************************************************
**
** Copyright (C) 2017 Pelagicore AG
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
#include "systeminfo.h"

SystemInfo::SystemInfo(QObject *parent)
    : QObject(parent)
{
}

void SystemInfo::init()
{
    getAddress();
}

/*
 * This function will return all available Addresses of your device in list.
*/
void SystemInfo::getAddress()
{
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
}

QStringList SystemInfo::addressList() const
{
    return m_addressList;
}

void SystemInfo::classBegin()
{
}

void SystemInfo::componentComplete()
{
    metaObject()->invokeMethod(this, "init", Qt::QueuedConnection);
}
