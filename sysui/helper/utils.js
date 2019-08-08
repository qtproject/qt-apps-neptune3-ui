/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
** Copyright (C) 2018 Pelagicore AG
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

.pragma library

function orientationFromString(str) {
    str = str.trim().toLowerCase().replace('-','').replace('_','').replace('orientation','')

    if (str === "portrait") {
        return Qt.PortraitOrientation;
    } else if (str === "invertedportrait") {
        return Qt.InvertedPortraitOrientation;
    } else if (str === "landscape") {
        return Qt.LandscapeOrientation;
    } else if (str === "invertedlandscape") {
        return Qt.InvertedLandscapeOrientation;
    } else {
        // default to portrait
        return Qt.PortraitOrientation;
    }
}

function invertOrientation(orientation) {
    switch (orientation) {
        case Qt.PortraitOrientation:
            return Qt.InvertedPortraitOrientation;
        case Qt.InvertedPortraitOrientation:
            return Qt.PortraitOrientation;
        case Qt.LandscapeOrientation:
            return Qt.InvertedLandscapeOrientation;
        case Qt.InvertedLandscapeOrientation:
            return Qt.LandscapeOrientation;
        default:
            return orientation;
    }
}

function rotateDisplay(orientation, isLandscape) {
    if (isLandscape) {
        switch (orientation) {
            case Qt.PortraitOrientation:
                return 90;
            case Qt.LandscapeOrientation:
                return 0;
            case Qt.InvertedPortraitOrientation:
                return -90;
            case Qt.InvertedLandscapeOrientation:
                return 180;
            default:
                return 0;
        }
    } else {
        switch (orientation) {
            case Qt.PortraitOrientation:
                return 0;
            case Qt.LandscapeOrientation:
                return -90;
            case Qt.InvertedPortraitOrientation:
                return 180;
            case Qt.InvertedLandscapeOrientation:
                return 90;
            default:
                return 0;
        }
    }
}
