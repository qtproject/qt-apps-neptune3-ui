TEMPLATE = lib
TARGET = $$qtLibraryTarget(wifi_simulation)
CONFIG += ivigenerator plugin

QT += core ivicore
QT_FOR_CONFIG += ivicore
!qtConfig(ivigenerator): error("No ivigenerator available: Make sure QtIvi is installed and configured correctly")

LIBS += -L$$LIB_DESTDIR -l$$qtLibraryTarget(Connectivity)
DESTDIR = $$BUILD_DIR/qtivi

include($$SOURCE_DIR/config.pri)

QFACE_FORMAT = backend_simulator
QFACE_SOURCES = ../connectivity.qface
PLUGIN_TYPE = qtivi

INCLUDEPATH += $$OUT_PWD/../connectivity

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH = $$OUT_PWD/../connectivity/qml

QMAKE_RPATHDIR += $$QMAKE_REL_RPATH_BASE/$$relative_path($$INSTALL_PREFIX/neptune3/lib, $$INSTALL_PREFIX/neptune3/qtivi)

target.path = $$INSTALL_PREFIX/neptune3/qtivi
INSTALLS += target

RESOURCES += plugin_resource.qrc
