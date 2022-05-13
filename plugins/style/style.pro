TEMPLATE = lib
CONFIG += qt plugin c++11 no_private_qt_headers_warning
QT += qml quick
QT += core-private gui-private qml-private quick-private quickcontrols2-private quickcontrols2impl-private

SOURCES += StylePlugin.cpp Style.cpp StyleDefaults.cpp
HEADERS += Style.h StyleDefaults.h

TARGET = styleplugin

uri = Style
load(qmlplugin)
