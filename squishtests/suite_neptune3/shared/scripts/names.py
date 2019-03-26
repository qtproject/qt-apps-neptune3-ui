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
import referencer

# stores all containers
apps_reference_container = {}


def container_setter(val, identifier):
    apps_reference_container[identifier].clear()
    apps_reference_container[identifier].update(val)


def container_getter(identifier):
    return apps_reference_container[identifier]


o_QVariant = {"type": "QVariant"}
neptune_UI_Center_Console = {"title": "Neptune 3 UI - Center Console", "type": "QQuickWindowQmlImpl", "unnamed": 1, "visible": True}
o_QtAM_ApplicationManagerWindow = {"type": "QtAM::ApplicationManagerWindow", "unnamed": 1, "visible": True}

# Todo: there might be a rather simple and more effective
# way of switching container as python's way of
# using references, and (shallow/deep) copy should be
# much simpler than the below strategy.

# we need a copy and not reference
# Use container for each, at this point they are
# the same, but in the future an app container
# in single process might be somewhere else in
# the object tree of Neptune3 UI.
multi_process_container = o_QtAM_ApplicationManagerWindow.copy()

climate_single_process_container = neptune_UI_Center_Console.copy()
calendar_single_process_container = neptune_UI_Center_Console.copy()
music_single_process_container = neptune_UI_Center_Console.copy()
phone_single_process_container = neptune_UI_Center_Console.copy()
settings_single_process_container = neptune_UI_Center_Console.copy()


# define for each app an own starting-to-search container,
# they all might look the same and could maybe be simplified
# but we can leave this option open, if in case, one of the
# apps cannot simply be replaced by the "center-console"-container
container_climate = climate_single_process_container.copy()
container_calendar = calendar_single_process_container.copy()
container_music = music_single_process_container.copy()
container_phone = phone_single_process_container.copy()
container_settings = settings_single_process_container.copy()
container_phone = phone_single_process_container.copy()

# the apps below do not belong to apps that have an own sub processes, yet!
container_downloads = neptune_UI_Center_Console.copy()


# contains the changer
apps_reference_container = {'container_climate': container_climate,
                            'container_calendar': container_calendar,
                            'container_music': container_music,
                            'container_phone': container_phone,
                            'container_settings': container_settings}

# create an array of all changers, they will be used not singled out
# but rather as the whole collection if mode is multi-process
apps_change_collection = []
for app_ref_str in apps_reference_container.keys():
    app_referencer = referencer.Referencer(app_ref_str,
                                           container_getter,
                                           container_setter)
    apps_change_collection.append(app_referencer)

# ###########################################################################
neptune_UI_Center_Console_grid_GridView = {"container": neptune_UI_Center_Console, "id": "grid", "type": "GridView", "unnamed": 1, "visible": True}
neptune_UI_Instrument_Cluster_QQuickWindowQmlImpl = {"title": "Neptune 3 UI - Instrument Cluster", "type": "QQuickWindowQmlImpl", "unnamed": 1, "visible": True, "window": o_QVariant}
grid_Item = {"container": neptune_UI_Center_Console_grid_GridView, "type": "Item", "unnamed": 1, "visible": True}
neptune_UI_Center_Console_widgetListview_ListView = {"container": neptune_UI_Center_Console, "objectName": "widgetListview", "type": "ListView", "visible": True}
neptune_3_UI_Center_Console_volumePopupButton_ToolButton = {"container": neptune_UI_Center_Console, "objectName": "volumePopupButton", "type": "ToolButton", "visible": True}
neptune_3_UI_Center_Console_volumePopupItem_VolumePopup = {"container": neptune_UI_Center_Console, "objectName": "volumePopupItem", "type": "VolumePopup", "visible": True}
neptune_3_UI_Center_Console_popupClose_ToolButton = {"checkable": False, "container": neptune_UI_Center_Console, "objectName": "popupClose", "type": "ToolButton", "visible": True}
neptune_3_UI_Center_Console_volumeSlider_Slider = {"container": neptune_UI_Center_Console, "objectName": "volumeSlider", "type": "Slider", "visible": True}
neptune_3_UI_Center_Console_centerConsole_CenterConsole = {"container": neptune_UI_Center_Console, "id": "centerConsole", "type": "AbstractCenterConsole", "visible": True}

