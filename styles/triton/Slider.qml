/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Copyright (C) 2018 Pelagicore AB
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

import utils 1.0
import com.pelagicore.styles.triton 1.0

T.Slider {
    id: control

    implicitWidth: Math.max(background ? background.implicitWidth : 0,
                           (handle ? handle.implicitWidth : 0) + leftPadding + rightPadding)
    implicitHeight: Math.max(background ? background.implicitHeight : 0,
                            (handle ? handle.implicitHeight : 0) + topPadding + bottomPadding)

    padding: 6

    readonly property int count: stepSize != 0 ? (to-from)/stepSize : 0.5

    handle: Image {
        id: handleItem
        x: control.leftPadding + (control.availableWidth - width) / 2
        y: control.topPadding + (control.visualPosition * (control.availableHeight - height))
        source: Style.gfx2("vertical-slider-handle", TritonStyle.theme)
    }

    background: Column {
        id: rulerNumbers
        anchors.top: parent.top
        anchors.topMargin: handleItem.height/2
        anchors.bottom: parent.bottom
        anchors.bottomMargin: handleItem.height/2
        anchors.horizontalCenter: parent.horizontalCenter

        width: Style.hspan(30/45)
        spacing: Style.vspan(3/80)

        Repeater {
            model: control.count
            delegate: Rectangle {
                id: rect
                width: parent.width
                height: rulerNumbers.height/control.count - rulerNumbers.spacing
                color: TritonStyle.contrastColor
                opacity: (handleItem.y-handleItem.height/2) > rect.y ? 0.1 : 0.6
            }
        }
    }
}
