VERSION  = 5.13.2
TARGET = neptune-companion-app
DESTDIR = $$BUILD_DIR
QT += quick ivicore ivimedia
CONFIG += c++11
macos: CONFIG -= app_bundle

include($$SOURCE_DIR/config.pri)

load(gitUtils.prf)
DEFINES *= "NEPTUNE_COMPANION_APP_VERSION=$$VERSION"
DEFINES *= NEPTUNE_GIT_REVISION=\""\\\"$$currentGitRevision()\\\""\"

LIBS += -L$$LIB_DESTDIR -l$$qtLibraryTarget(remotesettings)

INCLUDEPATH += $$OUT_PWD/../frontend

SOURCES += main.cpp \
    client.cpp

RESOURCES += qml.qrc \
    app.qrc

target.path = $$INSTALL_PREFIX/neptune3
INSTALLS += target

win32 {
    wrapper.files = neptune-companion-app_wrapper.bat
    wrapper.path = $$INSTALL_PREFIX/neptune3
    INSTALLS += wrapper
}

QMAKE_RPATHDIR += $$QMAKE_REL_RPATH_BASE/$$relative_path($$INSTALL_PREFIX/neptune3/lib, $$INSTALL_PREFIX/neptune3/)

#needed for the android deployment to include additional qml plugins
QML_IMPORT_PATH += $$BUILD_DIR/imports_shared_cpp

android {
    copydata.commands = $(COPY_DIR) $$[QT_INSTALL_PLUGINS]/qtivi $$BUILD_DIR/plugins
    first.depends = $(first) copydata
    export(first.depends)
    export(copydata.commands)
    QMAKE_EXTRA_TARGETS += first copydata

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