neptune_3_UI_Center_Console_addWidgetButton_ToolButton = {"checkable": False, "container": neptune_UI_Center_Console, "objectName": "addWidgetButton", "type": "ToolButton", "visible": True}
neptune_3_UI_Center_Console_addWidgetPopupItem_AddWidgetPopup = {"container": neptune_UI_Center_Console, "objectName": "addWidgetPopupItem", "type": "AddWidgetPopup", "visible": True}
widgetList_AddWidgets_Maps = {"container": neptune_UI_Center_Console_widgetListview_ListView, "objectName": "itemAddWidget_com.pelagicore.map", "type": "ListItem", "visible": True}
neptune_3_UI_Center_Console_launcherCenterConsole_Launcher = {"container": neptune_UI_Center_Console, "objectName": "launcher", "type": "Launcher", "visible": True}
neptune_3_UI_Center_Console_gridButton_ToolButton = {"checkable": True, "container": neptune_UI_Center_Console, "objectName": "gridButton", "type": "ToolButton", "visible": True}
neptune_3_UI_Center_Console_editableLauncher_EditableGridView = {"container": neptune_UI_Center_Console, "objectName": "editableLauncher", "type": "EditableGridView", "visible": True}
neptune_3_UI_Center_Console_activeApplicationSlot_Item = {"container": neptune_UI_Center_Console, "objectName": "activeApplicationSlot", "type": "Item", "visible": True}

