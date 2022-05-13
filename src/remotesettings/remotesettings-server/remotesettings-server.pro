QT -= gui

CONFIG += c++11 console
macos: CONFIG -= app_bundle
CONFIG += ifcodegen

QT_FOR_CONFIG += interfaceframework
!qtConfig(ifcodegen): error("No ifcodegen available: Make sure QtInterfaceFramework is installed and configured correctly")

include($$SOURCE_DIR/config.pri)

IFCODEGEN_TEMPLATE = server_qtro
IFCODEGEN_SOURCES = ../remotesettings.qface

SOURCES += \
    main.cpp\
    server.cpp

HEADERS += \
    server.h

DEPENDPATH += $$OUT_PWD/../server

LIBS += -L$$LIB_DESTDIR -l$$qtLibraryTarget(remotesettings)

INCLUDEPATH += $$OUT_PWD/../frontend

QMAKE_RPATHDIR += $$QMAKE_REL_RPATH_BASE/$$relative_path($$INSTALL_PREFIX/neptune3/lib, $$INSTALL_PREFIX/neptune3)

DISTFILES +=

TARGET = remotesettings-server
DESTDIR = $$BUILD_DIR

target.path = $$INSTALL_PREFIX/neptune3
INSTALLS += target
