TARGET = $$qtLibraryTarget(RemoteSettings)
TEMPLATE = lib
CONFIG += ivigenerator
DESTDIR = ..

include($$SOURCE_DIR/config.pri)

QT += ivicore ivicore-private qml quick

QFACE_SOURCES = ../settings.qface

DEPENDPATH += $$OUT_PWD/../frontend

target.path = $$INSTALL_PREFIX/triton/lib
INSTALLS += target
