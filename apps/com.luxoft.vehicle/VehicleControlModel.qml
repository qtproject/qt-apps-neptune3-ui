/****************************************************************************
**
** Copyright (C) 2017 Pelagicore AB
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
pragma Singleton

import QtQuick 2.8

ListModel {
    ListElement { name: QT_TR_NOOP("Fees"); active: false; icon: "fees@48.png" }
    ListElement { name: QT_TR_NOOP("Hill Descent Control"); active: true; icon: "hill_descent_control@48.png" }
    ListElement { name: QT_TR_NOOP("Traffic Jam Assist"); active: false; icon: "traffic_jam_assist@48.png" }
    ListElement { name: QT_TR_NOOP("Intelligent speed adaptation"); active: false; icon: "intelligent_speed_adaptation@48.png" }
    ListElement { name: QT_TR_NOOP("Fees"); active: true; icon: "fees@48.png" }
    ListElement { name: QT_TR_NOOP("Hill Descent Control"); active: false; icon: "hill_descent_control@48.png" }
    ListElement { name: QT_TR_NOOP("Traffic Jam Assist"); active: false; icon: "traffic_jam_assist@48.png" }
    ListElement { name: QT_TR_NOOP("Intelligent speed adaptation"); active: true; icon: "intelligent_speed_adaptation@48.png" }
    ListElement { name: QT_TR_NOOP("Fees"); active: false; icon: "fees@48.png" }
    ListElement { name: QT_TR_NOOP("Hill Descent Control"); active: false; icon: "hill_descent_control@48.png" }
    ListElement { name: QT_TR_NOOP("Traffic Jam Assist"); active: false; icon: "traffic_jam_assist@48.png" }
    ListElement { name: QT_TR_NOOP("Intelligent speed adaptation"); active: false; icon: "intelligent_speed_adaptation@48.png" }
}