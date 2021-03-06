requires(linux|android|macos|win32:!winrt)

QT_FOR_CONFIG += ivicore

!qtHaveModule(ivicore)|!qtConfig(ivigenerator) {
    log("$$escape_expand(\\n\\n) *** No ivigenerator available: Make sure QtIvi is installed and configured correctly ***$$escape_expand(\\n\\n)")
    CONFIG += no_ivigenerator_available
}
requires(!no_ivigenerator_available)
requires(qtHaveModule(appman_main-private))

!qtHaveModule(qtsaferenderer)|load(qtsaferenderer-tools):!qtsaferenderer-tools-available {
    log("$$escape_expand(\\n\\n) *** The qtsaferenderer module or tools are not available: Make sure that QtSafeRenderer is installed and configured correctly ***$$escape_expand(\\n\\n)")
}

!qtHaveModule(studio3d){
    log("$$escape_expand(\\n\\n)[Warning] The studio3d optional module is not available. $$escape_expand(\\n)[Warning] Neptune 3 UI can't show some 3D content made with Qt 3D Studio without this module.$$escape_expand(\\n)[Warning] To show this content install the ogl-runtime.$$escape_expand(\\n\\n)")
}

enable-examples {
    NEPTUNE3-UI_BUILD_PARTS = $$QT_BUILD_PARTS
    NEPTUNE3-UI_BUILD_PARTS *= examples
}

enable-tests {
    NEPTUNE3-UI_BUILD_PARTS = $$QT_BUILD_PARTS
    NEPTUNE3-UI_BUILD_PARTS *= tests
}

load(qt_parts)

include(config.pri)

SUBDIRS += plugins
SUBDIRS += doc

copydata.file = copydata.pro
copydata.depends += sub_src
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
