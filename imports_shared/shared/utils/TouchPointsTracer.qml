/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
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

import QtQuick 2.13
import QtQuick.Controls 2.2

import shared.Style 1.0
import shared.Sizes 1.0
import shared.com.luxoft.eventslisteners 1.0


/*!
    \qmltype TouchPointsTracer
    \inqmlmodule utils
    \inherits Item
    \since 5.13
    \brief The mouse/touches tracer for Neptune 3 UI.

    The tracer is used to visualize touch points to help developers see if a touch-device
    was configured correctly.
    To enable this object, set the \c SHOW_TOUCH_POINTS environment variable to \c yes.

    The code snippet below shows how to use \l{TouchPointsTracer}:

    \qml
    import QtQuick 2.10
    import shared.utils 1.0

    Window {
        id: root

        width: 80
        height: 80

        TouchPointsTracer {
            id: eventsListener
            target: root
        }
    }
    \endqml
*/

Item {
    id: root
    /*!
        \qmlproperty var TouchPointsTracer::target

        This property contains the object that was added for event listening.
        If the target is changed, the previous one is unsubscribed.
    */
    property var target: null
    /*!
        \qmlproperty bool TouchPointsTracer::showCoords

        This property controls whether coordinates of touch visible or not.
    */
    property bool showCoords: false

    onTargetChanged: TouchPointsTracer.target = target

    TouchPointsTracer.onTouchPointsChanged: {
        for (var i=0; i < points.length; i+=2) {
            var rec = repeater.itemAt(i / 2);
            rec.x = points[i]
            rec.y = points[i + 1]
            rec.restartAnimation();
        }
    }

    Repeater {
        id: repeater
        model: 10
        Item {
            id: _item
            visible: false
            width: Sizes.dp(100)
            height: width

            function restartAnimation() {
                recAnimation.restart();
            }

            Rectangle {
                id: _rec
                width: parent.width
                height: parent.height
                radius: width/2
                x: -width/2
                y: -width/2
                color: "transparent"
                border.color: Style.accentColor
                border.width: Sizes.dp(5)


                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width * 0.7
                    height: width
                    radius: width/2
                    opacity: 0.5
                    color: Style.accentColor
                }

                Rectangle {
                    anchors.centerIn: parent
                    width: Sizes.dp(10)
                    height: width
                    radius: width/2
                    color: Style.accentColor
                }

                SequentialAnimation {
                    id: recAnimation
                    ScriptAction { script: _item.visible = true; }
                    PauseAnimation { duration: 300 }
                    ScriptAction { script: _item.visible = false; }
                }
            }

            Label {
                visible: root.showCoords
                anchors.horizontalCenter: _rec.horizontalCenter
                anchors.bottom: _rec.top
                text: _item.x + ", " + _item.y
            }
        }
    }
}
