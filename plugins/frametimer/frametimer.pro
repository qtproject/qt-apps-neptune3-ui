TEMPLATE = lib
CONFIG += plugin
QT += qml quick

SOURCES += FrameTimerPlugin.cpp FrameTimer.cpp
HEADERS += FrameTimer.h

TARGET = frametimerplugin

uri = FrameTimer
load(qmlplugin)
