# -*- coding: utf-8 -*-

############################################################################
##
## Copyright (C) 2019 Luxoft Sweden AB
## Copyright (C) 2018 Pelagicore AG
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
neptune_UI_Instrument_Cluster_QQuickWindowQmlImpl = {"title": "Neptune 3 UI - Instrument Cluster", "type": "QQuickWindowQmlImpl", "unnamed": 1, "visible": True, "window": o_QVariant}
grid_Item = {"container": neptune_UI_Center_Console_grid_GridView, "type": "Item", "unnamed": 1, "visible": True}
neptune_UI_Center_Console_widgetListview_ListView = {"container": neptune_UI_Center_Console, "id": "widgetListview", "type": "ListView", "unnamed": 1, "visible": True}
neptune_3_UI_Center_Console_volumePopupButton_ToolButton = {"container": neptune_UI_Center_Console, "objectName": "volumePopupButton", "type": "ToolButton", "visible": True}
neptune_3_UI_Center_Console_volumePopupItem_VolumePopup = {"container": neptune_UI_Center_Console, "objectName": "volumePopupItem", "type": "VolumePopup", "visible": True}
neptune_3_UI_Center_Console_popupClose_ToolButton = {"checkable": False, "container": neptune_UI_Center_Console, "objectName": "popupClose", "type": "ToolButton", "visible": True}
neptune_3_UI_Center_Console_volumeSlider_Slider = {"container": neptune_UI_Center_Console, "objectName": "volumeSlider", "type": "Slider", "visible": True}
neptune_3_UI_Center_Console_centerConsole_CenterConsole = {"container": neptune_UI_Center_Console, "id": "centerConsole", "type": "AbstractCenterConsole", "visible": True}
neptune_3_UI_Center_Console_addWidgetButton_ToolButton = {"checkable": False, "container": neptune_UI_Center_Console, "objectName": "addWidgetButton", "type": "ToolButton", "visible": True}
neptune_3_UI_Center_Console_addWidgetPopupItem_AddWidgetPopup = {"container": neptune_UI_Center_Console, "objectName": "addWidgetPopupItem", "type": "AddWidgetPopup", "visible": True}
widgetList_AddWidgets_Maps = {"checkable": False, "container": neptune_UI_Center_Console_widgetListview_ListView, "objectName": "itemAddWidget_com.pelagicore.map", "text": "Maps", "type": "ListItem", "visible": True}
neptune_3_UI_Center_Console_launcherCenterConsole_Launcher = {"container": neptune_UI_Center_Console, "objectName": "launcher", "type": "Launcher", "visible": True}
neptune_3_UI_Center_Console_gridButton_ToolButton = {"checkable": True, "container": neptune_UI_Center_Console, "objectName": "gridButton", "type": "ToolButton", "visible": True}
neptune_3_UI_Center_Console_editableLauncher_EditableGridView = {"container": neptune_UI_Center_Console, "objectName": "editableLauncher", "type": "EditableGridView", "visible": True}
neptune_3_UI_Center_Console_activeApplicationSlot_Item = {"container": neptune_UI_Center_Console, "objectName": "activeApplicationSlot", "type": "Item", "visible": True}

neptune_3_UI_Instrument_Cluster_QQuickWindowQmlImpl = {"title": "Neptune 3 UI - Instrument Cluster", "type": "QQuickWindowQmlImpl", "unnamed": 1, "visible": True}
o_QtAM_ApplicationManagerWindow = {"type": "QtAM::ApplicationManagerWindow", "unnamed": 1, "visible": True}
climateAreaMouseArea_MouseArea = {"container": o_QtAM_ApplicationManagerWindow, "objectName": "climateAreaMouseArea", "type": "MouseArea", "visible": True}
leftTempSlider_TemperatureSlider = {"container": o_QtAM_ApplicationManagerWindow, "objectName": "leftTempSlider", "type": "TemperatureSlider", "visible": True}
rightTempSlider_TemperatureSlider = {"container": o_QtAM_ApplicationManagerWindow, "objectName": "rightTempSlider", "type": "TemperatureSlider", "visible": True}
o_ClimateView = {"container": o_QtAM_ApplicationManagerWindow, "type": "ClimateView", "unnamed": 1, "visible": True}
o_QtAM_ApplicationManagerWindow_2 = {"type": "QtAM::ApplicationManagerWindow", "unnamed": 1, "visible": False}
auto_Button = {"checkable": True, "container": o_QtAM_ApplicationManagerWindow_2, "id": "bigFatButton", "text": "Auto", "type": "Button", "unnamed": 1, "visible": True}
neptune_3_UI_Center_Console_widgetGrid_homepage_WidgetGrid = {"container": neptune_UI_Center_Console, "objectName": "widgetGrid_homepage", "type": "WidgetGrid", "visible": True}
events_ToolButton = {"checkable": True, "container": o_QtAM_ApplicationManagerWindow, "objectName": "eventsViewButton", "text": "events", "type": "ToolButton", "visible": True}
year_ToolButton = {"checkable": True, "container": o_QtAM_ApplicationManagerWindow, "objectName": "yearViewButton", "text": "year", "type": "ToolButton", "visible": True}
next_ToolButton = {"checkable": True, "container": o_QtAM_ApplicationManagerWindow, "objectName": "nextViewButton", "text": "next", "type": "ToolButton", "visible": True}
