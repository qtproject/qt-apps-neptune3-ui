requires(android)

TEMPLATE = subdirs

include(config.pri)

SUBDIRS += \
    drivedata_frontend \
    drivedata_backend \
    drivedata_qml_plugin \
    remotesettings_frontend \
    remotesettings_backend \
    remotesettings_qml_plugin \
    remotesettings_app \

drivedata_frontend.file = src/drivedata/frontend/frontend.pro
drivedata_backend.file = src/drivedata/backend/backend.pro
drivedata_qml_plugin.file = src/drivedata/qml_plugin/qml_plugin.pro
remotesettings_frontend.file = src/remotesettings/frontend/frontend.pro
remotesettings_backend.file = src/remotesettings/backend/backend.pro
remotesettings_qml_plugin.file = src/remotesettings/qml_plugin/qml_plugin.pro
remotesettings_app.file = src/remotesettings/app/app.pro

drivedata_backend.depends = drivedata_frontend
drivedata_qml_plugin.depends = drivedata_frontend

remotesettings_backend.depends = remotesettings_frontend
remotesettings_qml_plugin.depends = remotesettings_frontend

remotesettings_app.depends = remotesettings_frontend

OTHER_FILES += src/remotesettings/remotesettings.qface
