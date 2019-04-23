QT -= gui

CONFIG += c++11 console
macos: CONFIG -= app_bundle
CONFIG += ivigenerator

QT_FOR_CONFIG += ivicore
!qtConfig(ivigenerator): error("No ivigenerator available: Make sure QtIvi is installed and configured correctly")

include($$SOURCE_DIR/config.pri)

QFACE_FORMAT = server_qtro
QFACE_SOURCES = ../drivedata.qface

SOURCES += \
    main.cpp\
    server.cpp

HEADERS += \
    server.h

DEPENDPATH += $$OUT_PWD/../server

LIBS += -L$$LIB_DESTDIR -l$$qtLibraryTarget(drivedata)

INCLUDEPATH += $$OUT_PWD/../frontend

QMAKE_RPATHDIR += $$QMAKE_REL_RPATH_BASE/$$relative_path($$INSTALL_PREFIX/neptune3/lib, $$INSTALL_PREFIX/neptune3)

DISTFILES +=

TARGET = drivedata-server
DESTDIR = $$BUILD_DIR

target.path = $$INSTALL_PREFIX/neptune3
INSTALLS += target
