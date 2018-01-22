#!/bin/sh
SERVER_CONF_PATH=/opt/triton/server.conf QT_PLUGIN_PATH=/opt/triton:$QT_PLUGIN_PATH QT_QUICK_CONTROLS_CONF=/opt/triton/styles/1080x1920Triton.conf QT_QUICK_CONTROLS_STYLE_PATH=/opt/triton/styles/ QT_QUICK_CONTROLS_STYLE=triton qmlscene StandAlone.qml -I /opt/triton/imports/shared/
