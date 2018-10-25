# -*- coding: utf-8 -*-

############################################################################
##
## Copyright (C) 2018 Luxoft GmbH
## Contact: https://www.qt.io/licensing/
##
## This file is part of the Neptune 3 IVI UI.
##
## $QT_BEGIN_LICENSE:GPL-QTAS$
## Commercial License Usage
## Licensees holding valid commercial Qt Automotive Suite licenses may use
## this file in accordance with the commercial license agreement provided
## with the Software or, alternatively, in accordance with the terms
## contained in a written agreement between you and The Qt Company.  For
## licensing terms and conditions see https://www.qt.io/terms-conditions.
## For further information use the contact form at https://www.qt.io/contact-us.
##
## GNU General Public License Usage
## Alternatively, this file may be used under the terms of the GNU
## General Public License version 3 or (at your option) any later version
## approved by the KDE Free Qt Foundation. The licenses are as published by
## the Free Software Foundation and appearing in the file LICENSE.GPL3
## included in the packaging of this file. Please review the following
## information to ensure the GNU General Public License requirements will
## be met: https://www.gnu.org/licenses/gpl-3.0.html.
##
## $QT_END_LICENSE$
##
## SPDX-License-Identifier: GPL-3.0
##
#############################################################################

from objectmaphelper import *

o_QVariant = {"type": "QVariant"}
neptune_UI_Center_Console = {"title": "Neptune 3 UI - Center Console", "type": "QQuickWindowQmlImpl", "unnamed": 1, "visible": True}
neptune_UI_Center_Console_grid_GridView = {"container": neptune_UI_Center_Console, "id": "grid", "type": "GridView", "unnamed": 1, "visible": True}
neptune_UI_Center_Console_leftTempSlider_TemperatureSlider = {"container": neptune_UI_Center_Console, "id": "leftTempSlider", "type": "TemperatureSlider", "unnamed": 1, "visible": True}
neptune_UI_Center_Console_rightTempSlider_TemperatureSlider = {"container": neptune_UI_Center_Console, "id": "rightTempSlider", "type": "TemperatureSlider", "unnamed": 1, "visible": True}
neptune_UI_Instrument_Cluster_QQuickWindowQmlImpl = {"title": "Neptune 3 UI - Instrument Cluster", "type": "QQuickWindowQmlImpl", "unnamed": 1, "visible": True, "window": o_QVariant}
neptune_UI_Center_Console_widgetListview_ListView = {"container": neptune_UI_Center_Console, "id": "widgetListview", "type": "ListView", "unnamed": 1, "visible": True}
neptune_3_UI_Center_Console_volumePopupButton_ToolButton = {"container": neptune_UI_Center_Console, "objectName": "volumePopupButton", "type": "ToolButton", "visible": True}
neptune_3_UI_Center_Console_volumePopupItem_VolumePopup = {"container": neptune_UI_Center_Console, "objectName": "volumePopupItem", "type": "VolumePopup", "visible": True}
neptune_3_UI_Center_Console_popupClose_ToolButton = {"checkable": False, "container": neptune_UI_Center_Console, "objectName": "popupClose", "type": "ToolButton", "visible": True}
neptune_3_UI_Center_Console_volumeSlider_Slider = {"container": neptune_UI_Center_Console, "objectName": "volumeSlider", "type": "Slider", "visible": True}
neptune_3_UI_Center_Console_centerConsole_CenterConsole = {"container": neptune_UI_Center_Console, "id": "centerConsole", "type": "CenterConsole", "visible": True}
neptune_3_UI_Center_Console_addWidgetButton_ToolButton = {"checkable": False, "container": neptune_UI_Center_Console, "objectName": "addWidgetButton", "type": "ToolButton", "visible": True}
neptune_3_UI_Center_Console_addWidgetPopupItem_AddWidgetPopup = {"container": neptune_UI_Center_Console, "objectName": "addWidgetPopupItem", "type": "AddWidgetPopup", "visible": True}
widgetList_AddWidgets_Maps = {"checkable": False, "container": neptune_UI_Center_Console_widgetListview_ListView, "objectName": "itemAddWidget_com.pelagicore.map", "text": "Maps", "type": "ListItem", "visible": True}
neptune_3_UI_Center_Console_homeWidget_Maps_Column = {"container": neptune_UI_Center_Console, "objectName": "homeWidget_com.pelagicore.map", "type": "Column", "visible": True}
good_appMainMenu_WidgetClose_Map_MouseArea = {"container": neptune_UI_Center_Console, "objectName": "appWidgetClose_com.pelagicore.map", "type": "MouseArea", "visible": True}
neptune_3_UI_Center_Console_launcherCenterConsole_Launcher = {"container": neptune_UI_Center_Console, "objectName": "launcher", "type": "Launcher", "visible": True}
neptune_3_UI_Center_Console_gridButton_ToolButton = {"checkable": True, "container": neptune_UI_Center_Console, "objectName": "gridButton", "type": "ToolButton", "visible": True}
neptune_3_UI_Center_Console_climateBarMouseArea_MouseArea = {"container": neptune_UI_Center_Console, "objectName": "climateBarMouseArea", "type": "MouseArea", "visible": True}
neptune_3_UI_Center_Console_editableLauncher_EditableGridView = {"container": neptune_UI_Center_Console, "objectName": "editableLauncher", "type": "EditableGridView", "visible": True}
