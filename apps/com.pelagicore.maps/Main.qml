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

import QtQuick 2.6
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.4
import utils 1.0

import QtApplicationManager 1.0

QtObject {
    property var primaryWindow: AppUIScreen {
        id: root

        SplitView {
            anchors.fill: parent
            orientation: Qt.Vertical
            //Rectangle
            Item
            {
                width: parent.width
                height: splitBtn.splitMaps? parent.height / 2: parent.height

                Maps {
                    anchors.fill: parent
                }
            }
            //Rectangle
            Item
            {
                width: parent.width
                height: splitBtn.splitMaps? parent.height / 2: parent.height

                Maps {
                    anchors.fill: parent
                }
            }
        }

        MultiPointTouchArea {
            id: multiPoint
            anchors {
                fill: parent
                margins: 30
            }
            touchPoints: [ TouchPoint { id: touchPoint1 } ]
            property int count: 0
            onReleased: {
                count += 1;
                root.setWindowProperty("activationCount", count);
            }

        }

        Rectangle {
            id: searchBtn
            width: 100; height: width; radius: width / 2
            anchors {
                top: parent.top
                left: parent.left
                margins: 25
            }
            color: "white"
            visible: "Widget1Row" === root.tritonState
            RectangularGlow {
                id: effect
                anchors.fill: searchBtn
                glowRadius: 100
                spread: 0
                color: "#ffffff"
                cornerRadius: searchBtn.radius
            }
            Text {
                anchors.centerIn: parent
                text: "Search"
            }
            property bool showGuidance: false
            MouseArea {
                anchors.fill: parent
                onClicked: searchBtn.showGuidance = true
            }
        }

        Rectangle {
            id: carsBtn
            anchors { top: searchPanel.bottom; left: parent.left; margins: 25 }
            width: 100; height: width; radius: width / 2
            color: "white"
            visible: root.tritonState === "Maximized"
            RectangularGlow {
                anchors.fill: carsBtn
                glowRadius: 100
                spread: 0
                color: "#ffffff"
                cornerRadius: carsBtn.radius
            }
            Text {
                anchors.centerIn: parent
                text: "Show Cars"
            }
            property bool showCars: false
            MouseArea {
                anchors.fill: parent
                onClicked: carsBtn.showCars = !carsBtn.showCars
            }
        }

        Rectangle {
            id: treeDBtn
            anchors { top: carsBtn.bottom; left: parent.left; margins: 25 }
            width: 100; height: width; radius: width / 2
            color: "white"
            visible: root.tritonState === "Maximized"
            RectangularGlow {
                anchors.fill: treeDBtn
                glowRadius: 100
                spread: 0
                color: "#ffffff"
                cornerRadius: treeDBtn.radius
            }
            Text {
                anchors.centerIn: parent
                text: "3D"
            }
            property bool show3D: false
            MouseArea {
                anchors.fill: parent
                onClicked: treeDBtn.show3D = !treeDBtn.show3D
            }
        }

        Rectangle {
            id: splitBtn
            anchors { top: treeDBtn.bottom; left: parent.left; margins: 25 }
            width: 100; height: width; radius: width / 2
            color: "white"
            visible: root.tritonState === "Maximized"
            RectangularGlow {
                anchors.fill: splitBtn
                glowRadius: 100
                spread: 0
                color: "#ffffff"
                cornerRadius: splitBtn.radius
            }
            Text {
                anchors.centerIn: parent
                text: splitBtn.splitMaps ? "Unsplit" : "Split"
            }
            property bool splitMaps: false
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    splitBtn.splitMaps = !splitBtn.splitMaps
                }
            }
        }

        Item {
            id: guidanceInfo
            width: root.exposedRect.width / 3
            height: root.exposedRect.height
            LinearGradient {
                anchors.fill: parent
                start: Qt.point(0, 0)
                end: Qt.point(parent.width, 0)
                gradient: Gradient {
                    GradientStop { position: 0.9; color: "white" }
                    GradientStop { position: 1.0; color: "transparent" }
                }
            }
            visible: searchBtn.showGuidance
            Image {
                id: largePic
                anchors { top: parent.top; left: parent.left; margins: 100 }
                source: "assets/turn-right-big.png"
                Text {
                    anchors {
                        top: parent.bottom
                        topMargin: 25
                        horizontalCenter: parent.center
                    }
                    text: "Right 1000 m"
                }
            }
            Image {
                id: smallPics
                anchors { top: largePic.bottom; left: parent.left; margins: 100 }
                source: "assets/turn-left.png"
                Text {
                    anchors {
                        top: parent.bottom
                        topMargin: 25
                        horizontalCenter: parent.center
                    }
                    text: "Left 100 m"
                }
            }
            MouseArea {
                anchors.fill: parent
                onClicked: searchBtn.showGuidance = false
            }
        }

        Item {
            id: searchPanel
            width: root.exposedRect.width; height: root.exposedRect.height / 3
            LinearGradient {
                anchors.fill: parent
                start: Qt.point(0, 0)
                end: Qt.point(0, parent.height)
                gradient: Gradient {
                    GradientStop { position: 0.9; color: "white" }
                    GradientStop { position: 1.0; color: "transparent" }
                }
            }
            Item {
                width: parent.width / 2; height: parent.height / 2
                anchors { top: parent.top; left: parent.left; margins: 10 }
                Text {
                    anchors.centerIn: parent
                    text: "Where do you go today"
                }
            }
            Rectangle {
                width: parent.width / 2; height: parent.height / 2
                radius: width /2
                color: "lightgray"
                anchors { top: parent.top; right: parent.right; margins: 10 }
                Text {
                    anchors.centerIn: parent
                    text: "Search"
                }
            }
            visible: "Widget2Rows" === root.tritonState || "Widget3Rows" === root.tritonState
            Item {
                width: parent.width / 2; height: parent.height / 2
                anchors { bottom: parent.bottom; left: parent.left; margins: 5 }
                visible: "Widget3Rows" === root.tritonState
                Text {
                    anchors.centerIn: parent
                    text: "Home"
                }
            }
            Item {
                width: parent.width / 2; height: parent.height / 2
                anchors {
                    bottom: parent.bottom; right: parent.right; margins: 5 }
                visible: "Widget3Rows" === root.tritonState
                Text {
                    anchors.centerIn: parent
                    text: "Work"
                }
            }
        }
    }

    property var secondaryWindow: ApplicationManagerWindow {
        id: secondaryWindow
        Image {
            anchors.fill: parent
            source: "assets/navigation-widget-map.png"
            fillMode: Image.PreserveAspectCrop
        }
        Component.onCompleted: {
            secondaryWindow.setWindowProperty("windowType", "secondary")
            secondaryWindow.visible = true
        }
    }
}
