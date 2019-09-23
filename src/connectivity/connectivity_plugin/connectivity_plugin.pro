TEMPLATE = lib
CONFIG += plugin
QT += ivicore qml

LIBS += -L$$LIB_DESTDIR -l$$qtLibraryTarget(Connectivity)
INCLUDEPATH += $$OUT_PWD/../connectivity

QT_FOR_CONFIG += ivicore
!qtConfig(ivigenerator): error("No ivigenerator available: Make sure QtIvi is installed and configured correctly")

include($$SOURCE_DIR/config.pri)

QFACE_FORMAT = qmlplugin
QFACE_SOURCES = ../connectivity.qface

load(ivigenerator)

uri = Connectivity
EXTRA_FILES += $$OUT_PWD/qmldir \
    $$OUT_PWD/plugins.qmltypes
load(qmlplugin)

QMAKE_RPATHDIR += $$QMAKE_REL_RPATH_BASE/$$relative_path($$INSTALL_PREFIX/neptune3/lib, $$installPath)