neptune_3_UI_Instrument_Cluster_QQuickWindowQmlImpl = {"title": "Neptune 3 UI - Instrument Cluster", "type": "QQuickWindowQmlImpl", "unnamed": 1, "visible": True}
climateAreaMouseArea_MouseArea = {"container": o_QtAM_ApplicationManagerWindow, "objectName": "climateAreaMouseArea", "type": "MouseArea", "visible": True}
leftTempSlider_TemperatureSlider = {"container": o_QtAM_ApplicationManagerWindow, "objectName": "leftTempSlider", "type": "TemperatureSlider", "visible": True}
rightTempSlider_TemperatureSlider = {"container": o_QtAM_ApplicationManagerWindow, "objectName": "rightTempSlider", "type": "TemperatureSlider", "visible": True}
o_ClimateView = {"container": o_QtAM_ApplicationManagerWindow, "type": "ClimateView", "unnamed": 1, "visible": True}
o_QtAM_ApplicationManagerWindow_2 = {"type": "QtAM::ApplicationManagerWindow", "unnamed": 1, "visible": False}
auto_Button = {"checkable": True, "container": o_QtAM_ApplicationManagerWindow_2, "id": "bigFatButton", "type": "Button", "unnamed": 1, "visible": True}
neptune_3_UI_Center_Console_widgetGrid_homepage_WidgetGrid = {"container": neptune_UI_Center_Console, "objectName": "widgetGrid_homepage", "type": "WidgetGrid", "visible": True}
events_ToolButton = {"container": container_calendar, "objectName": "eventsViewButton", "type": "ToolButton", "visible": True}
year_ToolButton = {"container": container_calendar, "objectName": "yearViewButton", "type": "ToolButton", "visible": True}
next_ToolButton = {"container": container_calendar, "objectName": "nextViewButton", "type": "ToolButton", "visible": True}
calendarViewContent = {"container": container_calendar, "objectName": "calendarViewContent", "type": "StackLayout", "visible": True}
rear_defrost_Button = {"checkable": True, "container": container_climate, "objectName": "rear_defrost", "type": "Button", "visible": True}
front_defrost_Button = {"checkable": True, "container": container_climate, "objectName": "front_defrost", "type": "Button", "visible": True}
recirculation_Button = {"checkable": True, "container": container_climate, "objectName": "recirculation", "type": "Button", "visible": True}
seat_heater_driver_Button = {"checkable": True, "container": container_climate, "objectName": "seat_heater_driver", "type": "Button", "visible": True}
steering_wheel_heat_Button = {"checkable": True, "container": container_climate, "objectName": "steering_wheel_heat", "type": "Button", "visible": True}
seat_heater_passenger_Button = {"checkable": True, "container": container_climate, "objectName": "seat_heater_passenger", "type": "Button", "visible": True}
languageViewButton_ToolButton = {"container": container_settings, "objectName": "languageViewButton", "type": "ToolButton", "visible": True}
dateViewButton_ToolButton = {"container": container_settings, "objectName": "dateViewButton", "type": "ToolButton", "visible": True}
themesViewButton_ToolButton = {"container": container_settings, "objectName": "themesViewButton", "type": "ToolButton", "visible": True}
colorsViewButton_ToolButton = {"container": container_settings, "objectName": "colorsViewButton", "type": "ToolButton", "visible": True}
languagePanel_LanguagePanel = {"container": container_settings, "objectName": "languagePanel", "type": "LanguagePanel"}
datePanel_DateTimePanel = {"container": container_settings, "objectName": "datePanel", "type": "DateTimePanel"}
colorsPanel_ColorsPanel = {"container": container_settings, "objectName": "colorsPanel", "type": "ColorsPanel"}
themesPanel_ThemesPanel = {"container": container_settings, "objectName": "themesPanel", "type": "ThemesPanel"}
dateTimeSwitch_SwitchDelegate = {"container": container_settings, "objectName": "dateTimeSwitch", "type": "SwitchDelegate"}
dateAndTime = {"container": neptune_UI_Center_Console, "type": "DateAndTime", "objectName": "dateAndTime", "visible": True}
phoneViewChangeButtons_ToolsColumn = {"container": container_phone, "objectName": "phoneViewChangeButtons", "type": "ToolsColumn", "visible": True}
phoneMainStackView_StackView = {"container": container_phone, "objectName": "phoneMainStackView", "type": "StackView", "visible": True}
phonefavoritesView_FavoritesWidgetView = {"container": container_phone, "objectName": "phonefavoritesView", "type": "FavoritesWidgetView", "visible": True}
phoneCallView_CallWidgetView =   {"container": container_phone, "objectName": "phoneCallView", "type": "CallWidgetView"}
contacts_phoneView_ContactsView = {"container": container_phone, "objectName": "contacts_phoneView", "type": "ContactsView", "visible": True}
recents_phoneView_RecentCallsView = {"container": container_phone, "objectName": "recents_phoneView", "type": "RecentCallsView", "visible": True}
favorites_phoneView_ContactsView = {"container": container_phone, "objectName": "favorites_phoneView", "type": "ContactsView", "visible": True}
keypad_phoneView_KeypadViewPanel = {"container": container_phone, "objectName": "keypad_phoneView", "type": "KeypadViewPanel", "visible": True}
phoneCallerEndButton = {"container": container_phone, "objectName": "callerButtonEndCall", "type": "ToolButton", "visible": True}
phoneCallerLabel = {"container": container_phone, "objectName": "callerLabelFullName", "type": "Label", "visible": True}
musicPlayer = {"container": container_music, "objectName": "musicPlayer", "type": "AlbumArtPanel", "visible": True}
musicAppContent_MusicView = {"container": container_music, "objectName": "musicAppContent", "type": "MusicView", "visible": True}
musicProgressBar_MusicProgress = {"container": container_music, "objectName": "musicProgressBar", "type": "MusicProgress", "visible": True}
musicSongNext_ToolButton = {"container": container_music, "objectName": "musicSongNext", "type": "ToolButton", "visible": True}
musicSongPlayPause_ToolButton = {"container": container_music, "objectName": "musicSongPlayPause", "type": "ToolButton", "visible": True}
musicSongPrevious_ToolButton = {"container": container_music, "objectName": "musicSongPrevious", "type": "ToolButton", "visible": True}
shuffleMusicButton_ToolButton = {"container": container_music, "objectName": "shuffleMusicButton", "type": "ToolButton", "visible": True}
repeatMusicButton_ToolButton = {"container": container_music, "objectName": "repeatMusicButton", "type": "ToolButton", "visible": True}
musicView_sources_ToolButton = {"container": container_music, "objectName": "musicView_sources", "type": "ToolButton", "visible": True}
musicView_albums_ToolButton = {"container": container_music, "objectName": "musicView_albums", "type": "ToolButton", "visible": True}
musicView_artists_ToolButton = {"container": container_music, "objectName": "musicView_artists", "type": "ToolButton", "visible": True}
musicView_favorites_ToolButton = {"container": container_music, "objectName": "musicView_favorites", "type": "ToolButton", "visible": True}
musicPlayListList_ListView = {"container": container_music, "objectName": "musicPlayListList", "type": "ListView", "visible": True}
musicListBackButton_ToolButton = {"container": container_music, "objectName": "musicListBackButton", "type": "ToolButton", "visible": False}
musicListPlayAllButton_ToolButton = {"container": container_music, "objectName": "musicListPlayAllButton", "type": "ToolButton", "visible": False}
musicToolsColumn = {"container": container_music, "objectName": "musicToolsColumn", "type": "ToolsColumn", "visible": True}
downloadAppList_DownloadAppList = {"container": container_downloads, "objectName": "downloadAppList", "type": "DownloadAppList", "visible": True}
downloadAppViewButton_Games = {"container": container_downloads, "objectName": "downloadAppViewButton_Games", "type": "ToolButton", "visible": True}
downloadAppViewButton_Business = {"container": container_downloads, "objectName": "downloadAppViewButton_Business", "type": "ToolButton", "visible": True}
downloadAppViewButton_Entertainment = {"container": container_downloads, "objectName": "downloadAppViewButton_Entertainment", "type": "ToolButton", "visible": True}
downloadsToolsColumn = {"container": container_downloads, "objectName": "downloadsAppColumn", "type": "DownloadsToolsColumn", "visible": True}
