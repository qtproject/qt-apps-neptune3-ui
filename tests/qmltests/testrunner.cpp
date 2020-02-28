#include <QtQuickTest/quicktest.h>

static bool s_styleConfig = qputenv("QT_QUICK_CONTROLS_CONF", STYLE_CONF_PATH);
static bool s_stylesPath = qputenv("QT_QUICK_CONTROLS_STYLE_PATH", STYLES_PATH);

QUICK_TEST_MAIN(neptune-qmltests)
