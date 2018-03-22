#!/bin/sh
SERVER_CONF_PATH=/opt/neptune3/server.conf QT_PLUGIN_PATH=/opt/neptune3:$QT_PLUGIN_PATH QT_QUICK_CONTROLS_CONF=/opt/neptune3/styles/1080x1920Neptune.conf QT_QUICK_CONTROLS_STYLE_PATH=/opt/neptune3/styles/ QT_QUICK_CONTROLS_STYLE=neptune qmlscene StandAlone.qml -I /opt/neptune3/imports/shared/
