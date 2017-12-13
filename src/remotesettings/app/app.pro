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

#target.path = $$INSTALL_PREFIX/triton
#INSTALLS += target

QMAKE_RPATHDIR += $ORIGIN/$$relative_path($$INSTALL_PREFIX/triton/lib, $$INSTALL_PREFIX/triton/)
