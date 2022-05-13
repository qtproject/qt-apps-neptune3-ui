TEMPLATE = lib
CONFIG += plugin
QT += qml
LIBS += -L$$LIB_DESTDIR -l$$qtLibraryTarget(remotesettings)
INCLUDEPATH += $$OUT_PWD/../frontend

QT_FOR_CONFIG += interfaceframework
!qtConfig(ifcodegen): error("No ifcodegen available: Make sure QtInterfaceFramework is installed and configured correctly")

include($$SOURCE_DIR/config.pri)

IFCODEGEN_TEMPLATE = qmlplugin
IFCODEGEN_SOURCES = ../remotesettings.qface

load(ifcodegen)

# the qmlplugin template provides the URI variable to read the uri from the qface files, but this
# already contains the shared prefix, and the qmlplugin prf adds one as well
uri = com.pelagicore.remotesettings
EXTRA_FILES += $$OUT_PWD/qmldir \
    $$OUT_PWD/plugins.qmltypes
load(qmlplugin)

QMAKE_RPATHDIR += $$QMAKE_REL_RPATH_BASE/$$relative_path($$INSTALL_PREFIX/neptune3/lib, $$installPath)
