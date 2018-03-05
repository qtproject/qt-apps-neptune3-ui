TEMPLATE=lib
TARGET = $$qtLibraryTarget(RemoteSettings_backend)
CONFIG += ivigenerator plugin

include($$SOURCE_DIR/config.pri)

LIBS += -L$$OUT_PWD/../../../lib -l$$qtLibraryTarget(RemoteSettings)
DESTDIR = ../../../qtivi

CONFIG += warn_off
INCLUDEPATH += $$OUT_PWD/../frontend
PLUGIN_TYPE = qtivi
PLUGIN_EXTENDS = qtivi
PLUGIN_CLASS_NAME = IviSettingsBackendInterface

QT += core remoteobjects ivicore

QFACE_FORMAT = backend_qtro
QFACE_SOURCES = ../settings.qface

DEPENDPATH += $$OUT_PWD/../backend

QMAKE_RPATHDIR += $$QMAKE_REL_RPATH_BASE/$$relative_path($$INSTALL_PREFIX/neptune3/lib, $$INSTALL_PREFIX/neptune3/qtivi)

target.path = $$INSTALL_PREFIX/neptune3/qtivi
INSTALLS += target
