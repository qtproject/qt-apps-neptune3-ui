TEMPLATE = lib
TARGET = $$qtLibraryTarget(wifi_simulation)
CONFIG += ifcodegen plugin

QT += core interfaceframework
QT_FOR_CONFIG += interfaceframework
!qtConfig(ifcodegen): error("No ifcodegen available: Make sure QtInterfaceFramework is installed and configured correctly")

LIBS += -L$$LIB_DESTDIR -l$$qtLibraryTarget(Connectivity)
DESTDIR = $$BUILD_DIR/interfaceframework

include($$SOURCE_DIR/config.pri)

IFCODEGEN_TEMPLATE = backend_simulator
IFCODEGEN_SOURCES = ../connectivity.qface
PLUGIN_TYPE = interfaceframework

INCLUDEPATH += $$OUT_PWD/../connectivity

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH = $$OUT_PWD/../connectivity/qml

QMAKE_RPATHDIR += $$QMAKE_REL_RPATH_BASE/$$relative_path($$INSTALL_PREFIX/neptune3/lib, $$INSTALL_PREFIX/neptune3/interfaceframework)

target.path = $$INSTALL_PREFIX/neptune3/interfaceframework
INSTALLS += target

RESOURCES += plugin_resource.qrc
