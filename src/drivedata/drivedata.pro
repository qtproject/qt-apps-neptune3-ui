TEMPLATE = subdirs

SUBDIRS = frontend \
          backend_simulation \
          qml_plugin \

# Don't build the production backend on android and ios, only use the simulation backend
!android:!ios:SUBDIRS += \
    drivedata-server \
    backend \

backend.depends = frontend
server.depends = frontend
backend_simulation.depends = frontend
qml_plugin.depends = frontend

OTHER_FILES +=

DISTFILES += \
    drivedata.qface \
    drivedata.yaml
