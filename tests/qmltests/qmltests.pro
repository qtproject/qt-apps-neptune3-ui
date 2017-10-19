TEMPLATE=app
TARGET=triton-qmltestsrunner
SOURCES += testrunner.cpp

CONFIG += qmltestcase

IMPORTPATH = $$BUILD_DIR/imports/shared/ $$SOURCE_DIR/sysui $$SOURCE_DIR/tests/dummyimports

COMPONENT_NAMES = ApplicationWidget
COMPONENT_NAMES += WidgetDrawer

for(COMPONENT_NAME, COMPONENT_NAMES) {
    targetName = try$$COMPONENT_NAME
    QMAKE_EXTRA_TARGETS += $${targetName}
    $${targetName}.commands = $$OUT_PWD/../triton-qmlscene/triton-qmlscene
    !isEmpty(IMPORTPATH) {
        for(import, IMPORTPATH): $${targetName}.commands += -I \"$$import\"
    }
    $${targetName}.commands += $$PWD/tst_$${COMPONENT_NAME}.qml
}
