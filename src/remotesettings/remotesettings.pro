TEMPLATE = subdirs

SUBDIRS += \
    frontend \
    backend \
    qml_plugin \

!android:!ios:SUBDIRS += \
    server \
    app \

backend.depends = frontend
server.depends = frontend
app.depends = frontend
qml_plugin.depends = frontend

OTHER_FILES += settings.qface
