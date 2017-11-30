TEMPLATE = app
TARGET   = triton-ui

include(../config.pri)

macos:CONFIG -= app_bundle
CONFIG *= no_private_qt_headers_warning link_pkgconfig

QT *= appman_main-private testlib gui-private

DEFINES *= TRITON_VERSION=\\\"$$VERSION\\\"

SOURCES = main.cpp ApplicationInfo.cpp ApplicationModel.cpp
HEADERS = ApplicationInfo.h ApplicationModel.h

DESTDIR = $$OUT_PWD/../

DEFINES += "TRITON_ICONS_PATH=$$INSTALL_PREFIX/triton/imports/assets/icons"

target.path = $$INSTALL_PREFIX/triton
INSTALLS += target
