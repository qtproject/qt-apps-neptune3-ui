TEMPLATE = subdirs

# Frontend
SUBDIRS = connectivity

# QML Plugin
SUBDIRS += connectivity_plugin

# WiFi Backend simulation
SUBDIRS += wifi_simulation

# WiFi Backend implementation
# SUBDIRS += wifi_backend

wifi_simulation.depends = connectivity
# wifi_backend.depends = connectivity
connectivity_plugin.depends = connectivity

OTHER_FILES += connectivity.qface
