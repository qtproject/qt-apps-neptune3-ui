TEMPLATE = subdirs

SUBDIRS += \
    frontend \
    backend \
    server \
    qml_plugin \
    app

backend.depends = frontend
server.depends = frontend
app.depends = frontend
qml_plugin.depends = frontend

OTHER_FILES += settings.qface
