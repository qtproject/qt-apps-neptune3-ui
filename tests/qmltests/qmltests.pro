TEMPLATE=app
TARGET=neptune-qmltestsrunner
SOURCES += testrunner.cpp

include(../../config.pri)

CONFIG += qmltestcase

# TODO: Check what is the import precedence to ensure Qt looks for modules first in the
# build dir and only after in the installation dir.
IMPORTPATH = $$BUILD_DIR/imports/shared \
             $$BUILD_DIR/imports/system \
             $$SOURCE_DIR/sysui \
             $$SOURCE_DIR/tests/dummyimports \
             $$INSTALL_PREFIX/neptune3/imports/system \
             $$INSTALL_PREFIX/neptune3/imports/shared

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
