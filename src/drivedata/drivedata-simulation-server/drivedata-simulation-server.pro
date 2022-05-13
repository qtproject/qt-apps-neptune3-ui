QT -= gui

macos: CONFIG -= app_bundle
CONFIG += ifcodegen

include($$SOURCE_DIR/config.pri)

QT_FOR_CONFIG += interfaceframework
!qtConfig(ifcodegen): error("No ifcodegen available")

TEMPLATE = app

QT += core interfaceframework

IFCODEGEN_TEMPLATE = server_qtro_simulator
IFCODEGEN_SOURCES = ../drivedata.qface

RESOURCES += plugin_resource.qrc
QML_IMPORT_PATH = $$OUT_PWD/qml

LIBS += -L$$LIB_DESTDIR -l$$qtLibraryTarget(drivedata)

INCLUDEPATH += $$OUT_PWD/../frontend

QMAKE_RPATHDIR += $$QMAKE_REL_RPATH_BASE/$$relative_path($$INSTALL_PREFIX/neptune3/lib, $$INSTALL_PREFIX/neptune3)

TARGET = drivedata-simulation-server
DESTDIR = $$BUILD_DIR

target.path = $$INSTALL_PREFIX/neptune3
INSTALLS += target
