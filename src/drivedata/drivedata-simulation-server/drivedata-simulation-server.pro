QT -= gui

macos: CONFIG -= app_bundle
CONFIG += ivigenerator

include($$SOURCE_DIR/config.pri)

QT_FOR_CONFIG += ivicore
!qtConfig(ivigenerator): error("No ivigenerator available")

TEMPLATE = app

QT += core ivicore

QFACE_FORMAT = server_qtro_simulator
QFACE_SOURCES = ../drivedata.qface

RESOURCES += plugin_resource.qrc
QML_IMPORT_PATH = $$OUT_PWD/qml

LIBS += -L$$LIB_DESTDIR -l$$qtLibraryTarget(drivedata)

INCLUDEPATH += $$OUT_PWD/../frontend

QMAKE_RPATHDIR += $$QMAKE_REL_RPATH_BASE/$$relative_path($$INSTALL_PREFIX/neptune3/lib, $$INSTALL_PREFIX/neptune3)

TARGET = drivedata-simulation-server
DESTDIR = $$BUILD_DIR

target.path = $$INSTALL_PREFIX/neptune3
INSTALLS += target
