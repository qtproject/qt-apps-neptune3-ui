include(../../config.pri)

TEMPLATE = app
TARGET   = com.pelagicore.qtlocation

QT *= quick appman_launcher-private
CONFIG *= c++11 no_private_qt_headers_warning link_pkgconfig
macos:CONFIG -= app_bundle

SOURCES = main.cpp

DESTDIR = $$OUT_PWD/../../

DEFINES += "INSTALL_PATH=$$INSTALL_PREFIX/triton/"

target.path = $$INSTALL_PREFIX/triton/apps/com.pelagicore.qtlocation/
INSTALLS += target
