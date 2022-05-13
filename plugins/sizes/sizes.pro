TEMPLATE = lib
CONFIG += qt plugin c++11 no_private_qt_headers_warning
QT += qml quick
QT += core-private gui-private qml-private quick-private quickcontrols2-private quickcontrols2impl-private

SOURCES += SizesPlugin.cpp Sizes.cpp
HEADERS += Sizes.h

TARGET = sizesplugin

uri = Sizes
load(qmlplugin)
