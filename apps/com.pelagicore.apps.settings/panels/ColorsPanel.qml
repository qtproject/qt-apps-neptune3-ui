/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
** Copyright (C) 2018 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Neptune 3 IVI UI.
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

import QtQuick 2.8
import QtQuick.Controls 2.3

import "../controls"

Control {
    id: root

    property alias model: chart.chartData

    property color currentAccentColor

    signal accentColorRequested(color accentColor)

    function update() {
        chart.requestPaint();
    }

    contentItem: ColorSelector {
        id: chart
        width: root.availableWidth
        height: root.availableHeight
        chartOptions: ({ segmentStrokeWidth: 15 })

        MouseArea {
            anchors.fill: parent
            onPressed: {
                var ctx = chart.context;
                const pixel = ctx.getImageData(mouse.x, mouse.y, 1, 1).data;
                const color = Qt.rgba(pixel[0]/255, pixel[1]/255, pixel[2]/255, pixel[3]);
                if (color.a > 0) { // prevent misclicks outside of the colored areas
                    root.accentColorRequested(color);
                    chart.requestPaint();
                }
            }
        }
    }
}
