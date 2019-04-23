TEMPLATE = subdirs

SUBDIRS += \
    frontend \
    backend_simulation \
    qml_plugin \

# Don't build the production backend on android and ios, only use the simulation backend
!android:!ios:SUBDIRS += \
    server \
    app \
    backend \

backend_simulation.depends = frontend
backend.depends = frontend
server.depends = frontend
app.depends = frontend
qml_plugin.depends = frontend

OTHER_FILES += dataprovider.qface
