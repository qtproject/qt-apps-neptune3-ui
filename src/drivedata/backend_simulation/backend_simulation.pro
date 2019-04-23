TEMPLATE=lib
TARGET = $$qtLibraryTarget(drivedata_backend_simulation)
CONFIG += ivigenerator plugin

QT_FOR_CONFIG += ivicore
!qtConfig(ivigenerator): error("No ivigenerator available: Make sure QtIvi is installed and configured correctly")

include($$SOURCE_DIR/config.pri)

LIBS += -L$$LIB_DESTDIR -l$$qtLibraryTarget(drivedata)
DESTDIR = $$BUILD_DIR/qtivi

#needed for the android deployment to work
android: DESTDIR = $$BUILD_DIR/plugins/qtivi

CONFIG += warn_off
INCLUDEPATH += $$OUT_PWD/../frontend
PLUGIN_TYPE = qtivi
PLUGIN_CLASS_NAME = DriveDataPlugin

QT += core ivicore

QFACE_FORMAT = backend_simulator
QFACE_SOURCES = ../drivedata.qface

DEPENDPATH += $$OUT_PWD/../backend

QMAKE_RPATHDIR += $$QMAKE_REL_RPATH_BASE/$$relative_path($$INSTALL_PREFIX/neptune3/lib, $$INSTALL_PREFIX/neptune3/qtivi)

target.path = $$INSTALL_PREFIX/neptune3/qtivi
INSTALLS += target

#! [0]
RESOURCES += plugin_resource.qrc
#! [0]
QML_IMPORT_PATH = $$OUT_PWD/qml
