requires(linux|android|macos|win32:!winrt)

QT_FOR_CONFIG += ivicore

!qtHaveModule(ivicore)|!qtConfig(ivigenerator) {
    log("$$escape_expand(\\n\\n) *** No ivigenerator available: Make sure QtIvi is installed and configured correctly ***$$escape_expand(\\n\\n)")
    CONFIG += no_ivigenerator_available
}
requires(!no_ivigenerator_available)

!qtHaveModule(qtsaferenderer)|load(qtsaferenderer-tools):!qtsaferenderer-tools-available {
    log("$$escape_expand(\\n\\n) *** The qtsaferenderer module or tools are not available: Make sure that QtSafeRenderer is installed and configured correctly ***$$escape_expand(\\n\\n)")
}

!qtHaveModule(3dstudioruntime2){
    log("$$escape_expand(\\n\\n)[Warning] The 3dstudioruntime2 optional module is not available. $$escape_expand(\\n)[Warning] Neptune 3 UI can't show 3D content made with Qt 3D Studio without this module.$$escape_expand(\\n)[Warning] To show this content install Qt 3D Studio or the runtime.$$escape_expand(\\n\\n)")
}

TEMPLATE = subdirs

include(config.pri)

SUBDIRS += plugins
SUBDIRS += doc

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
OTHER_FILES += $$files($$PWD/qmake-features/*, true)
PLUGINS_DIR = $$OUT_PWD/qml
QMAKE_SUBSTITUTES += $$PWD/plugins.yaml.in

# tests configuration
enable-tests:QT_BUILD_PARTS *= tests
else:contains(QT_BUILD_PARTS, "tests"):CONFIG += enable-tests

# the following code-block was reused from qt_modules.prf
buildParts = $$eval($$upper($$TARGET)_BUILD_PARTS)
!isEmpty(buildParts): QT_BUILD_PARTS = $$buildParts
exists($$_PRO_FILE_PWD_/tests/tests.pro) {
    sub_tests.subdir = tests
    sub_tests.target = sub-tests
    contains(SUBDIRS, sub_src): sub_tests.depends = sub_src   # The tests may have a run-time only dependency on other parts
    contains(SUBDIRS, sub_tools): sub_tests.depends += sub_tools
    sub_tests.CONFIG = no_default_install
    !contains(QT_BUILD_PARTS, tests) {
        sub_tests.CONFIG += no_default_target
    } else: !uikit {
        # Make sure these are there in case we need them
        sub_tools.CONFIG -= no_default_target
        sub_examples.CONFIG -= no_default_target
        sub_demos.CONFIG -= no_default_target
    }
    SUBDIRS += sub_tests
    sub_tests.depends = copydata plugins src
}
QT_BUILD_PARTS -= tests
