TEMPLATE = lib
CONFIG += plugin
TARGET  = dataproviderplugin
QT += qml
LIBS += -L$$LIB_DESTDIR -l$$qtLibraryTarget(dataprovider)
INCLUDEPATH += $$OUT_PWD/../frontend

include($$SOURCE_DIR/config.pri)

SOURCES += \
    plugin.cpp

uri = com.pelagicore.dataprovider
load(qmlplugin)

QMAKE_RPATHDIR += $$QMAKE_REL_RPATH_BASE/$$relative_path($$INSTALL_PREFIX/neptune3/lib, $$installPath)
