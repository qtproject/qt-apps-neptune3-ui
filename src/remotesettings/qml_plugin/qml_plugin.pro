TEMPLATE = lib
CONFIG += plugin
TARGET  = RemoteSettingsPlugin
QT += qml
LIBS += -L$$OUT_PWD/../../../lib -l$$qtLibraryTarget(RemoteSettings)
INCLUDEPATH += $$OUT_PWD/../frontend

include($$SOURCE_DIR/config.pri)

SOURCES += \
    plugin.cpp

uri = com.pelagicore.settings
load(qmlplugin)

QMAKE_RPATHDIR += $ORIGIN/$$relative_path($$INSTALL_PREFIX/triton/lib, $$installPath)
