QT += quick
CONFIG += c++11
TARGET = qmlapp
DESTDIR = ../qtivi

include($$SOURCE_DIR/config.pri)

LIBS += -L$$OUT_PWD/../../../lib -l$$qtLibraryTarget(RemoteSettings)

INCLUDEPATH += $$OUT_PWD/../frontend

SOURCES += main.cpp

RESOURCES += qml.qrc \
    app.qrc

#target.path = $$INSTALL_PREFIX/neptune3
#INSTALLS += target

QMAKE_RPATHDIR += $$QMAKE_REL_RPATH_BASE/$$relative_path($$INSTALL_PREFIX/neptune3/lib, $$INSTALL_PREFIX/neptune3/)
