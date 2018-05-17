TEMPLATE = lib
TARGET  = systeminfoplugin
QT += qml quick network
CONFIG += qt plugin c++11

uri = com.pelagicore.systeminfo
load(qmlplugin)

SOURCES += \
    plugin.cpp \
    systeminfo.cpp \

HEADERS += \
    systeminfo.h \
