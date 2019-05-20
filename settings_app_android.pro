requires(android)

TEMPLATE = subdirs

include(config.pri)

SUBDIRS += \
    src/drivedata/drivedata.pro \
    src/remotesettings/frontend/frontend.pro \
    src/remotesettings/backend/backend.pro \
    src/remotesettings/qml_plugin/qml_plugin.pro \
    src/remotesettings/app/app.pro

CONFIG += ordered

OTHER_FILES += src/remotesettings/settings.qface
