TEMPLATE = lib
CONFIG += qt plugin c++11 no_private_qt_headers_warning
QT += qml quick
QT += core-private gui-private qml-private quick-private quickcontrols2-private

SOURCES += BasicStylePlugin.cpp BasicStyle.cpp BasicStyleDefaults.cpp
HEADERS += BasicStyle.h BasicStyleDefaults.h

TARGET = basicstyleplugin

uri = BasicStyle
load(qmlplugin)
