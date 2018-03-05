TEMPLATE = lib
CONFIG += plugin
QT += qml

SOURCES += WidgetGridPlugin.cpp WidgetListModel.cpp
HEADERS += WidgetListModel.h

TARGET = widgetgridplugin

uri = NeptuneWidgetGrid
load(qmlplugin)
