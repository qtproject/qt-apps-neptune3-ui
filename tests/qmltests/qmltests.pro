TEMPLATE=app
TARGET=neptune-qmltestsrunner
SOURCES += testrunner.cpp

include(../../config.pri)

# This will add the install directory to the PATH variable of the target_wrapper.bat for the autotest
# This is needed as the libremotesettings.dll will be installed there
win32 {
    extra_path.name = PATH
    extra_path.CONFIG = prepend
    extra_path.value += $$clean_path($$BUILD_DIR)
    extra_path.value += $$clean_path($$INSTALL_PREFIX/neptune3)
    QT_TOOL_ENV += extra_path
}

CONFIG += qmltestcase

# TODO: Check what is the import precedence to ensure Qt looks for modules first in the
# build dir and only after in the installation dir.
IMPORTPATH = $$BUILD_DIR/imports_shared \
             $$BUILD_DIR/imports_system \
             $$SOURCE_DIR/sysui \
             $$SOURCE_DIR/tests/dummyimports \
             $$INSTALL_PREFIX/neptune3/imports_system \
             $$INSTALL_PREFIX/neptune3/imports_shared

COMPONENT_NAMES = ApplicationWidget
COMPONENT_NAMES += WidgetGrid
COMPONENT_NAMES += WidgetDrawer

for(COMPONENT_NAME, COMPONENT_NAMES) {
    targetName = try$$COMPONENT_NAME
    QMAKE_EXTRA_TARGETS += $${targetName}
    $${targetName}.commands = $$OUT_PWD/../neptune-qmlscene/neptune-qmlscene
    !isEmpty(IMPORTPATH) {
        for(import, IMPORTPATH): $${targetName}.commands += -I \"$$import\"
    }
    $${targetName}.commands += $$PWD/tst_$${COMPONENT_NAME}.qml
}
