TEMPLATE = lib
TARGET  = tritonstyle
QT += qml quick
QT += gui-private quick-private quickcontrols2-private
CONFIG += qt plugin c++11 no_private_qt_headers_warning

uri = com.pelagicore.styles.triton
load(qmlplugin)

SOURCES += \
    tritonstyle.cpp \
    tritonstyleplugin.cpp \
    tritontheme.cpp

HEADERS += \
    tritonstyle.h \
    tritonstyleplugin.h \
    tritontheme.h

RESOURCES += \
    tritonstyle.qrc

# Output/Intermediate Dirs
OBJECTS_DIR             = ./objs
OBJMOC                  = ./objs
MOC_DIR                 = ./objs
UI_DIR                  = ./objs
RCC_DIR                 = ./objs
