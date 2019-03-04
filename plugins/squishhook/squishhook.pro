QT       -= gui
QT       += qml appman_plugininterfaces_private

TARGET = AppmanSquishHook
TEMPLATE = lib

isEmpty(SQUISH_PREFIX) {
    error( Please specify the path to the Squish installation under $${SQUISH_PREFIX} )
}

include( $${SQUISH_PREFIX}/qtbuiltinhook.pri )

DEFINES += APPMANHOOK_LIBRARY

SOURCES += \
        appmansquishhook.cpp

HEADERS += \
        appmansquishhook.h \
        appmanhook_global.h

target.path = $${INSTALL_PREFIX}/neptune3/lib
config.path = $${INSTALL_PREFIX}/neptune3
config.extra = sed "\'s\\PATH_TO_THE_HOOK_LIBRARY\\$${INSTALL_PREFIX}/neptune3/lib/libAppmanSquishHook.so\\;w $${INSTALL_PREFIX}/neptune3/squish-appman-hook.yaml\'" $${PWD}/squish-appman-hook.yaml
INSTALLS += target config
