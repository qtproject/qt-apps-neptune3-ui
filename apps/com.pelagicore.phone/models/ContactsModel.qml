/****************************************************************************
**
** Copyright (C) 2017 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Neptune IVI UI.
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
// template
//    ListElement { handle: ""; firstName: ""; surname: ""; favorite: false; phoneNumbers: [
//            ListElement { name: ""; number: "" }
//        ]
//    }
    id: model

    function findPerson(handle) {
        for (var i = 0; i < model.count; i++) {
            var item = model.get(i);
            if (item.handle === handle) {
                return item;
            }
        }
    }

    ListElement { handle: "aharvester"; firstName: "Adam"; surname: "Harvester"; favorite: true; phoneNumbers: [
            ListElement { name: "mobile"; number: "(251) 546-9442" }
        ]
    }
    ListElement { handle: "jsmith"; firstName: "Jody"; surname: "Smith"; favorite: true; phoneNumbers: [
            ListElement { name: "mobile"; number: "(972) 848-4399" }
        ]
    }
    ListElement { handle: "hcarter"; firstName: "Howard"; surname: "Carter"; favorite: false; phoneNumbers: [
            ListElement { name: "home"; number: "(833) 568-4381" }
        ]
    }
    ListElement { handle: "dalleson"; firstName: "David"; surname: "Alleson"; favorite: true; phoneNumbers: [
            ListElement { name: "company"; number: "(438) 648-9964" }
        ]
    }
    ListElement { handle: "cmcgilbert"; firstName: "Christine"; surname: "McGilbert"; favorite: true; phoneNumbers: [
            ListElement { name: "home"; number: "(326) 800-8911" }
        ]
    }
    ListElement { handle: "jbrown"; firstName: "Jacob"; surname: "Brown"; favorite: false; phoneNumbers: [
            ListElement { name: "mobile"; number: "(141) 801-7764" }
        ]
    }
    ListElement { handle: "ejackson"; firstName: "Edward"; surname: "Jackson"; favorite: true; phoneNumbers: [
            ListElement { name: "mobile"; number: "(221) 780-7704" }
        ]
    }
    ListElement { handle: "bhummels"; firstName: "Berndt"; surname: "Hummels"; favorite: false; phoneNumbers: [
            ListElement { name: "company"; number: "(669) 189-3693" }
        ]
    }
}
