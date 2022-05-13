TARGET = $$qtLibraryTarget(Parking)
TEMPLATE = lib
DESTDIR = ..

QT += interfaceframework interfaceframework-private qml quick
CONFIG += unversioned_libname unversioned_soname

DEFINES += QT_BUILD_EXAMPLE_PARKING_LIB
CONFIG += ifcodegen
IFCODEGEN_SOURCES = ../parking.qface

macos: QMAKE_SONAME_PREFIX = @rpath

target.path = $$[QT_INSTALL_EXAMPLES]/neptune3-ui/chapter3-middleware/
INSTALLS += target
