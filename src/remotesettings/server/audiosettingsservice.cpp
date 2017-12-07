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
#include "audiosettingsservice.h"

const QString AudioSettingsService::baseKey=QStringLiteral("audio");
const QString AudioSettingsService::volumeKey=baseKey+QStringLiteral("/volume");
const QString AudioSettingsService::mutedKey=baseKey+QStringLiteral("/muted");
const QString AudioSettingsService::balanceKey=baseKey+QStringLiteral("/balance");

AudioSettingsService::AudioSettingsService(QSettings *settings)
    :m_settings(settings)
{
    AudioSettingsSource::setVolume(m_settings->value(volumeKey).toReal());
    AudioSettingsSource::setMuted(m_settings->value(mutedKey).toBool());
    AudioSettingsSource::setBalance(m_settings->value(balanceKey).toReal());
}

void AudioSettingsService::setVolume(qreal volume)
{
    m_settings->setValue(volumeKey,volume);
    AudioSettingsSource::setVolume(volume);
}

void AudioSettingsService::setMuted(bool muted)
{
    m_settings->setValue(mutedKey,muted);
    AudioSettingsSource::setMuted(muted);
}

void AudioSettingsService::setBalance(qreal balance)
{
    m_settings->setValue(balanceKey,balance);
    AudioSettingsSource::setBalance(balance);
}
