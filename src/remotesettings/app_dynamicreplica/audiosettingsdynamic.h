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
#ifndef AUDIOSETTINGSDYNAMIC_H
#define AUDIOSETTINGSDYNAMIC_H

#include "abstractdynamic.h"

class AudioSettingsDynamic : public AbstractDynamic
{
    Q_OBJECT
    Q_PROPERTY(qreal volume READ volume WRITE setVolume NOTIFY volumeChanged)
    Q_PROPERTY(bool muted READ muted WRITE setMuted NOTIFY mutedChanged)
    Q_PROPERTY(qreal balance READ balance WRITE setBalance NOTIFY balanceChanged)

public:
    explicit AudioSettingsDynamic();

    qreal volume() const;
    bool muted() const;
    qreal balance() const;

    void initialize() override;

public Q_SLOTS:
    void setVolume(qreal volume);
    void setMuted(bool muted);
    void setBalance(qreal balance);

Q_SIGNALS:
    void volumeChanged(qreal);
    void mutedChanged(bool);
    void balanceChanged(qreal);
};

#endif // AUDIOSETTINGSDYNAMIC_H
