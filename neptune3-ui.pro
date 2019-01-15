requires(linux|android|macos|ios|win32:!winrt)

TEMPLATE = subdirs

include(config.pri)

SUBDIRS += plugins
SUBDIRS += doc
SUBDIRS += tests

# mainly a hint for Qt Creator
QML_IMPORT_PATH += imports_shared imports_system sysui

copydata.file = copydata.pro
copydata.depends = plugins

requires(qtHaveModule(appman_main-private))

SUBDIRS += src
copydata.depends += src
copydata.depends += plugins

SUBDIRS += copydata

android: INSTALL_PATH = $$INSTALL_PREFIX
else: INSTALL_PATH = $$INSTALL_PREFIX/neptune3

# Install all required files
qml.files = apps dev/apps imports_shared imports_system sysui styles Main.qml \
    am-config-neptune.yaml am-config-lucee.yaml am-config-android.yaml
qml.path = $$INSTALL_PATH
INSTALLS += qml

win32: server.files = win32/server.conf
else: server.files = server.conf

server.path = $$INSTALL_PATH
INSTALLS += server

OTHER_FILES += $$files($$PWD/*.qml, true)
OTHER_FILES += $$files($$PWD/*.qmldir, true)
OTHER_FILES += $$PWD/plugins.yaml.in
OTHER_FILES += .qmake.conf
OTHER_FILES += $$files($$PWD/squishtests/*, true)
PLUGINS_DIR = $$OUT_PWD/qml
QMAKE_SUBSTITUTES += $$PWD/plugins.yaml.in

tests.depends = copydata plugins src
