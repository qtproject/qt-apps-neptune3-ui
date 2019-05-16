TARGET = $$qtLibraryTarget(remotesettings)
TEMPLATE = lib
CONFIG += ivigenerator
DESTDIR = $$LIB_DESTDIR

QT_FOR_CONFIG += ivicore
!qtConfig(ivigenerator): error("No ivigenerator available: Make sure QtIvi is installed and configured correctly")

macos: QMAKE_SONAME_PREFIX = @rpath

include($$SOURCE_DIR/config.pri)

DEFINES += QT_BUILD_REMOTESETTINGS_LIB
QT += ivicore ivicore-private qml

QFACE_SOURCES = ../remotesettings.qface

DEPENDPATH += $$OUT_PWD/../frontend

target.path = $$INSTALL_PREFIX/neptune3/lib
win32:target.path = $$INSTALL_PREFIX/neptune3/
INSTALLS += target
