requires(android)

TEMPLATE = subdirs

include(config.pri)

SUBDIRS += \
    src/dataprovider/frontend/frontend.pro \
    src/dataprovider/backend/backend.pro \
    src/dataprovider/qml_plugin/qml_plugin.pro \
    src/dataprovider/app/app.pro

CONFIG += ordered

OTHER_FILES += src/remotesettings/settings.qface
