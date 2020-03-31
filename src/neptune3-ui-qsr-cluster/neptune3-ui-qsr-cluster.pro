TEMPLATE = app
TARGET   = neptune3-ui-qsr-cluster
DESTDIR = $$BUILD_DIR

include(../../config.pri)

android: target.path = $$INSTALL_PREFIX
else: target.path = $$INSTALL_PREFIX/neptune3
INSTALLS += target

CONFIG += exceptions c++11
macos: {
    CONFIG -= app_bundle
    SOURCES += safewindow_mac.mm
    HEADERS += safewindow_mac.h
}

win32 {
    wrapper.files = neptune3-ui-qsr-cluster_wrapper.bat
    wrapper.path = $$INSTALL_PREFIX/neptune3
    INSTALLS += wrapper
}

QT = core gui qtsaferenderer network ivicore

LIBS += -L$$LIB_DESTDIR -l$$qtLibraryTarget(remotesettings) -l$$qtLibraryTarget(drivedata)

INCLUDEPATH += $$OUT_PWD/../drivedata/frontend
INCLUDEPATH += $$OUT_PWD/../remotesettings/frontend

SOURCES += main.cpp \
    icsettingshandler.cpp \
    neptunesafestatemanager.cpp \
    safewindow.cpp \
    remotesettings_client.cpp \
    tcpmsghandler.cpp

DESTDIR = $$OUT_PWD/../../

HEADERS += \
    icsettingshandler.h \
    neptunesafestatemanager.h \
    safewindow.h \
    remotesettings_client.h \
    tcpmsghandler.h

QMAKE_RPATHDIR += $$QMAKE_REL_RPATH_BASE/$$relative_path($$INSTALL_PREFIX/neptune3/lib, $$INSTALL_PREFIX/neptune3/)
