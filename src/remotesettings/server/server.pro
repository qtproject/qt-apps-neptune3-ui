QT -= gui
QT += remoteobjects

CONFIG += c++11 console
CONFIG -= app_bundle
CONFIG += ivigenerator

include($$SOURCE_DIR/config.pri)

QFACE_FORMAT = server_qtro
QFACE_SOURCES = ../settings.qface

SOURCES += \
        main.cpp\
    culturesettingsservice.cpp \
    audiosettingsservice.cpp \
    model3dsettingsservice.cpp \
    navigationsettingsservice.cpp \
    server.cpp

HEADERS += \
    culturesettingsservice.h \
    audiosettingsservice.h \
    model3dsettingsservice.h \
    navigationsettingsservice.h \
    server.h

DEPENDPATH += $$OUT_PWD/../server

LIBS += -L$$OUT_PWD/../ -l$$qtLibraryTarget(RemoteSettings)

INCLUDEPATH += $$OUT_PWD/../frontend

QMAKE_RPATHDIR += $ORIGIN/$$relative_path($$INSTALL_PREFIX/triton/lib, $$INSTALL_PREFIX/triton)

DISTFILES +=

TARGET = RemoteSettings_server
DESTDIR = ..

target.path = $$INSTALL_PREFIX/triton
INSTALLS += target
