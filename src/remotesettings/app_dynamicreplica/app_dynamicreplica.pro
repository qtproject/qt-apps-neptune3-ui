QT += quick remoteobjects
CONFIG += c++11
macos: CONFIG -= app_bundle

include($$SOURCE_DIR/config.pri)

SOURCES += main.cpp \
    abstractdynamic.cpp \
    client.cpp \
    uisettingsdynamic.cpp \
    instrumentclusterdynamic.cpp

RESOURCES += qml.qrc

HEADERS += \
    abstractdynamic.h \
    client.h \
    uisettingsdynamic.h \
    instrumentclusterdynamic.h


TARGET = TritonControlApp
DESTDIR = $$BUILD_DIR

target.path = $$INSTALL_PREFIX/triton
INSTALLS += target
