TARGET = NeptuneControlApp
DESTDIR = $$BUILD_DIR
QT += quick ivicore
CONFIG += c++11
CONFIG -= app_bundle

include($$SOURCE_DIR/config.pri)

LIBS += -L$$LIB_DESTDIR -l$$qtLibraryTarget(RemoteSettings)

INCLUDEPATH += $$OUT_PWD/../frontend

SOURCES += main.cpp \
    client.cpp

RESOURCES += qml.qrc \
    app.qrc

target.path = $$INSTALL_PREFIX/neptune3
INSTALLS += target

QMAKE_RPATHDIR += $$QMAKE_REL_RPATH_BASE/$$relative_path($$INSTALL_PREFIX/neptune3/lib, $$INSTALL_PREFIX/neptune3/)

#needed for the android deployment to include additional qml plugins
QML_IMPORT_PATH += $$BUILD_DIR/imports/shared

android {
#This is used to tell the deployment tool to include these additional
#libs to the apk. This library (libQt5RemoteObjects) is not directly used by the
#app itself, but by the backend plugin.
    ANDROID_EXTRA_LIBS = $$[QT_INSTALL_LIBS]/libQt5RemoteObjects.so

#In case we have some other than QML plugins to include to the apk, this is the
#variable to use. In this case we use it to include the Qtivi backend plugin,
#which is expected to be found under directory "qtivi". For this to work, the
#built plugin has then to be found under "$$BUILD_DIR/plugins/qtivi/".
#There is a line in the backend plugin's .pro file that places the plugin under
#"$$BUILD_DIR/plugins/" when building for android
    ANDROID_EXTRA_PLUGINS = $$BUILD_DIR/plugins/
}

HEADERS += \
    client.h
