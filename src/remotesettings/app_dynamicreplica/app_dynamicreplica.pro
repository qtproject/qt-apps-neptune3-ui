QT += quick remoteobjects
CONFIG += c++11
macos: CONFIG -= app_bundle

include($$SOURCE_DIR/config.pri)

SOURCES += main.cpp \
    abstractdynamic.cpp \
    client.cpp \
    uisettingsdynamic.cpp \
    instrumentclusterdynamic.cpp \
    systemuidynamic.cpp

RESOURCES += qml.qrc

HEADERS += \
    abstractdynamic.h \
    client.h \
    uisettingsdynamic.h \
    instrumentclusterdynamic.h \
    systemuidynamic.h


TARGET = TritonControlApp
DESTDIR = $$BUILD_DIR

target.path = $$INSTALL_PREFIX/triton
INSTALLS += target

DISTFILES += \
    android/AndroidManifest.xml \
    android/res/values/libs.xml \
    android/build.gradle

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
