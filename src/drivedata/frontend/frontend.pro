TARGET = $$qtLibraryTarget(drivedata)
TEMPLATE = lib
CONFIG += ifcodegen
DESTDIR = $$LIB_DESTDIR

QT_FOR_CONFIG += interfaceframework
!qtConfig(ifcodegen): error("No ifcodegen available: Make sure QtInterfaceFramework is installed and configured correctly")

macos: QMAKE_SONAME_PREFIX = @rpath

include($$SOURCE_DIR/config.pri)

DEFINES += QT_BUILD_DRIVEDATA_LIB
QT += interfaceframework interfaceframework-private qml

IFCODEGEN_SOURCES = ../drivedata.qface

target.path = $$INSTALL_PREFIX/neptune3/lib
win32:target.path = $$INSTALL_PREFIX/neptune3/
INSTALLS += target
