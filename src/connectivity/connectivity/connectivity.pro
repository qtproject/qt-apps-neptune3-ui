TARGET = $$qtLibraryTarget(Connectivity)
TEMPLATE = lib
CONFIG += ivigenerator

QT += ivicore ivicore-private qml quick
QT_FOR_CONFIG += ivicore
!qtConfig(ivigenerator): error("No ivigenerator available: Make sure QtIvi is installed and configured correctly")

QFACE_SOURCES = ../connectivity.qface

DESTDIR = $$LIB_DESTDIR

include($$SOURCE_DIR/config.pri)

macos: QMAKE_SONAME_PREFIX = @rpath
target.path = $$INSTALL_PREFIX/neptune3/lib
win32:target.path = $$INSTALL_PREFIX/neptune3/
INSTALLS += target
