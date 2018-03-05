TEMPLATE = lib
TARGET  = neptunestyle
QT += qml quick
QT += gui-private quick-private quickcontrols2-private
CONFIG += qt plugin c++11 no_private_qt_headers_warning

uri = com.pelagicore.styles.neptune
load(qmlplugin)

SOURCES += \
    neptunestyle.cpp \
    neptunestyleplugin.cpp \
    neptunetheme.cpp

HEADERS += \
    neptunestyle.h \
    neptunestyleplugin.h \
    neptunetheme.h

RESOURCES += \
    neptunestyle.qrc

# Output/Intermediate Dirs
OBJECTS_DIR             = ./objs
OBJMOC                  = ./objs
MOC_DIR                 = ./objs
UI_DIR                  = ./objs
RCC_DIR                 = ./objs
