/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Neptune 3 Cluster UI.
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

import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import "../helpers" 1.0
import shared.Style 1.0
import shared.Sizes 1.0

/*!
    \qmltype ClusterUnitsLabel
    A lucee component for showing value with units
*/

Item{
    id: root

    /*!
        \qmlproperty string ClusterUnitsLabel::value
        Value part
    */
    property alias value: valueLabel.text
    /*!
        \qmlproperty string ClusterUnitsLabel::units
        Units part
    */
    property alias units: unitsLabel.text
    /*!
        \qmlproperty int ClusterUnitsLabel::pixelSize
        Value part font pixel size, units scaled down by 0.7
    */
    property alias pixelSize: valueLabel.font.pixelSize
    /*!
        \qmlproperty int ClusterUnitsLabel::fontColor
        Lables text color
    */
    property color fontColor: "#5e5d5d"

    width: row.width
    height: row.height

    Row{
        id: row

        Label {
            id: valueLabel
            verticalAlignment: Text.AlignBottom
            horizontalAlignment: Text.AlignHCenter
            opacity: Style.opacityHigh
            color: root.fontColor
        }

        Label {
            id: unitsLabel
            verticalAlignment: Text.AlignBottom
            horizontalAlignment: Text.AlignHCenter
            opacity: Style.opacityHigh
            font.pixelSize: valueLabel.font.pixelSize * 0.7
            color: root.fontColor
            anchors.baseline: valueLabel.baseline
        }
    }
}
