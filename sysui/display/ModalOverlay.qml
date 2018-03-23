/****************************************************************************
**
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

import QtQuick 2.10
import QtGraphicalEffects 1.0

import animations 1.0
import com.pelagicore.styles.neptune 3.0

// We can't use Popup from QtQuick.Controls as it doesn't support a rotated scene,
// hence the implementation of our own modal overlay scheme
Item {
    id: root

    // The item to be covered by the overlay
    property Item target

    rotation: target ? target.rotation : 0

    property bool showModalOverlay
    onShowModalOverlayChanged: {
        effectSource.scheduleUpdate();
    }

    signal overlayClicked()

    // TODO: Load only when needed
    MouseArea {
        anchors.fill: parent
        visible: opacity > 0
        opacity: root.showModalOverlay ? 1 : 0
        Behavior on opacity { DefaultNumberAnimation {}  }
        FastBlur {
            anchors.fill: parent
            radius: NeptuneStyle.dp(45)
            source: ShaderEffectSource {
                id: effectSource
                sourceItem: root.target
                live: false
            }
        }
        z: -2
        onClicked: root.overlayClicked()
    }

    Rectangle {
        anchors.fill: parent
        color: "black"
        opacity: root.showModalOverlay ? 0.3 : 0
        Behavior on opacity { DefaultNumberAnimation {}  }
        z: -1
    }
}
