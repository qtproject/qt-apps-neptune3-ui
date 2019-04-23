TEMPLATE = lib
CONFIG += plugin
TARGET  = drivedataplugin
QT += qml
LIBS += -L$$LIB_DESTDIR -l$$qtLibraryTarget(drivedata)
INCLUDEPATH += $$OUT_PWD/../frontend

include($$SOURCE_DIR/config.pri)

SOURCES += \
    plugin.cpp

uri = com.pelagicore.drivedata
load(qmlplugin)

QMAKE_RPATHDIR += $$QMAKE_REL_RPATH_BASE/$$relative_path($$INSTALL_PREFIX/neptune3/lib, $$installPath)
