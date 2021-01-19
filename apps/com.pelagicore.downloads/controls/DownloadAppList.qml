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
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.0

import shared.controls 1.0
import shared.utils 1.0
import shared.Sizes 1.0

ListView {
    id: root

    property string appServerUrl
    property string cpuArch
    property var applicationModel
    property real currentInstallationProgress

    signal toolClicked(string appId, string appName, string purchaseId, string iconUrl)
    signal appClicked(string appId)

    function refreshAppsInfo(isPackageInstalledByPackageControllerFunc,
                             isPackageBuiltInFunc, getInstalledPackageSizeTextFunc) {
        d.installedPackagesChanged(isPackageInstalledByPackageControllerFunc,
                                   isPackageBuiltInFunc, getInstalledPackageSizeTextFunc);
    }

    QtObject {
        id: d

        signal installedPackagesChanged(var isPackageInstalledByPackageControllerFunc,
                                        var isPackageBuiltInFunc,
                                        var getInstalledPackageSizeTextFunc)
    }

    model: root.applicationModel
    currentIndex: -1
    delegate: ListItemProgress {
        id: delegatedItem
        objectName: "itemDownloadApp_" + model.id

        property bool isInstalled: model.isInstalled
        property string packageSizeText: model.packageSizeText
        property bool packageBuiltIn: model.packageBuiltIn

        width: Sizes.dp(720); height: Sizes.dp(100)
        icon.source: model.iconUrl
        text: model.name
        subText: model.id
        secondaryText: delegatedItem.isInstalled ? delegatedItem.packageSizeText
                                                 : ( delegatedItem.packageBuiltIn ?
                                                        qsTr("update") : "" )
        cancelSymbol: delegatedItem.isInstalled ? "ic-close" : "ic-download_OFF"
        value: root.currentInstallationProgress
        onValueChanged: {
            if (value === 1.0) {
                root.currentIndex = -1;
            }
        }
        progressVisible: root.currentIndex === index && root.currentInstallationProgress < 1.0
        onProgressCanceled: {
            if (!delegatedItem.isInstalled) {
                root.currentIndex = index;
            }
            root.toolClicked(model.id, model.name, model.purchaseId, model.iconUrl);
        }
        onClicked: root.appClicked(model.id)

        Connections {
            target: d
            function onInstalledPackagesChanged(isPackageInstalledByPackageControllerFunc,
                                                isPackageBuiltInFunc,
                                                getInstalledPackageSizeTextFunc) {
                // functions are passed as parameters to signal
                model.isInstalled = isPackageInstalledByPackageControllerFunc(model.id);
                if (isInstalled) {
                    model.packageBuiltIn = isPackageBuiltInFunc(model.id);
                    model.packageSizeText = getInstalledPackageSizeTextFunc(model.id);
                } else {
                    model.packageBuiltIn = false;
                    model.packageSizeText = "";
                }
            }
        }
    }
}
