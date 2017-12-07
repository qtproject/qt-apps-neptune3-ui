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
#ifndef MODEL3DSETTINGSDYNAMIC_H
#define MODEL3DSETTINGSDYNAMIC_H

#include "abstractdynamic.h"

class Model3DSettingsDynamic : public AbstractDynamic
{
    Q_OBJECT
    Q_PROPERTY(bool door1Open READ door1Open WRITE setDoor1Open NOTIFY door1OpenChanged)
    Q_PROPERTY(bool door2Open READ door2Open WRITE setDoor2Open NOTIFY door2OpenChanged)

public:
    explicit Model3DSettingsDynamic();

    bool door1Open() const;
    bool door2Open() const;

    void initialize() override;

public Q_SLOTS:
    void setDoor1Open(bool door1Open);
    void setDoor2Open(bool door2Open);

Q_SIGNALS:
    void door1OpenChanged(bool);
    void door2OpenChanged(bool);
};

#endif // MODEL3DSETTINGSDYNAMIC_H
