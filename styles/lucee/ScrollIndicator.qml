/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
** Copyright (C) 2018 Pelagicore AG
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
import shared.animations 1.0
import shared.Style 1.0
import shared.Sizes 1.0

T.ScrollIndicator {
    id: control

    implicitWidth: Math.max(background ? background.implicitWidth : 0,
                           leftPadding + rightPadding)
    implicitHeight: Math.max(background ? background.implicitHeight : 0,
                            topPadding + bottomPadding)

    background: Item {
        implicitWidth: Sizes.dp(5)
        implicitHeight: control.height

        Rectangle {
            width: Sizes.dp(5)
            height: parent.height * control.position
            anchors.top: parent.top
            anchors.topMargin: - Sizes.dp(9)
            radius: width / 2
            color: Style.contrastColor
            opacity: control.active ? 0.14 : 0
            Behavior on opacity { DefaultNumberAnimation { duration: opacity < 0.1 ? 80 : 500 } }
            visible: opacity > 0
        }

        Rectangle {
            width: Sizes.dp(5)
            height: ((parent.height - (parent.height * control.size)) - (parent.height * control.position))
            anchors.bottom: parent.bottom
            anchors.bottomMargin: - Sizes.dp(9)
            radius: width / 2
            color: Style.contrastColor
            opacity: control.active ? 0.14 : 0
            Behavior on opacity { DefaultNumberAnimation { duration: opacity < 0.1 ? 80 : 500 } }
            visible: opacity > 0
        }
    }

    contentItem: Rectangle {
        implicitWidth: Sizes.dp(7)
        radius: width / 2
        color: Style.accentColor
        opacity: control.active ? 1.0 : 0.0
        Behavior on opacity { DefaultNumberAnimation { duration: opacity < 0.1 ? 80 : 500 } }
        visible: opacity > 0
    }
}
