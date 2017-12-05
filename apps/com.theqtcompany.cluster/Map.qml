/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Triton Cluster UI.
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

import QtQuick 2.0

Item {
    id: root
    width: 1920
    height: 720

    //private
    Item {
        id: d
        property real scaleRatio: Math.min(parent.width / 1920, parent.height / 720)
    }

    Image {
        id: bg
        anchors.fill: parent
        source: "./img/bg.png"
    }

    DialSpeed {
        id:ds
        x: 60 * d.scaleRatio
        y: 310* d.scaleRatio
        width: 340 * d.scaleRatio
        height: 340* d.scaleRatio
    }

    DialPower {
        id:dp
        x: 1520 * d.scaleRatio
        y: 310 * d.scaleRatio
        width: 340 * d.scaleRatio
        height: 340* d.scaleRatio
    }
}
