TEMPLATE = lib
TARGET = $$qtLibraryTarget(parking_simulation)
DESTDIR = ../interfaceframework

QT += core interfaceframework
CONFIG += ifcodegen plugin

LIBS += -L$$OUT_PWD/../ -l$$qtLibraryTarget(Parking)
INCLUDEPATH += $$OUT_PWD/../frontend
QMAKE_RPATHDIR += $$QMAKE_REL_RPATH_BASE/../

IFCODEGEN_TEMPLATE = backend_simulator
IFCODEGEN_SOURCES = ../parking.qface
PLUGIN_TYPE = interfaceframework

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH = $$OUT_PWD/../frontend/qml

target.path = $$[QT_INSTALL_EXAMPLES]/neptune3-ui/chapter3-middleware/interfaceframework
INSTALLS += target

RESOURCES += \
    simulation.qrc
