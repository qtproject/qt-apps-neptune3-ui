TARGET = drivedata-simulation-server
TEMPLATE = app
QT -= gui

QT_FOR_CONFIG += ivicore
!qtConfig(ivigenerator): error("No ivigenerator available")

LIBS += -L$$LIB_DESTDIR -l$$qtLibraryTarget(drivedata)
DESTDIR = $$BUILD_DIR
CONFIG += warn_off
INCLUDEPATH += $$OUT_PWD/../frontend
QT += core ivicore
CONFIG += ivigenerator
QMAKE_RPATHDIR += $$QMAKE_REL_RPATH_BASE/$$relative_path($$INSTALL_PREFIX/neptune3/lib, $$INSTALL_PREFIX/neptune3)

QFACE_FORMAT = server_qtro_simulator
QFACE_SOURCES = ../drivedata.qface

target.path = $$INSTALL_PREFIX/neptune3/qtivi
INSTALLS += target

RESOURCES += plugin_resource.qrc
QML_IMPORT_PATH = $$OUT_PWD/qml
