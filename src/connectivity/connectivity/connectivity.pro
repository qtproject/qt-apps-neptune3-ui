TARGET = $$qtLibraryTarget(Connectivity)
TEMPLATE = lib
CONFIG += ifcodegen

QT += interfaceframework interfaceframework-private qml quick
QT_FOR_CONFIG += interfaceframework
!qtConfig(ifcodegen): error("No ifcodegen available: Make sure QtInterfaceFramework is installed and configured correctly")

IFCODEGEN_SOURCES = ../connectivity.qface

DESTDIR = $$LIB_DESTDIR
DEFINES += QT_BUILD_CONNECTIVITY_LIB

include($$SOURCE_DIR/config.pri)

macos: QMAKE_SONAME_PREFIX = @rpath
target.path = $$INSTALL_PREFIX/neptune3/lib
win32:target.path = $$INSTALL_PREFIX/neptune3/
INSTALLS += target
