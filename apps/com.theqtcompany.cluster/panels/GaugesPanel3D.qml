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
import shared.Sizes 1.0
import shared.Style 1.0
import shared.utils 1.0
import QtQuick.Shapes 1.12
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.2
import QtStudio3D.OpenGL 2.5

import "../helpers" 1.0

/*
  \qmltype GaugesPanel
*/

Item {
    id: root

    width: Sizes.dp(Config.instrumentClusterWidth)
    height: width / Config.instrumentClusterUIAspectRatio

    //public
    property bool navigating
    property alias speed: presentation.speed
    property alias speedLimit: presentation.speedLimit
    property var cruiseSpeed // unused here
    property var drivetrain // unused here
    property var ePower // unused here

    property bool rtlMode: false // unused here

    property color gaugesMainColor: Style.accentColor

    property bool lightThemeVisible: Style.theme === Style.Light
    property bool darkThemeVisible: Style.theme === Style.Dark
    property int clusterUIMode // unused here

    Component.onCompleted: startDelay.start();

    //private
    QtObject {
        id: d
        property bool running: false
        function start() { running = true; }
        function restart() { running = false; startDelay.interval = 900; startDelay.start(); }
    }

    Timer {
        id: startDelay
        interval: 100
        onTriggered: d.start()
    }

    Studio3D {
        anchors.fill: parent
        enabled: false
        ViewerSettings {
            scaleMode: ViewerSettings.ScaleModeFit
//            showRenderStats: true
        }

        Presentation {
            id: presentation
            source: Utils.localQt3DStudioPresentationAsset("gauges.uia")
            property int speedLimit: 70
            property int speed: 59
            property int rpm: 0
            property bool speedLimitObjectVisible: speed >= speedLimit
            property real gaugesScale: 2 // default (and max upper bound also) in presentation
            property vector3d speedGaugeRotation: Qt.vector3d(-70.0, -40.0, 0.0) // default in presentation
            property vector3d rpmGaugeRotation:   Qt.vector3d(-70.0,  40.0, 0.0) // default in presentation
            property vector3d speedGaugePosition: Qt.vector3d(-52.0, 0.0, 0.0) // default in presentation
            property vector3d rpmGaugePosition:   Qt.vector3d( 48.0, 0.0, 0.0) // default in presentation


            ParallelAnimation {
                id: changeThemeAnimation
                Vector3dAnimation {
                    target: presentation
                    property: "rpmGaugeRotation"
                    duration: 1000
                    easing.type: Easing.OutBack
                    from: presentation.rpmGaugeRotation
                    to: Qt.vector3d(360, 0, 0).plus(from)
                }

                Vector3dAnimation {
                    target: presentation
                    property: "speedGaugeRotation"
                    duration: 1000
                    easing.type: Easing.OutBack
                    from: presentation.speedGaugeRotation
                    to: Qt.vector3d(360, 0, 0).plus(from)
                }
            }


            SequentialAnimation {
                id: changeGaugesMainColorAnimation

                ParallelAnimation {
                    Vector3dAnimation {
                        target: presentation
                        property: "rpmGaugeRotation"
                        duration: 200
                        easing.type: Easing.OutBack
                        from: presentation.rpmGaugeRotation
                        to:   Qt.vector3d(0, 20, 0).plus(from)
                    }

                    Vector3dAnimation {
                        target: presentation
                        property: "speedGaugeRotation"
                        duration: 200
                        easing.type: Easing.OutBack
                        from: presentation.speedGaugeRotation
                        to:   Qt.vector3d(0, -20, 0).plus(from)
                    }
                }

                ParallelAnimation {
                    Vector3dAnimation {
                        target: presentation
                        property: "rpmGaugeRotation"
                        duration: 400
                        easing.type: Easing.OutBack
                        from: Qt.vector3d(0, 20, 0).plus(presentation.rpmGaugeRotation)
                        to:   Qt.vector3d(0, -20, 0).plus(presentation.rpmGaugeRotation)
                    }

                    Vector3dAnimation {
                        target: presentation
                        property: "speedGaugeRotation"
                        duration: 400
                        easing.type: Easing.OutBack
                        from: Qt.vector3d(0, -20, 0).plus(presentation.speedGaugeRotation)
                        to:   Qt.vector3d(0, 20, 0).plus(presentation.speedGaugeRotation)
                    }
                }

                ParallelAnimation {
                    Vector3dAnimation {
                        target: presentation
                        property: "rpmGaugeRotation"
                        duration: 200
                        easing.type: Easing.OutBack
                        from: Qt.vector3d(0, -20, 0).plus(presentation.rpmGaugeRotation)
                        to:   presentation.rpmGaugeRotation
                    }

                    Vector3dAnimation {
                        target: presentation
                        property: "speedGaugeRotation"
                        duration: 200
                        easing.type: Easing.OutBack
                        from: Qt.vector3d(0, 20, 0).plus(presentation.speedGaugeRotation)
                        to:   presentation.speedGaugeRotation
                    }
                }


            }

            Connections {
                target: root
                function onLightThemeVisibleChanged() {
                    if (!changeGaugesMainColorAnimation.running && !changeThemeAnimation.running) {
                        changeThemeAnimation.start()
                    }
                }

                function onGaugesMainColorChanged() {
                    if (!changeGaugesMainColorAnimation.running && !changeThemeAnimation.running) {
                        changeGaugesMainColorAnimation.start();
                    }
                }
            }

            onSpeedChanged: {
                // here is a correspondence between gauge's degree and rpm:
                // rpm   | 0.5 | 1.0 | 1.5 | 2.0 | 2.5 | 3.0 | 3.5 | 4.0 | 4.5 | 5.0 | 6.0 |
                // deg   | 25  | 40  | 60  | 80  |  98 | 117 | 135 | 155 | 174 | 193 | 231 |
                // here is a correspondence between transmission gears and speed:
                // speed | 0-22 | 23-43 | 44-65 | 66-77 | 78-99 | 100- |
                // gear  |   1  |   2   |    3  |    4  |    5  |   6  |
                // when the speed is changing we emulate transmission stages change
                if (speed < 20) {
                    rpm = 20 + speed * 3.2 // 1 gear
                } else if (speed < 120) {
                    rpm = 80 + speed % 20 // 2 - 5 gear
                } else {
                    rpm = speed - 10 // 6 gear
                }
            }

            DataInput {
                name: "speedVectorQml"
                value: Qt.vector3d(0, presentation.speed / 260 * 270, 0)
            }

            DataInput {
                name: "rpmVectorQml"
                value: Qt.vector3d(0, presentation.rpm, 0)
            }

            DataInput {
                name: "speedLimitObjectVisible"
                value: presentation.speedLimitObjectVisible
            }

            DataInput {
                name: "speedLimitText"
                value: presentation.speedLimit
            }

            DataInput {
                name: "gaugesScale"
                value: Qt.vector3d(presentation.gaugesScale
                                   , presentation.gaugesScale
                                   , presentation.gaugesScale)
            }

            DataInput {
                name: "speedGaugeRotation"
                value: presentation.speedGaugeRotation
            }

            DataInput {
                name: "speedGaugePosition"
                value: presentation.speedGaugePosition
            }

            DataInput {
                name: "rpmGaugeRotation"
                value: presentation.rpmGaugeRotation
            }

            DataInput {
                name: "rpmGaugePosition"
                value: presentation.rpmGaugePosition
            }

            DataInput {
                name: "mainLightColor"
                value: Qt.vector4d(root.gaugesMainColor.r, root.gaugesMainColor.g
                                   ,root.gaugesMainColor.b, 1.0)
            }

            DataInput {
                name: "lightThemeVisible"
                value: root.lightThemeVisible
            }

            DataInput {
                name: "darkThemeVisible"
                value: root.darkThemeVisible
            }
        }
    }

    //states and transitions
    state: "stopped"
    states: [
        State {
            name: "stopped"
            when: !d.running
            PropertyChanges {
                target: presentation;
                speedGaugeRotation: Qt.vector3d(-90.0, 0.0, 0.0);
                rpmGaugeRotation:   Qt.vector3d(-90.0, 0.0, 0.0);
                speedGaugePosition: Qt.vector3d(-52.0, 0.0, 0.0);
                rpmGaugePosition:   Qt.vector3d( 48.0, 0.0, 0.0);
                gaugesScale: 0.3
            }
        },
        State {
            name: "normal"
            when: d.running && !root.navigating
            PropertyChanges {
                target: presentation;
                speedGaugeRotation: Qt.vector3d(-75.0, -20.0, 0.0);
                rpmGaugeRotation:   Qt.vector3d(-75.0,  20.0, 0.0);
                speedGaugePosition: Qt.vector3d(-52.0, -3.0, 0.0);
                rpmGaugePosition:   Qt.vector3d( 48.0, -3.0, 0.0);
                gaugesScale: 1.8
            }
        },
        State {
            name: "navi"
            when: d.running && root.navigating
            PropertyChanges {
                target: presentation;
                speedGaugeRotation: Qt.vector3d(-60.0, -40.0, 0.0);
                rpmGaugeRotation:   Qt.vector3d(-60.0,  40.0, 0.0);
                speedGaugePosition: Qt.vector3d(-56.0, -6.0, 0.0);
                rpmGaugePosition:   Qt.vector3d( 54.0, -6.0, 0.0);
                gaugesScale: 1.4
            }
        }
    ]

    transitions: [
        Transition {
            from: "stopped"
            to: "normal"
            reversible: true
            SequentialAnimation {
                PauseAnimation { duration: 500 }
                PropertyAnimation {
                    target: presentation;
                    properties: "speedGaugeRotation, rpmGaugeRotation, gaugesScale, speedGaugePosition, rpmGaugePosition";
                    duration: 500
                }
            }
        },
        Transition {
            from: "normal"
            to: "navi"
            reversible: true
            SequentialAnimation {
                PauseAnimation { duration: 500 }
                PropertyAnimation {
                    target: presentation;
                    properties: "speedGaugeRotation, rpmGaugeRotation, gaugesScale, speedGaugePosition, rpmGaugePosition";
                    duration: 500
                }
            }
        },
        Transition {
            from: "navi"
            to: "stopped"
            reversible: false
            SequentialAnimation {
                PauseAnimation { duration: 70 }
                PropertyAnimation {
                    target: presentation;
                    properties: "speedGaugeRotation, rpmGaugeRotation, gaugesScale, speedGaugePosition, rpmGaugePosition";
                    duration: 100
                }
            }
        }
    ]
}
