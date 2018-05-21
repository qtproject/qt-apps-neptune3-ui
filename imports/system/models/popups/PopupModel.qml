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

/*!
    \qmltype PopupModel
    \inqmlmodule models.popups
    \inherits QtQbject
    \since 5.11
    \brief A model used to handle Neptune3 UI application popups.

    The PopupModel holds a list with all application popups in Neptune3 UI which is also managing.
    It is in other words a popup manager taking care of showing and dismissing popups.
*/

import QtQuick 2.9
import QtQml 2.2

QtObject {
    id: root

    /*!
        \qmlproperty var PopupModel::applicationModel

        This property holds Neptune3 UI's application model.

    */
    property var applicationModel

    /*!
        \qmlproperty var PopupModel::popupLoader

        This property holds the PopupItemLoader, instantiated in SystemUI and
        responsible for loading the applications popups.

    */
    property var popupLoader

    //internal, an instance of the application model and connection to appInfo
    readonly property var connx: Instantiator {
        id: inst
        model: root.applicationModel
        delegate: QtObject {
            property var con: Connections {
                target: model.appInfo
                onPopupWindowChanged: {
                    //register all popups in the popup windows list, storing
                    //the application's appInfo in which those are instantiated
                    if (model.appInfo.popupWindow) {
                        var appInList = false;
                        for (var i = 0; i < popupsListModel.count; i++) {
                            if (popupsListModel.get(i).appInfo.id === model.appInfo.id) {
                                appInList = true;
                                break;
                            }
                        }
                        if (!appInList) {
                            popupsListModel.append({"appInfo" : model.appInfo});
                        }
                    } else {
                        popupsListModel.removeWithAppId(model.appInfo.id);
                    }
                }

                onOpenPopupChanged: {
                    //handle here all openPopup requests
                    if (model.appInfo.openPopup) {
                        //set originItem coordinates
                        popupLoader.originItemX = model.appInfo.originItemX;
                        popupLoader.originItemY = model.appInfo.originItemY;

                        //activate loader and open popup
                        popupLoader.open();

                        //set ApplicationPopup's appInfo property
                        popupLoader.item.appInfo = model.appInfo;

                        //set initial dimensions
                        popupLoader.item.popupWindowWidth = model.appInfo.popupWidth;
                        popupLoader.item.popupWindowHeight = model.appInfo.popupHeight;

                        //set popup window properties
                        model.appInfo.popupWindow.parent = popupLoader.item;
                        model.appInfo.popupWindow.anchors.fill = popupLoader.item;
                        model.appInfo.popupWindow.visible = true;
                    } else {
                        //close popup in case where explicitily requested
                        //from another than the close button press action
                        popupLoader.item.close();

                        //reset popupWindow's parent and loader
                        model.appInfo.popupWindow.parent = null;
                        popupLoader.active = false;
                    }
                }
            }
        }
    }

    /*!
        \qmlproperty var PopupModel::popupsListModel

        The list model holding all Neptune3 UI popups.

    */
    property var popupsListModel: ListModel {
        function removeWithAppId(appId) {
            var i;
            for (i = 0; i < count; i++) {
                var item = get(i);
                if (item.appInfo.id === appId) {
                    remove(i, 1);
                    break;
                }
            }
        }
    }
}
