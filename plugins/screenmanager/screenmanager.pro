TEMPLATE = lib
TARGET  = screenmanagerplugin
QT += qml quick
CONFIG += qt plugin c++11

uri = com.pelagicore.ScreenManager
load(qmlplugin)

SOURCES += \
    plugin.cpp \
    screenmanager.cpp \

HEADERS += \
    screenmanager.h \
