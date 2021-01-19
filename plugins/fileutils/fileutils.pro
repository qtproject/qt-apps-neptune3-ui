TEMPLATE = lib
TARGET = fileutilsplugin
QT += core qml
CONFIG += qt plugin c++11

SOURCES += \
    fileUtils.cpp \
    fileUtilsPlugin.cpp \

HEADERS += \
    fileUtils.h \

uri = FileUtils
load(qmlplugin)
