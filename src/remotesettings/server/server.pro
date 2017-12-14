QT -= gui
QT += remoteobjects

CONFIG += c++11 console
macos: CONFIG -= app_bundle
CONFIG += ivigenerator

include($$SOURCE_DIR/config.pri)

QFACE_FORMAT = server_qtro
QFACE_SOURCES = ../settings.qface

SOURCES += \
    main.cpp\
    server.cpp

HEADERS += \
    server.h

DEPENDPATH += $$OUT_PWD/../server

LIBS += -L$$OUT_PWD/../../../lib -l$$qtLibraryTarget(RemoteSettings)

INCLUDEPATH += $$OUT_PWD/../frontend

QMAKE_RPATHDIR += $$QMAKE_REL_RPATH_BASE/$$relative_path($$INSTALL_PREFIX/triton/lib, $$INSTALL_PREFIX/triton)

DISTFILES +=

TARGET = RemoteSettingsServer
DESTDIR = $$BUILD_DIR

target.path = $$INSTALL_PREFIX/triton
INSTALLS += target
