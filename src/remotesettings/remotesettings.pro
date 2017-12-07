TEMPLATE = subdirs

SUBDIRS += \
    frontend \
    backend \
    server \
    app \
    app_dynamicreplica \
    qml_plugin

backend.depends = frontend
server.depends = frontend
app.depends = frontend
qml_plugin.depends = frontend

OTHER_FILES += settings.qface
