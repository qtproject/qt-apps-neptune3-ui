TEMPLATE=lib
TARGET = $$qtLibraryTarget(remotesettings_backend_simulation)
CONFIG += ifcodegen plugin

QT_FOR_CONFIG += interfaceframework
!qtConfig(ifcodegen): error("No ifcodegen available: Make sure QtInterfaceFramework is installed and configured correctly")

include($$SOURCE_DIR/config.pri)

LIBS += -L$$LIB_DESTDIR -l$$qtLibraryTarget(remotesettings)
DESTDIR = $$BUILD_DIR/interfaceframework

#needed for the android deployment to work
android: DESTDIR = $$BUILD_DIR/plugins/interfaceframework

CONFIG += warn_off
INCLUDEPATH += $$OUT_PWD/../frontend
PLUGIN_TYPE = interfaceframework
PLUGIN_EXTENDS = interfaceframework
PLUGIN_CLASS_NAME = IviSettingsBackendInterface

QT += core interfaceframework

IFCODEGEN_TEMPLATE = backend_simulator
IFCODEGEN_SOURCES = ../remotesettings.qface

DEPENDPATH += $$OUT_PWD/../backend

QMAKE_RPATHDIR += $$QMAKE_REL_RPATH_BASE/$$relative_path($$INSTALL_PREFIX/neptune3/lib, $$INSTALL_PREFIX/neptune3/interfaceframework)

target.path = $$INSTALL_PREFIX/neptune3/interfaceframework
INSTALLS += target
