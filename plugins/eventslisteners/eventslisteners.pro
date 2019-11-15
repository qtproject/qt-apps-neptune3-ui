TEMPLATE = lib
TARGET = eventslistenersplugin
QT += qml quick gui
CONFIG += qt plugin c++11

uri = com.luxoft.eventslisteners
load(qmlplugin)

SOURCES += \
    eventsListenersPlugin.cpp

HEADERS += \
    touchPointsTracer.h
