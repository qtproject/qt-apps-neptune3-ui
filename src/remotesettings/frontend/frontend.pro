TARGET = $$qtLibraryTarget(RemoteSettings)
TEMPLATE = lib
CONFIG += ivigenerator
DESTDIR = ../../../lib

macos: QMAKE_SONAME_PREFIX = @rpath

include($$SOURCE_DIR/config.pri)

QT += ivicore ivicore-private qml quick

QFACE_SOURCES = ../settings.qface

DEPENDPATH += $$OUT_PWD/../frontend

target.path = $$INSTALL_PREFIX/triton/lib
INSTALLS += target
