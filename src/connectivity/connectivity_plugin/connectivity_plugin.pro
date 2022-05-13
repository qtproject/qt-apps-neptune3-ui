TEMPLATE = lib
CONFIG += plugin
QT += interfaceframework qml

LIBS += -L$$LIB_DESTDIR -l$$qtLibraryTarget(Connectivity)
INCLUDEPATH += $$OUT_PWD/../connectivity

QT_FOR_CONFIG += interfaceframework
!qtConfig(ifcodegen): error("No ifcodegen available: Make sure QtInterfaceFramework is installed and configured correctly")

include($$SOURCE_DIR/config.pri)

IFCODEGEN_TEMPLATE = qmlplugin
IFCODEGEN_SOURCES = ../connectivity.qface

load(ifcodegen)

uri = Connectivity
EXTRA_FILES += $$OUT_PWD/qmldir \
    $$OUT_PWD/plugins.qmltypes
load(qmlplugin)

QMAKE_RPATHDIR += $$QMAKE_REL_RPATH_BASE/$$relative_path($$INSTALL_PREFIX/neptune3/lib, $$installPath)
