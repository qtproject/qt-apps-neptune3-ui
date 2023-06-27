requires(linux|android|macos|win32:!winrt)

QT_FOR_CONFIG += interfaceframework

!qtHaveModule(interfaceframework)|!qtConfig(ifcodegen) {
    log("$$escape_expand(\\n\\n) *** No ifcodegen available: Make sure QtInterfaceFramework is installed and configured correctly ***$$escape_expand(\\n\\n)")
    CONFIG += no_ifgenerator_available
}
requires(!no_ifgenerator_available)
requires(qtHaveModule(appman_main-private))

!qtHaveModule(qtsaferenderer)|load(qtsaferenderer-tools):!qtsaferenderer-tools-available {
    log("$$escape_expand(\\n\\n) *** The qtsaferenderer module or tools are not available: Make sure that QtSafeRenderer is installed and configured correctly ***$$escape_expand(\\n\\n)")
}

disable-studio3d|!qtHaveModule(studio3d){
    log("$$escape_expand(\\n\\n)[Warning] The studio3d optional module is not available. $$escape_expand(\\n)[Warning] Neptune 3 UI can't show some 3D content made with Qt 3D Studio without this module.$$escape_expand(\\n)[Warning] To show this content install the ogl-runtime.$$escape_expand(\\n\\n)")
}

TEMPLATE = subdirs
CONFIG *= ordered
SUBDIRS = src

enable-examples {
    SUBDIRS *= examples
}

enable-tests {
    SUBDIRS *= tests
}

include(config.pri)

SUBDIRS += plugins
SUBDIRS += doc

copydata.file = copydata.pro
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
OTHER_FILES += .qmake.conf
OTHER_FILES += $$files($$PWD/squishtests/*, true)
OTHER_FILES += $$files($$PWD/qmake-features/*, true)

# mainly a hint for Qt Creator
QML_IMPORT_PATH += imports_shared imports_system sysui
