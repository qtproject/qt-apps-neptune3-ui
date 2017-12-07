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
#include "audiosettingsdynamic.h"

AudioSettingsDynamic::AudioSettingsDynamic()
{

}

qreal AudioSettingsDynamic::volume() const
{
    if (m_replicaPtr.isNull())
        return -1;
    return m_replicaPtr.data()->property("volume").toReal();
}

bool AudioSettingsDynamic::muted() const
{
    if (m_replicaPtr.isNull())
        return false;
    return m_replicaPtr.data()->property("muted").toBool();
}

qreal AudioSettingsDynamic::balance() const
{
    if (m_replicaPtr.isNull())
        return -1;
    return m_replicaPtr.data()->property("balance").toReal();
}

void AudioSettingsDynamic::initialize()
{
    connect(m_replicaPtr.data(),SIGNAL(volumeChanged(qreal)),
            this,SIGNAL(volumeChanged(qreal)));
    connect(m_replicaPtr.data(),SIGNAL(mutedChanged(bool)),
            this,SIGNAL(mutedChanged(bool)));
    connect(m_replicaPtr.data(),SIGNAL(balanceChanged(qreal)),
            this,SIGNAL(balanceChanged(qreal)));
    emit volumeChanged(volume());
    emit mutedChanged(muted());
    emit balanceChanged(balance());
}

void AudioSettingsDynamic::setVolume(qreal volume)
{
    if (m_replicaPtr.isNull())
        return;
    QMetaObject::invokeMethod(m_replicaPtr.data(),
                    "pushVolume",Qt::DirectConnection,Q_ARG(qreal,volume));
}

void AudioSettingsDynamic::setMuted(bool muted)
{
    if (m_replicaPtr.isNull())
        return;
    QMetaObject::invokeMethod(m_replicaPtr.data(),
                    "pushMuted",Qt::DirectConnection,Q_ARG(bool,muted));
}

void AudioSettingsDynamic::setBalance(qreal balance)
{
    if (m_replicaPtr.isNull())
        return;
    QMetaObject::invokeMethod(m_replicaPtr.data(),
                    "pushBalance",Qt::DirectConnection,Q_ARG(qreal,balance));
}
