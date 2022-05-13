/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
** Copyright (C) 2018 Pelagicore AG
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the Qt Quick Controls 2 module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL3$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see http://www.qt.io/terms-conditions. For further
** information use the contact form at http://www.qt.io/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 3 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPLv3 included in the
** packaging of this file. Please review the following information to
** ensure the GNU Lesser General Public License version 3 requirements
** will be met: https://www.gnu.org/licenses/lgpl.html.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 2.0 or later as published by the Free
** Software Foundation and appearing in the file LICENSE.GPL included in
** the packaging of this file. Please review the following information to
** ensure the GNU General Public License version 2.0 requirements will be
** met: http://www.gnu.org/licenses/gpl-2.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.10
import QtQuick.Templates 2.3 as T

import shared.utils 1.0
import shared.Style 1.0
import shared.Sizes 1.0

T.Slider {
    id: control

    implicitWidth: Math.max(background ? background.implicitWidth : 0,
                           (handle ? handle.implicitWidth : 0) + leftPadding + rightPadding)
    implicitHeight: Math.max(background ? background.implicitHeight : 0,
                            (handle ? handle.implicitHeight : 0) + topPadding + bottomPadding)

    live: false
    snapMode: Slider.SnapOnRelease

    opacity: enabled ? 1.0 : 0.3

    QtObject {
        id: d
        readonly property int numberSteps: control.stepSize !== 0 ?
                                               (control.to - control.from) / control.stepSize : 0
        readonly property int railSize: control.Sizes.dp(10)
        readonly property real railLength: handle ? (control.horizontal ?
                                                         control.availableWidth - handle.width :
                                                         control.availableHeight - handle.height) :
                                                    (control.horizontal ? control.implicitWidth : control.implicitHeight)
        readonly property real stepLength: numberSteps ?
                                               (railLength - gap * (numberSteps - 1)) / numberSteps : 0.0
        readonly property int gap: control.Sizes.dp(3)
    }

    handle: Rectangle {
        id: handle
        x: control.leftPadding +
           (control.horizontal ? control.visualPosition * (control.availableWidth - width) :
                                 (control.availableWidth - width) / 2)
        y: control.topPadding +
           (control.horizontal ? (control.availableHeight - height) / 2 :
                                 control.visualPosition * (control.availableHeight - height))
        width: Sizes.dp(40)
        height: width
        implicitWidth: width
        implicitHeight: height

        color: "#FFFFFFFF"
        border.color: "#FF878787"
        border.width: Sizes.dp(2)
        radius: width / 2 // make it perfectly round
    }

    background: Item {
        id: railContainer
        x: control.leftPadding + (control.horizontal ? handle.width / 2 : (control.availableWidth - width) / 2)
        y: control.topPadding + (control.horizontal ? (control.availableHeight - height) / 2 : handle.height / 2)

        width: control.horizontal ? d.railLength : d.railSize
        height: control.horizontal ? d.railSize : d.railLength

        Repeater {
            enabled: d.numberSteps
            model: d.numberSteps
            delegate: Rectangle {
                id: rectStep
                x: control.horizontal ? index * (d.stepLength + d.gap) : 0
                y: control.horizontal ? 0 : index * (d.stepLength + d.gap)
                width: control.horizontal ? d.stepLength : railContainer.width
                height: control.horizontal ? railContainer.height : d.stepLength
                color: filled ? Style.accentColor : "#FFAAAAAA"

                property bool filled: control.horizontal ?
                             (handle.x > (rectStep.x+d.stepLength/2) ? (control.mirrored ? false : true) : (control.mirrored ? true : false)) :
                             (handle.y > rectStep.y+d.stepLength/2 ? false : true)
            }
        }

        Rectangle {
            width: parent.width
            height: parent.height
            color: "#FFAAAAAA"
            visible: d.numberSteps === 0
        }

        Rectangle {
            x: control.horizontal ? (control.mirrored ? handle.x : 0) : (parent.width - width) / 2
            y: control.horizontal ? (parent.height - height) / 2 : control.visualPosition * parent.height
            width: control.horizontal ? control.position * parent.width : parent.width
            height: control.horizontal ? parent.height : control.position * parent.height
            visible: d.numberSteps === 0
            color: Style.accentColor
        }
    }
}
