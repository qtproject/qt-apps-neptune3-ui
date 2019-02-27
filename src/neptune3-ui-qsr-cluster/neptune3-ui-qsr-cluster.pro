TEMPLATE = app
TARGET   = neptune3-ui-qsr-cluster
DESTDIR = $$BUILD_DIR

CONFIG += exceptions c++11

QT = core gui qtsaferenderer network ivicore

LIBS += -L$$LIB_DESTDIR -l$$qtLibraryTarget(RemoteSettings)

message("OUT_PWD" + $$OUT_PWD)

INCLUDEPATH += $$OUT_PWD/../remotesettings/frontend

SOURCES = main.cpp \
    icsettingshandler.cpp \
    safewindow.cpp \
    remotesettings_client.cpp \
    tcpmsghandler.cpp

DESTDIR = $$OUT_PWD/../../

HEADERS += \
    icsettingshandler.h \
    safewindow.h \
    remotesettings_client.h \
    tcpmsghandler.h

QMAKE_RPATHDIR += $$QMAKE_REL_RPATH_BASE/$$relative_path($$INSTALL_PREFIX/neptune3/lib, $$INSTALL_PREFIX/neptune3/)
