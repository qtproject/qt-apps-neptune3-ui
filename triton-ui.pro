requires(linux:!android|win32-msvc2013:!winrt|win32-msvc2015:!winrt|macos|win32-g++*)

TEMPLATE = subdirs

include(config.pri)

SUBDIRS += plugins

SUBDIRS += tests

copydata.file = copydata.pro
copydata.depends = plugins

!qtHaveModule(appman_main-private) {
   error("Module appman_main-private not found.")
}

SUBDIRS += src
copydata.depends += src

SUBDIRS += copydata

# Install all required files
qml.files = apps imports sysui styles am-config.yaml Main.qml
qml.path = $$INSTALL_PREFIX/triton
INSTALLS += qml

OTHER_FILES += $$files($$PWD/*.qml, true)
OTHER_FILES += $$files($$PWD/*.qmldir, true)
OTHER_FILES += $$PWD/plugins.yaml.in
OTHER_FILES += .qmake.conf
PLUGINS_DIR = $$OUT_PWD/qml
QMAKE_SUBSTITUTES += $$PWD/plugins.yaml.in
