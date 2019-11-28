TEMPLATE = lib
TARGET = $$qtLibraryTarget(parking_simulation)
DESTDIR = ../qtivi

QT += core ivicore
CONFIG += ivigenerator plugin

LIBS += -L$$OUT_PWD/../ -l$$qtLibraryTarget(Parking)
INCLUDEPATH += $$OUT_PWD/../frontend
QMAKE_RPATHDIR += $$QMAKE_REL_RPATH_BASE/../

QFACE_FORMAT = backend_simulator
QFACE_SOURCES = ../parking.qface
PLUGIN_TYPE = qtivi

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH = $$OUT_PWD/../frontend/qml

target.path = $$[QT_INSTALL_EXAMPLES]/neptune3-ui/chapter3-middleware/qtivi
INSTALLS += target

RESOURCES += \
    simulation.qrc
