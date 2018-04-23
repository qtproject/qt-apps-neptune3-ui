requires(linux:!android|win32:!winrt|macos)

TEMPLATE = subdirs

include(config.pri)

SUBDIRS += plugins

SUBDIRS += tests

# mainly a hint for Qt Creator
QML_IMPORT_PATH += imports/shared imports/system sysui

copydata.file = copydata.pro
copydata.depends = plugins

requires(qtHaveModule(appman_main-private))

SUBDIRS += src
copydata.depends += src
copydata.depends += plugins

SUBDIRS += copydata

# Install all required files
qml.files = apps dev/apps imports sysui styles am-config.yaml Main.qml
qml.path = $$INSTALL_PREFIX/neptune3
INSTALLS += qml
server.files = server.conf
server.path = $$INSTALL_PREFIX/neptune3
INSTALLS += server

OTHER_FILES += $$files($$PWD/*.qml, true)
OTHER_FILES += $$files($$PWD/*.qmldir, true)
OTHER_FILES += $$PWD/plugins.yaml.in
OTHER_FILES += .qmake.conf
PLUGINS_DIR = $$OUT_PWD/qml
QMAKE_SUBSTITUTES += $$PWD/plugins.yaml.in

tests.depends = copydata plugins src
