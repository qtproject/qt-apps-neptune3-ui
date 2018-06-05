TEMPLATE = subdirs
android: {
SUBDIRS += \
    frontend \
    backend \
    qml_plugin \
}
else: {
SUBDIRS += \
    frontend \
    backend \
    server \
    qml_plugin \
    app
}

backend.depends = frontend
server.depends = frontend
app.depends = frontend
qml_plugin.depends = frontend

OTHER_FILES += settings.qface
