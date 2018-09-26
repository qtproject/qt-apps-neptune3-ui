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

neptune_UI_Center_Console = {"title": "Neptune 3 UI - Center Console", "type": "QQuickWindowQmlImpl", "unnamed": 1, "visible": True}
neptune_UI_Center_Console_grid_GridView = {"container": neptune_UI_Center_Console, "id": "grid", "type": "GridView", "unnamed": 1, "visible": True}
neptune_UI_Center_Console_instrumentClusterWindowLoader_Loader = {"container": neptune_UI_Center_Console, "id": "instrumentClusterWindowLoader", "type": "Loader", "unnamed": 1, "visible": True}
neptune_UI_Center_Console_leftIcon_ToolButton = {"checkable": False, "container": neptune_UI_Center_Console, "id": "leftIcon", "type": "ToolButton", "unnamed": 1, "visible": True}
neptune_UI_Center_Console_leftTempSlider_TemperatureSlider = {"container": neptune_UI_Center_Console, "id": "leftTempSlider", "type": "TemperatureSlider", "unnamed": 1, "visible": True}
neptune_UI_Center_Console_rightTempSlider_TemperatureSlider = {"container": neptune_UI_Center_Console, "id": "rightTempSlider", "type": "TemperatureSlider", "unnamed": 1, "visible": True}
o_QVariant = {"type": "QVariant"}
neptune_UI_Instrument_Cluster_QQuickWindowQmlImpl = {"title": "Neptune 3 UI - Instrument Cluster", "type": "QQuickWindowQmlImpl", "unnamed": 1, "visible": True, "window": o_QVariant}
grid_Item = {"container": neptune_UI_Center_Console_grid_GridView, "type": "Item", "unnamed": 1, "visible": True}
neptune_UI_Center_Console_rightTempSlider_TemperatureSlider_2 = {"container": ":Neptune UI - Center Console_QQuickWindowQmlImpl", "id": "rightTempSlider", "type": "TemperatureSlider", "unnamed": 1, "visible": True}
neptune_UI_Center_Console_widgetListview_ListView = {"container": neptune_UI_Center_Console, "id": "widgetListview", "type": "ListView", "unnamed": 1, "visible": True}
widgetListview_Maps_ListItem = {"checkable": False, "container": neptune_UI_Center_Console_widgetListview_ListView, "text": "Maps", "type": "ListItem", "unnamed": 1, "visible": True}
maps_Maps_Label = {"container": widgetListview_Maps_ListItem, "text": "Maps", "type": "Label", "unnamed": 1, "visible": True}
neptune_UI_Center_Console_appWidget_ApplicationWidget = {"container": neptune_UI_Center_Console, "id": "appWidget", "type": "ApplicationWidget", "unnamed": 1, "visible": True}
neptune_UI_Center_Console_grid_GridView_2 = {"container": ":Neptune UI - Center Console_QQuickWindowQmlImpl", "id": "grid", "type": "GridView", "unnamed": 1, "visible": True}
grid_delegateRoot_MouseArea = {"container": neptune_UI_Center_Console_grid_GridView_2, "id": "delegateRoot", "index": 0, "type": "MouseArea", "unnamed": 1, "visible": True}
neptune_UI_Center_Console_root_AddWidgetPopup = {"container": neptune_UI_Center_Console, "id": "root", "type": "AddWidgetPopup", "unnamed": 1, "visible": True}
neptune_UI_Center_Console_homeButton_ToolButton = {"checkable": True, "container": neptune_UI_Center_Console, "id": "homeButton", "type": "ToolButton", "unnamed": 1, "visible": True}
neptune_UI_Center_Console_root_PrimaryWindow = {"container": neptune_UI_Center_Console, "id": "root", "type": "PrimaryWindow", "unnamed": 1, "visible": True}
neptune_UI_Center_Console_squish_on_toolbutton_ToolButton = {"container": neptune_UI_Center_Console, "id": "squish_close_button", "objectName": "squish_on_toolbutton", "type": "ToolButton", "visible": True}
neptune_3_UI_Center_Console_squish_volumePopupButton_ToolButton = {"container": neptune_UI_Center_Console, "objectName": "squish_volumePopupButton", "type": "ToolButton", "visible": True}
neptune_3_UI_Center_Console_squish_volumePopupItem_VolumePopup = {"container": neptune_UI_Center_Console, "objectName": "squish_volumePopupItem", "type": "VolumePopup", "visible": True}
neptune_3_UI_Center_Console_squish_popupClose_ToolButton = {"checkable": False, "container": neptune_UI_Center_Console, "objectName": "squish_popupClose", "type": "ToolButton", "visible": True}
neptune_3_UI_Center_Console_squish_volumeSlider_Slider = {"container": neptune_UI_Center_Console, "objectName": "squish_volumeSlider", "type": "Slider", "visible": True}
neptune_3_UI_Center_Console_centerConsole_CenterConsole = {"container": neptune_UI_Center_Console, "id": "centerConsole", "type": "CenterConsole", "visible": True}
neptune_3_UI_Center_Console_squish_addWidgetButton_ToolButton = {"checkable": False, "container": neptune_UI_Center_Console, "objectName": "squish_addWidgetButton", "type": "ToolButton", "visible": True}
neptune_3_UI_Center_Console_squish_addWidgetPopupItem_AddWidgetPopup = {"container": neptune_UI_Center_Console, "objectName": "squish_addWidgetPopupItem", "type": "AddWidgetPopup", "visible": True}
widgetList_AddWidgets_Maps = {"checkable": False, "container": neptune_UI_Center_Console_widgetListview_ListView, "objectName": "squish_itemAddWidget_com.pelagicore.map", "text": "Maps", "type": "ListItem", "visible": True}
neptune_3_UI_Center_Console_squish_homeWidget_Maps_Column = {"container": neptune_UI_Center_Console, "objectName": "squish_homeWidget_com.pelagicore.map", "type": "Column", "visible": True}
good_appMainMenu_WidgetClose_Map_MouseArea = {"container": neptune_UI_Center_Console, "objectName": "squish_appWidgetClose_com.pelagicore.map", "type": "MouseArea", "visible": True}
maps_Maps_Label_2 = {"container": widgetList_AddWidgets_Maps, "text": "Maps", "type": "Label", "unnamed": 1, "visible": True}
neptune_3_UI_Center_Console_squish_launcherCenterConsole_Launcher = {"container": neptune_UI_Center_Console, "objectName": "squish_launcher", "type": "Launcher", "visible": True}
neptune_3_UI_Center_Console_squish_gridButton_ToolButton = {"checkable": True, "container": neptune_UI_Center_Console, "objectName": "squish_gridButton", "type": "ToolButton", "visible": True}
neptune_3_UI_Center_Console_squish_climateBarMouseArea_MouseArea = {"container": neptune_UI_Center_Console, "objectName": "squish_climateBarMouseArea", "type": "MouseArea", "visible": True}
neptune_3_UI_Center_Console_squish_editableLauncher_EditableGridView = {"container": neptune_UI_Center_Console, "objectName": "squish_editableLauncher", "type": "EditableGridView", "visible": True}
