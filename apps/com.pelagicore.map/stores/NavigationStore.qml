/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Neptune 3 UI.
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

import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtLocation 5.9
import QtPositioning 5.9
import shared.animations 1.0
import shared.com.pelagicore.drivedata 1.0

/// class that takes route segments, prepares demo from it, and produces
/// points and vehicle(arrow marker / map bearing) angle
QtObject {
    id: root

    readonly property NavigationState naviState: NavigationState {
        id: naviState
        mapBearing: root.mapBearing
        mapZoomLevel: root.mapZoomLevel
        mapTilt: root.mapTilt
        mapCenter: root.mapCenter
        onIsInitializedChanged: {
            naviState.nextTurn = "";
            naviState.nextTurnDistanceMeasuredIn = "";
            naviState.nextTurnDistance = 0;
        }
    }

    // input properties
    property var model
    property bool active

    property var mapCenter
    property real mapZoomLevel
    property real mapTilt
    property real mapBearing

    // output properties
    property var location: QtPositioning.coordinate()
    property real angle: 0.0
    property string naviGuideDirection: ""
    onNaviGuideDirectionChanged: {
        naviState.nextTurn = naviGuideDirection;
    }

    // in meters
    property real naviGuideDistance: 0.0
    onNaviGuideDistanceChanged: {
        var d = naviGuideDistance;
        if (d >= 1000) {
            d = d / 1000 + 0.1;
            root.nextTurnDistanceMeasuredIn = qsTr("km");
            root.nextTurnDistance = d.toFixed(1);
        } else {
            if (d < 100) {
                d = d - d % 10 + 10;
            } else {
                d = d - d % 50 + 50;
            }

            root.nextTurnDistanceMeasuredIn = qsTr("m");
            root.nextTurnDistance = d;
        }
    }

    property string nextTurnDistanceMeasuredIn: ""
    onNextTurnDistanceMeasuredInChanged: {
        naviState.nextTurnDistanceMeasuredIn = root.nextTurnDistanceMeasuredIn;
    }
    property real nextTurnDistance: 0
    onNextTurnDistanceChanged: {
        naviState.nextTurnDistance = root.nextTurnDistance;
    }

    property real remainingDistance: 0.0

    // in seconds
    property int  remainingTime: 0.0

    property var maneuverPoint: QtPositioning.coordinate()

    // inner properties
    property var segmentsList
    property int segmentsListCurrentIdx: 0

    property var path
    property int pathCurrentPointIdx: 0

    property var currentSegment
    property int currentSegment_PathCurrentPointIdx: 0

    property var maneuversPointsList
    property var maneuversDirectionList
    property int maneuverIdx

    // m/s ~ 75km/h
    readonly property real speed: 20.8

    onActiveChanged: {
        if (active) {
            if (root.model.status !== RouteModel.Ready
                    || root.model.count <= 0) {
                return;
            }

            var route = root.model.get(0);
            remainingDistance = route.distance;
            remainingTime = route.travelTime;
            pathCurrentPointIdx = 0;
            currentSegment_PathCurrentPointIdx = 0;
            segmentsListCurrentIdx = 0;
            segmentsList = route.segments;
            currentSegment = route.segments[0];
            path = route.path;

            root.location = currentSegment.path[0];
            root.angle = path[0].azimuthTo(path[1]);

            maneuverIdx = 1;
            maneuversPointsList = [];
            maneuversDirectionList = [];
            for (var i = 0; i < segmentsList.length; ++i) {
                maneuversPointsList.push(segmentsList[i].maneuver.position);
                maneuversDirectionList.push(segmentsList[i].maneuver.direction)
            }

            maneuverPoint = maneuversPointsList[maneuverIdx];
            naviGuideDistance = calculateDistanceToNext(0, maneuverPoint);
            setNaviGuideDirectionFromManeuverDiredection(maneuversDirectionList[maneuverIdx]);


            var rawPoints = [];
            for (var i = 0; i < path.length; ++i) {
                rawPoints.push([path[i].latitude, path[i].longitude]);
            }

            naviState.routePoints = rawPoints;

            setNextAnimation();
        } else if (movementAnimation.running) {
            movementAnimation.stop()
            // reset the states
            naviState.routePoints = [];
            naviGuideDirection = "";
            nextTurnDistanceMeasuredIn = "";
            nextTurnDistance = 0;
        }
    }

    function calculateDistanceToNext(curPathIdx, maneuverPoint) {
        var j = curPathIdx;
        var calculatedDistance = 0.0;
        while (path[j] !== maneuverPoint && j+1 < path.length) {
            calculatedDistance += path[j].distanceTo(path[j+1]);
            ++j;
        }

        return calculatedDistance;
    }

    function setNaviGuideDirectionFromManeuverDiredection(direction) {
        switch (direction) {
        case RouteManeuver.NoDirection:
            naviGuideDirection = "nav_nodir";
            break;
        case RouteManeuver.DirectionForward:
            naviGuideDirection = "nav_straight";
            break;
        case RouteManeuver.DirectionBearRight:
            naviGuideDirection = "nav_bear_r";
            break;
        case RouteManeuver.DirectionLightRight:
            naviGuideDirection = "nav_light_right";
            break;
        case RouteManeuver.DirectionRight:
            naviGuideDirection = "nav_right";
            break;
        case RouteManeuver.DirectionHardRight:
            naviGuideDirection = "nav_hard_r";
            break;
        case RouteManeuver.DirectionUTurnRight:
            naviGuideDirection = "nav_uturn_r";
            break;
        case RouteManeuver.DirectionUTurnLeft:
            naviGuideDirection = "nav_uturn_l";
            break;
        case RouteManeuver.DirectionHardLeft:
            naviGuideDirection = "nav_hard_l";
            break;
        case RouteManeuver.DirectionLeft:
            naviGuideDirection = "nav_left";
            break;
        case RouteManeuver.DirectionLightLeft:
            naviGuideDirection = "nav_light_left";
            break;
        case RouteManeuver.DirectionBearLeft:
            naviGuideDirection = "nav_bear_l";
            break;
        default:
            naviGuideDirection = "";
            break;
        }
    }

    function updateNaviGuide() {
        if (maneuverIdx + 1 >= maneuversPointsList.length) return;
        maneuverPoint = maneuversPointsList[++maneuverIdx];
        naviGuideDistance = calculateDistanceToNext(pathCurrentPointIdx-1, maneuverPoint);
        setNaviGuideDirectionFromManeuverDiredection(maneuversDirectionList[maneuverIdx]);
    }

    function setNextAnimation() {
        if (!root.active) {
            return;
        }

        // suppose that it is equal to path[pathIdx]
        var startPos = path[pathCurrentPointIdx];
        var endPos = path[++pathCurrentPointIdx];

        if (!endPos) {
            // arrived;
            naviGuideDistance  = 0.0;
            naviState.routePoints = [];
            naviGuideDirection = "";
            nextTurnDistanceMeasuredIn = "";
            return;
        }

        if (maneuverPoint === startPos) {
            updateNaviGuide();
        }

        // segment, path inside it
        if (++currentSegment_PathCurrentPointIdx >= currentSegment.path.length) {
            currentSegment_PathCurrentPointIdx = 0;
            remainingTime     -= currentSegment.travelTime;
            remainingDistance -= currentSegment.distance;
            currentSegment     = segmentsList[++segmentsListCurrentIdx];
        }

        // Calculate new direction
        var oldDir = root.angle;
        var newDir = startPos.azimuthTo(endPos);

        // Calculate the duration of the animation
        var azimuthDelta = Math.max(oldDir, newDir) - Math.min(oldDir, newDir);
        var azimuthDeltaShifted = azimuthDelta < 180.0 ? azimuthDelta: azimuthDelta - 180.0;
        movementAnimation.azimuthDt = azimuthDeltaShifted;

        if (azimuthDeltaShifted < 20)
            movementAnimation.rotationDuration = 500;
        else if (azimuthDeltaShifted < 45)
            movementAnimation.rotationDuration = 1000;
        else if (azimuthDeltaShifted < 90)
            movementAnimation.rotationDuration = 2000;
        else if (azimuthDeltaShifted < 135)
            movementAnimation.rotationDuration = 2500;
        else
            movementAnimation.rotationDuration = 3000;

        var pathDistance = startPos.distanceTo(endPos);

        // uniform motion :(
        movementAnimation.coordinateDuration = pathDistance / speed * 1000;
        movementAnimation.rotationDirection = newDir;
        movementAnimation.targetCoordinate = endPos;
        movementAnimation.distanceForNextManeuver = root.naviGuideDistance - pathDistance;
        movementAnimation.distanceForNextManeuver = movementAnimation.distanceForNextManeuver > 0
                ? movementAnimation.distanceForNextManeuver
                : 0.0;
        movementAnimation.start();
    }

    readonly property SequentialAnimation movementAnimation: SequentialAnimation{
        id: movementAnimation
        property real rotationDuration: 0
        property real rotationDirection: 0
        property real coordinateDuration: 0
        property real distanceForNextManeuver: 0
        property var targetCoordinate: QtPositioning.coordinate()
        property real azimuthDt: 0
        readonly property real angleThreshold: 25.0

        readonly property bool rotateInMotion: {
            azimuthDt <= angleThreshold;
        }
        readonly property bool rotateInPlace: {
            azimuthDt > angleThreshold;
        }

        SequentialAnimation {
            RotationAnimation {
                target: movementAnimation.rotateInPlace ? root : null
                property: movementAnimation.rotateInPlace ? "angle" : ""
                duration: movementAnimation.rotateInPlace
                          ? movementAnimation.rotationDuration
                          : 0
                to: movementAnimation.rotationDirection
                direction: RotationAnimation.Shortest
            }

            ParallelAnimation {
                RotationAnimation {
                    target: movementAnimation.rotateInMotion ? root : null
                    property: movementAnimation.rotateInMotion ? "angle" : ""
                    duration: movementAnimation.rotateInMotion
                              ? movementAnimation.rotationDuration
                              : 0
                    to: movementAnimation.rotationDirection
                    direction: RotationAnimation.Shortest
                }

                CoordinateAnimation {
                    target: root
                    property: "location"
                    duration: movementAnimation.coordinateDuration
                    to: movementAnimation.targetCoordinate
                }

                NumberAnimation {
                    target: root
                    property: "naviGuideDistance"
                    duration: movementAnimation.coordinateDuration
                    to: movementAnimation.distanceForNextManeuver
                }
            }
        }

        onStopped: setNextAnimation()
    }
}
