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

import QtQuick 2.8
import shared.utils 1.0

QtObject {
    id: root

    readonly property var band: {
      "AMBand": 0,
      "FMBand": 1
    }

    property int currentBand: root.band.FMBand
    onCurrentBandChanged: {
        if (root.currentBand === root.band.FMBand) {
            root.currentFrequency = root.fmMinimumFrequency
        } else {
            root.currentFrequency = root.amMinimumFrequency
        }
    }

    property int currentFrequency: fmMinimumFrequency

    // FM data
    readonly property int fmMinimumFrequency: 86700000
    readonly property int fmMaximumFrequency: 122100000
    readonly property int fmStepSize: 100000

    // AM data
    readonly property int amMinimumFrequency: 535000
    readonly property int amMaximumFrequency: 1700000
    readonly property int amStepSize: 10000


    function stepBackward() {
        if (root.currentBand === root.band.FMBand) {
            if (root.currentFrequency - root.fmStepSize < root.fmMinimumFrequency) {
                root.currentFrequency = root.fmMaximumFrequency;
            } else {
                root.currentFrequency -= root.fmStepSize;
            }
        } else {
            if (root.currentFrequency - root.amStepSize < root.amMinimumFrequency) {
                root.currentFrequency = root.amMaximumFrequency;
            } else {
                root.currentFrequency -= root.amStepSize;
            }
        }
    }

    function stepForward() {
        if (root.currentBand === root.band.FMBand) {
            if (root.currentFrequency + root.fmStepSize > root.fmMinimumFrequency) {
                root.currentFrequency = root.fmMinimumFrequency;
            } else {
                root.currentFrequency += root.fmStepSize;
            }
        } else {
            if (root.currentFrequency + root.amStepSize > root.amMinimumFrequency) {
                root.currentFrequency = root.amMinimumFrequency;
            } else {
                root.currentFrequency += root.amStepSize;
            }
        }
    }

    function setFrequency(freq) {
        root.currentFrequency = freq;
    }
}
