VERSION  = 5.14.2
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

android: QT += remoteobjects

HEADERS += \
    client.h
