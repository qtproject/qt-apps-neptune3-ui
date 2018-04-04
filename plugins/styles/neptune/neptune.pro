TEMPLATE = lib
TARGET  = neptunestyle
QT += quick
QT += core-private gui-private qml-private quick-private quickcontrols2-private
CONFIG += qt plugin c++11 no_private_qt_headers_warning

uri = com.pelagicore.styles.neptune
load(qmlplugin)

DEFINES += "NEPTUNE_ICONS_PATH=$$INSTALL_PREFIX/neptune3/imports/assets/icons"

SOURCES += \
    neptunestyle.cpp \
    neptunestyleplugin.cpp \
    neptunetheme.cpp \
    qquickiconlabel.cpp \
    qquickicon.cpp

HEADERS += \
    neptunestyle.h \
    neptunestyleplugin.h \
    neptunetheme.h \
    qquickiconlabel_p.h \
    qquickiconlabel_p_p.h \
    qquickicon_p.h

RESOURCES += \
    neptunestyle.qrc

# Output/Intermediate Dirs
OBJECTS_DIR             = ./objs
OBJMOC                  = ./objs
MOC_DIR                 = ./objs
UI_DIR                  = ./objs
RCC_DIR                 = ./objs
