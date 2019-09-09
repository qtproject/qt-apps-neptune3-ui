TARGET = $$qtLibraryTarget(Parking)
TEMPLATE = lib
DESTDIR = ..

QT += ivicore ivicore-private qml quick
CONFIG += unversioned_libname unversioned_soname

DEFINES += QT_BUILD_EXAMPLE_PARKING_LIB
CONFIG += ivigenerator
QFACE_SOURCES = ../parking.qface

macos: QMAKE_SONAME_PREFIX = @rpath

target.path = /apps/chapter3-middleware/
INSTALLS += target
